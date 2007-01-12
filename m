From: akpm@osdl.org
Subject: + git-mmc-build-fix.patch added to -mm tree
Date: Fri, 12 Jan 2007 14:52:01 -0800
Message-ID: <200701122252.l0CMq1jq031457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161144AbXALWwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jan 2007 17:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, drzeus@drzeus.cx, frederik.deweerdt@gmail.com


The patch titled
     git-mmc: build fix
has been added to the -mm tree.  Its filename is
     git-mmc-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix2-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-mmc-build-fix.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
reiser4-sb_sync_inodes-fix.patch
