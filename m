From: akpm@linux-foundation.org
Subject: + kdump-add-is_vmcore_usable-and-vmcore_unusable.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:59:12 -0700
Message-ID: <200808050959.m759xCGT028898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631AbYHEKAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 06:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@redhat.com


The patch titled
     kdump: add is_vmcore_usable() and vmcore_unusable()
has been added to the -mm tree.  Its filename is
     kdump-add-is_vmcore_usable-and-vmcore_unusable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: add is_vmcore_usable() and vmcore_unusable()
From: Simon Horman <horms@verge.net.au>

The usage of elfcorehdr_addr has changed recently such that being set to
ELFCORE_ADDR_MAX is used by is_kdump_kernel() to indicate if the code is
executing in a kernel executed as a crash kernel.

However, arch/ia64/kernel/setup.c:reserve_elfcorehdr will rest
elfcorehdr_addr to ELFCORE_ADDR_MAX on error, which means any subsequent
calls to is_kdump_kernel() will return 0, even though they should return
1.

Ok, at this point in time there are no subsequent calls, but I think its
fair to say that there is ample scope for error or at the very least
confusion.

This patch add an extra state, ELFCORE_ADDR_ERR, which indicates that
elfcorehdr_addr was passed on the command line, and thus execution is
taking place in a crashdump kernel, but vmcore can't be used for some
reason.  This is tested for using is_vmcore_usable() and set using
vmcore_unusable().  A subsequent patch makes use of this new code.

To summarise, the states that elfcorehdr_addr can now be in are as follows:

ELFCORE_ADDR_MAX: not a crashdump kernel
ELFCORE_ADDR_ERR: crashdump kernel but vmcore is unusable
any other value:  crash dump kernel and vmcore is usable

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c           |    2 +-
 include/linux/crash_dump.h |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff -puN fs/proc/vmcore.c~kdump-add-is_vmcore_usable-and-vmcore_unusable fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~kdump-add-is_vmcore_usable-and-vmcore_unusable
+++ a/fs/proc/vmcore.c
@@ -650,7 +650,7 @@ static int __init vmcore_init(void)
 	int rc = 0;
 
 	/* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
-	if (!(elfcorehdr_addr < ELFCORE_ADDR_MAX))
+	if (!(is_vmcore_usable()))
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
diff -puN include/linux/crash_dump.h~kdump-add-is_vmcore_usable-and-vmcore_unusable include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~kdump-add-is_vmcore_usable-and-vmcore_unusable
+++ a/include/linux/crash_dump.h
@@ -8,6 +8,7 @@
 #include <linux/proc_fs.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
+#define ELFCORE_ADDR_ERR	(-2ULL)
 
 extern unsigned long long elfcorehdr_addr;
 
@@ -42,5 +43,30 @@ static inline int is_kdump_kernel(void)
 static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
 
+#ifdef CONFIG_PROC_VMCORE
+/* is_vmcore_usable() checks if the kernel is booting after a panic and
+ * the vmcore region is usable.
+ *
+ * This makes use of the fact that due to alignment 1 is not
+ * a valid pointer, much in the vain of IS_ERR(), except
+ * dealing directly with an unsigned long long rather than a pointer.
+ */
+
+static inline int is_vmcore_usable(void)
+{
+	return is_kdump_kernel() && elfcorehdr_addr != ELFCORE_ADDR_ERR ? 1 : 0;
+}
+
+/* vmcore_unusable() marks the vmcore as unusable,
+ * without disturbing the logic of is_kdump_kernel()
+ */
+
+static inline void vmcore_unusable(void)
+{
+	if (is_kdump_kernel())
+		elfcorehdr_addr = ELFCORE_ADDR_ERR;
+}
+#endif /* CONFIG_PROC_VMCORE */
+
 extern unsigned long saved_max_pfn;
 #endif /* LINUX_CRASHDUMP_H */
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
linux-next.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

