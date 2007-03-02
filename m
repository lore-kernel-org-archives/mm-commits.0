From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:03:22 -0800
Message-ID: <200703020203.l2223Mei029572@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422768AbXCBCDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     xen-paravirt_ops: fix patch site clobbers to include return register
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen-paravirt_ops: fix patch site clobbers to include return register
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fix a few clobbers to include the return register.  The clobbers set is the
set of all registers modified (or may be modified) by the code snippet,
regardless of whether it was deliberate or accidental.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/paravirt.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register
+++ a/include/asm-i386/paravirt.h
@@ -518,7 +518,7 @@ static inline unsigned long __raw_local_
 					   "popl %%edx; popl %%ecx")
 			     : "=a"(f): "m"(paravirt_ops.save_fl),
 			       paravirt_type(PARAVIRT_PATCH(save_fl)),
-			       paravirt_clobber(CLBR_NONE)
+			       paravirt_clobber(CLBR_EAX)
 			     : "memory", "cc");
 	return f;
 }
@@ -572,7 +572,7 @@ static inline unsigned long __raw_local_
 				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
 
 #define STI_STRING _paravirt_alt("pushl %%ecx; pushl %%edx;"		\
-				"call *paravirt_ops+%c[irq_enable];"	\
+				 "call *paravirt_ops+%c[irq_enable];"	\
 				 "popl %%edx; popl %%ecx",		\
 				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
 
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
