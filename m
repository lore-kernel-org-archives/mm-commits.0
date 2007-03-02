From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:08 -0800
Message-ID: <200703020457.l224v8DF000502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXCBE5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: fix patch site clobbers to include return register
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch

This patch was dropped because Zach's patches destroyed it all

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
