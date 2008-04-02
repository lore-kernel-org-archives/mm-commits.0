From: akpm@linux-foundation.org
Subject: - bttv-fix-missed-index-check.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:08 -0700
Message-ID: <200804021920.m32JK8OX030241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759208AbYDBTUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bttv: fix missed index check
has been removed from the -mm tree.  Its filename was
     bttv-fix-missed-index-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bttv: fix missed index check
From: Cyrill Gorcunov <gorcunov@gmail.com>

We should check for proper index first

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bttv-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/media/video/bt8xx/bttv-driver.c~bttv-fix-missed-index-check drivers/media/video/bt8xx/bttv-driver.c
--- a/drivers/media/video/bt8xx/bttv-driver.c~bttv-fix-missed-index-check
+++ a/drivers/media/video/bt8xx/bttv-driver.c
@@ -3518,8 +3518,12 @@ static int radio_enum_input(struct file 
 static int radio_g_audio(struct file *file, void *priv,
 					struct v4l2_audio *a)
 {
+	if (a->index != 0)
+		return -EINVAL;
+
 	memset(a, 0, sizeof(*a));
 	strcpy(a->name, "Radio");
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

