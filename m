From: akpm@linux-foundation.org
Subject: - dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:49 -0700
Message-ID: <200708141912.l7EJCnZl016438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765764AbXHNTUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, ian.mcdonald@jandi.co.nz, mm-commits@vger.kernel.org


The patch titled
     dccp: fix memory leak and clean up style - dccp_feat_empty_confirm()
has been removed from the -mm tree.  Its filename was
     dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dccp: fix memory leak and clean up style - dccp_feat_empty_confirm()
From: Jesper Juhl <jesper.juhl@gmail.com>

There's a memory leak in net/dccp/feat.c::dccp_feat_empty_confirm().  If we
hit the 'default:' case of the 'switch' statement, then we return without
freeing 'opt', thus leaking 'struct dccp_opt_pend' bytes.

The leak is fixed easily enough by adding a kfree(opt); before the return
statement.

The patch also changes the layout of the 'switch' to be more in line with
CodingStyle.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/feat.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN net/dccp/feat.c~dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm net/dccp/feat.c
--- a/net/dccp/feat.c~dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm
+++ a/net/dccp/feat.c
@@ -327,10 +327,16 @@ static void dccp_feat_empty_confirm(stru
 	}
 
 	switch (type) {
-	case DCCPO_CHANGE_L: opt->dccpop_type = DCCPO_CONFIRM_R; break;
-	case DCCPO_CHANGE_R: opt->dccpop_type = DCCPO_CONFIRM_L; break;
-	default:	     DCCP_WARN("invalid type %d\n", type); return;
-
+	case DCCPO_CHANGE_L:
+		opt->dccpop_type = DCCPO_CONFIRM_R;
+		break;
+	case DCCPO_CHANGE_R:
+		opt->dccpop_type = DCCPO_CONFIRM_L;
+		break;
+	default:
+		DCCP_WARN("invalid type %d\n", type);
+		kfree(opt);
+		return;
 	}
 	opt->dccpop_feat = feature;
 	opt->dccpop_val	 = NULL;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
