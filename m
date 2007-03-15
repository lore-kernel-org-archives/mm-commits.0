From: akpm@linux-foundation.org
Subject: - fix-vmi-and-compat_vdso.patch removed from -mm tree
Date: Thu, 15 Mar 2007 14:00:09 -0800
Message-ID: <200703152200.l2FM09k0027895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42647 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbXCOWAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix VMI and COMPAT_VDSO
has been removed from the -mm tree.  Its filename was
     fix-vmi-and-compat_vdso.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix VMI and COMPAT_VDSO
From: Zachary Amsden <zach@vmware.com>

VMI is broken under COMPAT_VDSO, as Xen and other non hardware assisted
hypervisors will be.  I have been working on a fix for this which works for
older glibcs that panic when the new relocatable VDSO is used.  However, I
believe at this time that the fix is going to be too radical to consider at
this stage in the release of 2.6.21.  We don't expect this config option to
be turned on by vendors for new distributions, so at this point we are
willing to drop support for it when VMI is compiled in, and work on a patch
for 2.6.22 which more fully addresses the problem.

Cc: Andi Kleen <ak@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~fix-vmi-and-compat_vdso arch/i386/Kconfig
--- a/arch/i386/Kconfig~fix-vmi-and-compat_vdso
+++ a/arch/i386/Kconfig
@@ -221,7 +221,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT
+	depends on PARAVIRT && !COMPAT_VDSO
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
paravirt-build-fixes.patch
make-struct-vmi_ops-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
replace-get_scheduled_cycles-with-sched_clock-paravirt_op.patch
