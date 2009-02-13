From: akpm@linux-foundation.org
Subject: + x86_32-fix-printk-formats.patch added to -mm tree
Date: Fri, 13 Feb 2009 15:29:52 -0800
Message-ID: <200902132329.n1DNTqOm008733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbZBMXaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 18:30:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     x86_32: fix printk formats
has been added to the -mm tree.  Its filename is
     x86_32-fix-printk-formats.patch

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
Subject: x86_32: fix printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings and also change 2 %ld to %lu for unsigned long
variables.

arch/x86/mm/init_32.c:727: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
arch/x86/mm/init_32.c:735: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_32.c~x86_32-fix-printk-formats arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86_32-fix-printk-formats
+++ a/arch/x86/mm/init_32.c
@@ -721,7 +721,7 @@ void __init find_low_pfn_range(void)
 			highmem_pages = 0;
 #ifdef CONFIG_HIGHMEM
 		if (highmem_pages >= max_pfn) {
-			printk(KERN_ERR "highmem size specified (%uMB) is "
+			printk(KERN_ERR "highmem size specified (%luMB) is "
 				"bigger than pages available (%luMB)!.\n",
 				pages_to_mb(highmem_pages),
 				pages_to_mb(max_pfn));
@@ -730,7 +730,7 @@ void __init find_low_pfn_range(void)
 		if (highmem_pages) {
 			if (max_low_pfn - highmem_pages <
 			    64*1024*1024/PAGE_SIZE){
-				printk(KERN_ERR "highmem size %uMB results in "
+				printk(KERN_ERR "highmem size %luMB results in "
 				"smaller than 64MB lowmem, ignoring it.\n"
 					, pages_to_mb(highmem_pages));
 				highmem_pages = 0;
@@ -755,7 +755,7 @@ void __init initmem_init(unsigned long s
 		highstart_pfn = max_low_pfn;
 	memory_present(0, 0, highend_pfn);
 	e820_register_active_regions(0, 0, highend_pfn);
-	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
+	printk(KERN_NOTICE "%luMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
@@ -768,7 +768,7 @@ void __init initmem_init(unsigned long s
 #ifdef CONFIG_FLATMEM
 	max_mapnr = num_physpages;
 #endif
-	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
+	printk(KERN_NOTICE "%luMB LOWMEM available.\n",
 			pages_to_mb(max_low_pfn));
 
 	setup_bootmem_allocator();
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uv-fix-header-struct-usage.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
x86_32-fix-printk-formats.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
docbook-split-kernel-api-add-device-drivers-book.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

