From: akpm@linux-foundation.org
Subject: + kernel-auditscc-fix-an-off-by-one.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:21:50 -0700
Message-ID: <200707262021.l6QKLoth019094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56781 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646AbXGZUWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, amy.griffis@hp.com, viro@zeniv.linux.org.uk


The patch titled
     kernel/auditsc.c: fix an off-by-one
has been added to the -mm tree.  Its filename is
     kernel-auditscc-fix-an-off-by-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/auditsc.c: fix an off-by-one
From: Adrian Bunk <bunk@stusta.de>

This patch fixes an off-by-one in a BUG_ON() spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Amy Griffis <amy.griffis@hp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/auditsc.c~kernel-auditscc-fix-an-off-by-one kernel/auditsc.c
--- a/kernel/auditsc.c~kernel-auditscc-fix-an-off-by-one
+++ a/kernel/auditsc.c
@@ -2232,7 +2232,7 @@ int __audit_signal_info(int sig, struct 
 		axp->d.next = ctx->aux_pids;
 		ctx->aux_pids = (void *)axp;
 	}
-	BUG_ON(axp->pid_count > AUDIT_AUX_PIDS);
+	BUG_ON(axp->pid_count >= AUDIT_AUX_PIDS);
 
 	axp->target_pid[axp->pid_count] = t->tgid;
 	selinux_get_task_sid(t, &axp->target_sid[axp->pid_count]);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
xenbus_xsc-fix-a-use-after-free.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
dvb-usb-af9005-fec-error-check-fixes.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
net-bluetooth-rfcomm-ttyc-use-after-free.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
