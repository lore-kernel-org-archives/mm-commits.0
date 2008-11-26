From: akpm@linux-foundation.org
Subject: - ath5k-fix-security-issue-in-debugfs-part-of-ath5k.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:32 -0800
Message-ID: <200811262046.mAQKkW9N010890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYKZU5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:57:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, jeromepoulin@gmail.com, jirislaby@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: fix Security issue in DebugFS part of ath5k
has been removed from the -mm tree.  Its filename was
     ath5k-fix-security-issue-in-debugfs-part-of-ath5k.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ath5k: fix Security issue in DebugFS part of ath5k
=46rom: Cheng Renquan <crquan@gmail.com>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12076

Remove any write access to groups and others, only keep write permissio=
n
to its owner, usually only root user.

Reported-by: J=E9r=F4me Poulin <jeromepoulin@gmail.com>
Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/wireless/ath5k/debug.c~ath5k-fix-security-issue-i=
n-debugfs-part-of-ath5k drivers/net/wireless/ath5k/debug.c
--- a/drivers/net/wireless/ath5k/debug.c~ath5k-fix-security-issue-in-de=
bugfs-part-of-ath5k
+++ a/drivers/net/wireless/ath5k/debug.c
@@ -417,19 +417,19 @@ ath5k_debug_init_device(struct ath5k_sof
 	sc->debug.debugfs_phydir =3D debugfs_create_dir(wiphy_name(sc->hw->wi=
phy),
 				ath5k_global_debugfs);
=20
-	sc->debug.debugfs_debug =3D debugfs_create_file("debug", 0666,
+	sc->debug.debugfs_debug =3D debugfs_create_file("debug", S_IWUSR | S_=
IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_debug);
=20
-	sc->debug.debugfs_registers =3D debugfs_create_file("registers", 0444=
,
+	sc->debug.debugfs_registers =3D debugfs_create_file("registers", S_IR=
UGO,
 				sc->debug.debugfs_phydir, sc, &fops_registers);
=20
-	sc->debug.debugfs_tsf =3D debugfs_create_file("tsf", 0666,
+	sc->debug.debugfs_tsf =3D debugfs_create_file("tsf", S_IWUSR | S_IRUG=
O,
 				sc->debug.debugfs_phydir, sc, &fops_tsf);
=20
-	sc->debug.debugfs_beacon =3D debugfs_create_file("beacon", 0666,
+	sc->debug.debugfs_beacon =3D debugfs_create_file("beacon", S_IWUSR | =
S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
=20
-	sc->debug.debugfs_reset =3D debugfs_create_file("reset", 0222,
+	sc->debug.debugfs_reset =3D debugfs_create_file("reset", S_IWUSR,
 				sc->debug.debugfs_phydir, sc, &fops_reset);
 }
=20
_

Patches currently in -mm which might be from crquan@gmail.com are

linux-next.patch
block-remove-kblockd_flush_work.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization=
=2Epatch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
