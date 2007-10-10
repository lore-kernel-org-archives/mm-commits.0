From: akpm@linux-foundation.org
Subject: - drivers-scsi-immc-fix-check-after-use.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:11:04 -0700
Message-ID: <200710102111.l9ALB4j7025993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbXJJVV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/imm.c: fix check-after-use
has been removed from the -mm tree.  Its filename was
     drivers-scsi-immc-fix-check-after-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/imm.c: fix check-after-use
From: Adrian Bunk <bunk@kernel.org>

The Coverity checker spotted that we have already oops'ed if "cmd"
was NULL.

Since "cmd" being NULL doesn't seem to be possible at this point this
patch removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/imm.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/imm.c~drivers-scsi-immc-fix-check-after-use drivers/scsi/imm.c
--- a/drivers/scsi/imm.c~drivers-scsi-immc-fix-check-after-use
+++ a/drivers/scsi/imm.c
@@ -740,10 +740,6 @@ static void imm_interrupt(struct work_st
 	struct Scsi_Host *host = cmd->device->host;
 	unsigned long flags;
 
-	if (!cmd) {
-		printk("IMM: bug in imm_interrupt\n");
-		return;
-	}
 	if (imm_engine(dev, cmd)) {
 		schedule_delayed_work(&dev->imm_tq, 1);
 		return;
_

Patches currently in -mm which might be from bunk@kernel.org are

git-alsa.patch
git-arm.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-net.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
git-scsi-misc.patch
git-block.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
isdn-hisax-hfc_usbc-fix-check-after-use.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
