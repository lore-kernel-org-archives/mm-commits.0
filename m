From: akpm@linux-foundation.org
Subject: + use-extended-crashkernel-command-line-on-ia64.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:26:49 -0700
Message-ID: <200709210726.l8L7QnMS024519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbXIUH2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, tony.luck@intel.com, vgoyal@in.ibm.com


The patch titled
     Use extended crashkernel command line on ia64
has been added to the -mm tree.  Its filename is
     use-extended-crashkernel-command-line-on-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use extended crashkernel command line on ia64
From: Bernhard Walle <bwalle@suse.de>

This patch adapts IA64 to use the generic parse_crashkernel() function instead
of its own parsing for the crashkernel command line.

Because the total amount of System RAM must be known when calling this
function, efi_memmap_init() is modified to return its accumulated total_memory
variable.

Also, the crashkernel handling is moved in an own function in
arch/ia64/kernel/setup.c to make the code more readable.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c     |    4 +
 arch/ia64/kernel/setup.c   |   88 ++++++++++++++++++-----------------
 include/asm-ia64/meminit.h |    2 
 3 files changed, 50 insertions(+), 44 deletions(-)

diff -puN arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64 arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~use-extended-crashkernel-command-line-on-ia64
+++ a/arch/ia64/kernel/efi.c
@@ -967,7 +967,7 @@ find_memmap_space (void)
  * to use.  We can allocate partial granules only if the unavailable
  * parts exist, and are WB.
  */
-void
+unsigned long
 efi_memmap_init(unsigned long *s, unsigned long *e)
 {
 	struct kern_memdesc *k, *prev = NULL;
@@ -1084,6 +1084,8 @@ efi_memmap_init(unsigned long *s, unsign
 	/* reserve the memory we are using for kern_memmap */
 	*s = (u64)kern_memmap;
 	*e = (u64)++k;
+
+	return total_memory;
 }
 
 void
diff -puN arch/ia64/kernel/setup.c~use-extended-crashkernel-command-line-on-ia64 arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~use-extended-crashkernel-command-line-on-ia64
+++ a/arch/ia64/kernel/setup.c
@@ -208,6 +208,48 @@ static int __init register_memory(void)
 
 __initcall(register_memory);
 
+
+#ifdef CONFIG_KEXEC
+static void __init setup_crashkernel(unsigned long total, int *n)
+{
+	unsigned long long base = 0, size = 0;
+	int ret;
+
+	ret = parse_crashkernel(boot_command_line, total,
+			&size, &base);
+	if (ret == 0 && size > 0) {
+		if (!base) {
+			sort_regions(rsvd_region, *n);
+			base = kdump_find_rsvd_region(size,
+					rsvd_region, *n);
+		}
+		if (base != ~0UL) {
+			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+					"for crashkernel (System RAM: %ldMB)\n",
+					(unsigned long)(size >> 20),
+					(unsigned long)(base >> 20),
+					(unsigned long)(total >> 20));
+			rsvd_region[*n].start =
+				(unsigned long)__va(base);
+			rsvd_region[*n].end =
+				(unsigned long)__va(base + size);
+			(*n)++;
+			crashk_res.start = base;
+			crashk_res.end = base + size - 1;
+		}
+	}
+	efi_memmap_res.start = ia64_boot_param->efi_memmap;
+	efi_memmap_res.end = efi_memmap_res.start +
+		ia64_boot_param->efi_memmap_size;
+	boot_param_res.start = __pa(ia64_boot_param);
+	boot_param_res.end = boot_param_res.start +
+		sizeof(*ia64_boot_param);
+}
+#else
+static inline void __init setup_crashkernel(unsigned long total, int *n)
+{}
+#endif
+
 /**
  * reserve_memory - setup reserved memory areas
  *
@@ -219,6 +261,7 @@ void __init
 reserve_memory (void)
 {
 	int n = 0;
+	unsigned long total_memory = 0;
 
 	/*
 	 * none of the entries in this table overlap
@@ -254,50 +297,11 @@ reserve_memory (void)
 		n++;
 #endif
 
-	efi_memmap_init(&rsvd_region[n].start, &rsvd_region[n].end);
+	total_memory = efi_memmap_init(&rsvd_region[n].start, &rsvd_region[n].end);
 	n++;
 
-#ifdef CONFIG_KEXEC
-	/* crashkernel=size@offset specifies the size to reserve for a crash
-	 * kernel. If offset is 0, then it is determined automatically.
-	 * By reserving this memory we guarantee that linux never set's it
-	 * up as a DMA target.Useful for holding code to do something
-	 * appropriate after a kernel panic.
-	 */
-	{
-		char *from = strstr(boot_command_line, "crashkernel=");
-		unsigned long base, size;
-		if (from) {
-			size = memparse(from + 12, &from);
-			if (*from == '@')
-				base = memparse(from+1, &from);
-			else
-				base = 0;
-			if (size) {
-				if (!base) {
-					sort_regions(rsvd_region, n);
-					base = kdump_find_rsvd_region(size,
-							      	rsvd_region, n);
-					}
-				if (base != ~0UL) {
-					rsvd_region[n].start =
-						(unsigned long)__va(base);
-					rsvd_region[n].end =
-						(unsigned long)__va(base + size);
-					n++;
-					crashk_res.start = base;
-					crashk_res.end = base + size - 1;
-				}
-			}
-		}
-		efi_memmap_res.start = ia64_boot_param->efi_memmap;
-                efi_memmap_res.end = efi_memmap_res.start +
-                        ia64_boot_param->efi_memmap_size;
-                boot_param_res.start = __pa(ia64_boot_param);
-                boot_param_res.end = boot_param_res.start +
-                        sizeof(*ia64_boot_param);
-	}
-#endif
+	setup_crashkernel(total_memory, &n);
+
 	/* end of memory marker */
 	rsvd_region[n].start = ~0UL;
 	rsvd_region[n].end   = ~0UL;
diff -puN include/asm-ia64/meminit.h~use-extended-crashkernel-command-line-on-ia64 include/asm-ia64/meminit.h
--- a/include/asm-ia64/meminit.h~use-extended-crashkernel-command-line-on-ia64
+++ a/include/asm-ia64/meminit.h
@@ -35,7 +35,7 @@ extern void find_memory (void);
 extern void reserve_memory (void);
 extern void find_initrd (void);
 extern int filter_rsvd_memory (unsigned long start, unsigned long end, void *arg);
-extern void efi_memmap_init(unsigned long *, unsigned long *);
+extern unsigned long efi_memmap_init(unsigned long *s, unsigned long *e);
 extern int find_max_min_low_pfn (unsigned long , unsigned long, void *);
 
 extern unsigned long vmcore_find_descriptor_size(unsigned long address);
_

Patches currently in -mm which might be from bwalle@suse.de are

add-vmcoreinfo.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
