From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 20 Apr 2020 20:07:21 -0700
Message-ID: <20200421030721.W7jbOlAM9%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDUDHX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 23:07:23 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@alien8.de, hpa@zytor.com, mingo@redhat.com, mjg59@google.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, rminnich@gmail.com, tglx@linutronix.de


The patch titled
     Subject: initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initrdmem%3D-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initrdmem%3D-option-to-specify-initrd-physical-address-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes

Cc: Borislav Petkov <bp@alien8.de>

WARNING: 'adddress' may be misspelled - perhaps 'address'?
#64: FILE: Documentation/admin-guide/kernel-parameters.txt:1717:
+    initrdmem=    [KNL] Specify a physical adddress and size from which

WARNING: please, no spaces at the start of a line
#82: FILE: arch/x86/kernel/setup.c:240:
+    if (ramdisk_image == 0) {$

WARNING: braces {} are not necessary for single statement blocks
#82: FILE: arch/x86/kernel/setup.c:240:
+    if (ramdisk_image == 0) {
+        ramdisk_image = phys_initrd_start;
+    }

ERROR: code indent should use tabs where possible
#83: FILE: arch/x86/kernel/setup.c:241:
+        ramdisk_image = phys_initrd_start;$

WARNING: please, no spaces at the start of a line
#83: FILE: arch/x86/kernel/setup.c:241:
+        ramdisk_image = phys_initrd_start;$

WARNING: please, no spaces at the start of a line
#84: FILE: arch/x86/kernel/setup.c:242:
+    }$

WARNING: please, no spaces at the start of a line
#92: FILE: arch/x86/kernel/setup.c:251:
+    if (ramdisk_size == 0) {$

WARNING: braces {} are not necessary for single statement blocks
#92: FILE: arch/x86/kernel/setup.c:251:
+    if (ramdisk_size == 0) {
+        ramdisk_size = phys_initrd_size;
+    }

ERROR: code indent should use tabs where possible
#93: FILE: arch/x86/kernel/setup.c:252:
+        ramdisk_size = phys_initrd_size;$

WARNING: please, no spaces at the start of a line
#93: FILE: arch/x86/kernel/setup.c:252:
+        ramdisk_size = phys_initrd_size;$

WARNING: please, no spaces at the start of a line
#94: FILE: arch/x86/kernel/setup.c:253:
+    }$

WARNING: please, no spaces at the start of a line
#124: FILE: init/do_mounts_initrd.c:55:
+    return early_initrdmem(p);$

WARNING: Missing Signed-off-by: line by nominal patch author 'ron minnich <rminnich@gmail.com>'

total: 2 errors, 11 warnings, 56 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/initrdmem=-option-to-specify-initrd-physical-address.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ronald G. Minnich <rminnich@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   12 ++++++------
 arch/x86/kernel/setup.c                         |   12 ++++++------
 init/do_mounts_initrd.c                         |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/setup.c~initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes
+++ a/arch/x86/kernel/setup.c
@@ -237,9 +237,9 @@ static u64 __init get_ramdisk_image(void
 
 	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;
 
-    if (ramdisk_image == 0) {
-        ramdisk_image = phys_initrd_start;
-    }
+	if (ramdisk_image == 0)
+		ramdisk_image = phys_initrd_start;
+
 	return ramdisk_image;
 }
 static u64 __init get_ramdisk_size(void)
@@ -248,9 +248,9 @@ static u64 __init get_ramdisk_size(void)
 
 	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;
 
-    if (ramdisk_size == 0) {
-        ramdisk_size = phys_initrd_size;
-    }
+	if (ramdisk_size == 0)
+		ramdisk_size = phys_initrd_size;
+
 	return ramdisk_size;
 }
 
--- a/Documentation/admin-guide/kernel-parameters.txt~initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1762,12 +1762,12 @@
 
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
-    initrdmem=    [KNL] Specify a physical adddress and size from which
-            to load the initrd. If an initrd is compiled in or
-            specified in the bootparams, it takes priority
-            over this setting.
-            Format: ss[KMG],nn[KMG]
-            Default is 0, 0
+	initrdmem=	[KNL] Specify a physical address and size from which to
+			load the initrd. If an initrd is compiled in or
+			specified in the bootparams, it takes priority over this
+			setting.
+			Format: ss[KMG],nn[KMG]
+			Default is 0, 0
 
 	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
 			zeroes.
--- a/init/do_mounts_initrd.c~initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes
+++ a/init/do_mounts_initrd.c
@@ -52,7 +52,7 @@ early_param("initrdmem", early_initrdmem
  */
 static int __init early_initrd(char *p)
 {
-    return early_initrdmem(p);
+	return early_initrdmem(p);
 }
 early_param("initrd", early_initrd);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
