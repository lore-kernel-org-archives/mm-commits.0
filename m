From: akpm@linux-foundation.org
Subject: - drivers-media-video-em28xx-correct-use-of-and.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:08 -0800
Message-ID: <200803042010.m24KA8vP026883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765928AbYCDUKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:10:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/em28xx: correct use of ! and &
has been removed from the -mm tree.  Its filename was
     drivers-media-video-em28xx-correct-use-of-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/em28xx: correct use of ! and &
From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/em28xx/em28xx-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/em28xx/em28xx-core.c~drivers-media-video-em28xx-correct-use-of-and drivers/media/video/em28xx/em28xx-core.c
--- a/drivers/media/video/em28xx/em28xx-core.c~drivers-media-video-em28xx-correct-use-of-and
+++ a/drivers/media/video/em28xx/em28xx-core.c
@@ -267,7 +267,7 @@ static int em28xx_write_ac97(struct em28
 	for (i = 0; i < 10; i++) {
 		if ((ret = em28xx_read_reg(dev, AC97BUSY_REG)) < 0)
 			return ret;
-		if (!((u8) ret) & 0x01)
+		if (!(((u8)ret) & 0x01))
 			return 0;
 		msleep(5);
 	}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
sound-use-bug_on.patch
git-powerpc.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
fs-ocfs2-use-bug_on.patch
drivers-block-viodasdc-use-field_sizeof.patch
usb-use-div_round_up.patch
drivers-char-isicomc-correct-use-of-and.patch
drivers-isdn-correct-use-of-and.patch
drivers-serial-m32r_sioc-correct-use-of-and.patch
fs-reiserfs-superc-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

