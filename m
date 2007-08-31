From: akpm@linux-foundation.org
Subject: + drivers-scsi-immc-fix-check-after-use.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:08:01 -0700
Message-ID: <200708311808.l7VI81fA019996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965714AbXHaSIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bunk@stusta.de


The patch titled
     drivers/scsi/imm.c: fix check-after-use
has been added to the -mm tree.  Its filename is
     drivers-scsi-immc-fix-check-after-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 4 deletions(-)

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

origin.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
ivtv-fbc-bugfix.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
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
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
