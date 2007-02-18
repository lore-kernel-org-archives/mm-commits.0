From: akpm@linux-foundation.org
Subject: - revert-x86_64-mm-putreg-check.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:03:28 -0800
Message-ID: <200702180203.l1I23SkE008138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993067AbXBRCDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-mm-putreg-check
has been removed from the -mm tree.  Its filename was
     revert-x86_64-mm-putreg-check.patch

This patch was dropped because it is obsolete

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
xfs-warning-fix.patch
machzwd-warning-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
ichxrom-warning-fix.patch
jffs2-warning-fixes.patch
cafe-warning-fix.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
