From: akpm@linux-foundation.org
Subject: - gdrom-fix-compile-error.patch removed from -mm tree
Date: Thu, 30 Oct 2008 02:17:11 -0700
Message-ID: <200810300917.m9U9HBUJ028164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbYJ3JRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 05:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iwamatsu@nigauri.org, lethal@linux-sh.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gdrom: fix compile error
has been removed from the -mm tree.  Its filename was
     gdrom-fix-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdrom: fix compile error
From: "Nobuhiro Iwamatsu" <iwamatsu@nigauri.org>

Return value and argument of block_device_operations.release of gdrom
was changed.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsunigauri.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/gdrom.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/cdrom/gdrom.c~gdrom-fix-compile-error drivers/cdrom/gdrom.c
--- a/drivers/cdrom/gdrom.c~gdrom-fix-compile-error
+++ a/drivers/cdrom/gdrom.c
@@ -495,9 +495,10 @@ static int gdrom_bdops_open(struct block
 	return cdrom_open(gd.cd_info, bdev, mode);
 }
 
-static int gdrom_bdops_release(struct block_device *bdev, fmode_t mode)
+static int gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 {
-	return cdrom_release(gd.cd_info, mode);
+	cdrom_release(gd.cd_info, mode);
+	return 0;
 }
 
 static int gdrom_bdops_mediachanged(struct gendisk *disk)
_

Patches currently in -mm which might be from iwamatsu@nigauri.org are

linux-next.patch
gdrom-fix-compile-error.patch

