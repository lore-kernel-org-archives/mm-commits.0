From: akpm@linux-foundation.org
Subject: + bttv-fix-missed-index-check.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:40:37 -0700
Message-ID: <200804012240.m31Mebll017354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbYDAWkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, mchehab@infradead.org


The patch titled
     bttv: fix missed index check
has been added to the -mm tree.  Its filename is
     bttv-fix-missed-index-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-avr32.patch
bttv-bt832-fix-possible-null-pointer-deref.patch
bttv-fix-missed-index-check.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

