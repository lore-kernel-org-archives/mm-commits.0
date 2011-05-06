From: akpm@linux-foundation.org
Subject: + fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages.patch added to -mm tree
Date: Fri, 06 May 2011 12:31:02 -0700
Message-ID: <201105061931.p46JV3xN032090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1EFTbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2011 15:31:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, adobriyan@gmail.com


The patch titled
     fs/proc/vmcore.c: add hook to read_from_oldmem() to check for non-ram pages
has been added to the -mm tree.  Its filename is
     fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/proc/vmcore.c: add hook to read_from_oldmem() to check for non-ram pages
From: Olaf Hering <olaf@aepfle.de>

The balloon driver in a Xen guest frees guest pages and marks them as
mmio.  When the kernel crashes and the crash kernel attempts to read the
oldmem via /proc/vmcore a read from ballooned pages will generate 100%
load in dom0 because Xen asks qemu-dm for the page content.  Since the
reads come in as 8byte requests each ballooned page is tried 512 times.

With this change a hook can be registered which checks wether the given
pfn is really ram.  The hook has to return a value > 0 for ram pages, a
value < 0 on error (because the hypercall is not known) and 0 for non-ram
pages.

This will reduce the time to read /proc/vmcore.  Without this change a
512M guest with 128M crashkernel region needs 200 seconds to read it, with
this change it takes just 2 seconds.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |   52 ++++++++++++++++++++++++++++++++---
 include/linux/crash_dump.h |    5 +++
 2 files changed, 54 insertions(+), 3 deletions(-)

diff -puN fs/proc/vmcore.c~fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages
+++ a/fs/proc/vmcore.c
@@ -35,6 +35,46 @@ static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
 
+/*
+ * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
+ * The called function has to take care of module refcounting.
+ */
+static int (*oldmem_pfn_is_ram)(unsigned long pfn);
+
+int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn))
+{
+	if (oldmem_pfn_is_ram)
+		return -EBUSY;
+	oldmem_pfn_is_ram = fn;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
+
+void unregister_oldmem_pfn_is_ram(void)
+{
+	oldmem_pfn_is_ram = NULL;
+	wmb();
+}
+EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
+
+static int pfn_is_ram(unsigned long pfn)
+{
+	int (*fn)(unsigned long pfn);
+	/* pfn is ram unless fn() checks pagetype */
+	int ret = 1;
+
+	/*
+	 * Ask hypervisor if the pfn is really ram.
+	 * A ballooned page contains no data and reading from such a page
+	 * will cause high load in the hypervisor.
+	 */
+	fn = oldmem_pfn_is_ram;
+	if (fn)
+		ret = fn(pfn);
+
+	return ret;
+}
+
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
 				u64 *ppos, int userbuf)
@@ -55,9 +95,15 @@ static ssize_t read_from_oldmem(char *bu
 		else
 			nr_bytes = count;
 
-		tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);
-		if (tmp < 0)
-			return tmp;
+		/* If pfn is not ram, return zeros for sparse dump files */
+		if (pfn_is_ram(pfn) == 0)
+			memset(buf, 0, nr_bytes);
+		else {
+			tmp = copy_oldmem_page(pfn, buf, nr_bytes,
+						offset, userbuf);
+			if (tmp < 0)
+				return tmp;
+		}
 		*ppos += nr_bytes;
 		count -= nr_bytes;
 		buf += nr_bytes;
diff -puN include/linux/crash_dump.h~fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages
+++ a/include/linux/crash_dump.h
@@ -66,6 +66,11 @@ static inline void vmcore_unusable(void)
 	if (is_kdump_kernel())
 		elfcorehdr_addr = ELFCORE_ADDR_ERR;
 }
+
+#define HAVE_OLDMEM_PFN_IS_RAM 1
+extern int register_oldmem_pfn_is_ram(int (*fn)(unsigned long pfn));
+extern void unregister_oldmem_pfn_is_ram(void);
+
 #else /* !CONFIG_CRASH_DUMP */
 static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
_

Patches currently in -mm which might be from olaf@aepfle.de are

linux-next.patch
fs-proc-vmcorec-add-hook-to-read_from_oldmem-to-check-for-non-ram-pages.patch

