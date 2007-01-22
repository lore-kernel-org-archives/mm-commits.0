From: akpm@osdl.org
Subject: - git-mmc-build-fix.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:46:03 -0800
Message-ID: <200701222046.l0MKk35x001514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544AbXAVUqo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:46:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, drzeus@drzeus.cx, frederik.deweerdt@gmail.com, mm-commits@vger.kernel.org


The patch titled
     git-mmc: build fix
has been removed from the -mm tree.  Its filename was
     git-mmc-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-mmc: build fix
From: Frederik Deweerdt <deweerdt@free.fr>

drivers/mmc/mmc.c: In function 'mmc_lock_unlock':
drivers/mmc/mmc.c:1527: error: dereferencing pointer to incomplete type
drivers/mmc/mmc.c:1527: warning: type defaults to 'int' in declaration of '_________p1'
drivers/mmc/mmc.c:1527: error: dereferencing pointer to incomplete type
drivers/mmc/mmc.c:1527: warning: assignment makes pointer from integer without a cast

That's because mmc_lock_unlock should depend on CONFIG_KEYS, it uses struct key.
Could you try the following patch (compile tested)?

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/mmc.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/mmc/mmc.c~git-mmc-build-fix drivers/mmc/mmc.c
--- a/drivers/mmc/mmc.c~git-mmc-build-fix
+++ a/drivers/mmc/mmc.c
@@ -1503,6 +1503,8 @@ static void mmc_setup(struct mmc_host *h
 		mmc_process_ext_csds(host);
 }
 
+#ifdef CONFIG_MMC_PASSWORDS
+
 /**
  *	mmc_lock_unlock - send LOCK_UNLOCK command to a specific card.
  *	@card: card to which the LOCK_UNLOCK command should be sent
@@ -1617,6 +1619,8 @@ out:
 	return err;
 }
 
+#endif /* CONFIG_MMC_PASSWORDS */
+
 /**
  *	mmc_detect_change - process change of state on a MMC socket
  *	@host: host which changed state.
_

Patches currently in -mm which might be from deweerdt@free.fr are

git-acpi-early-acpi-lockup.patch
remove-tcp-header-from-tcp_v4_check-take-2.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
reiser4-sb_sync_inodes-fix.patch
