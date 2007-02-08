From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-putreg-check.patch added to -mm tree
Date: Thu, 08 Feb 2007 13:49:43 -0800
Message-ID: <200702082149.l18LnhQJ027574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423456AbXBHVts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, rolandd@cisco.com


The patch titled
     revert x86_64-mm-putreg-check
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-putreg-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert x86_64-mm-putreg-check
From: Andrew Morton <akpm@linux-foundation.org>

Try to make it possible to carry the utrace patchset.

Cc: Roland Dreier <rolandd@cisco.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/ptrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/ptrace.c~revert-x86_64-mm-putreg-check arch/x86_64/kernel/ptrace.c
--- a/arch/x86_64/kernel/ptrace.c~revert-x86_64-mm-putreg-check
+++ a/arch/x86_64/kernel/ptrace.c
@@ -536,12 +536,8 @@ long arch_ptrace(struct task_struct *chi
 		}
 		ret = 0;
 		for (ui = 0; ui < sizeof(struct user_regs_struct); ui += sizeof(long)) {
-			ret = __get_user(tmp, (unsigned long __user *) data);
-			if (ret)
-				break;
-			ret = putreg(child, ui, tmp);
-			if (ret)
-				break;
+			ret |= __get_user(tmp, (unsigned long __user *) data);
+			putreg(child, ui, tmp);
 			data += sizeof(long);
 		}
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
utrace-i386-build-fix.patch
