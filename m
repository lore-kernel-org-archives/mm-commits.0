From: akpm@linux-foundation.org
Subject: + bttv-bt832-fix-possible-null-pointer-deref.patch added to -mm tree
Date: Tue, 01 Apr 2008 15:40:35 -0700
Message-ID: <200804012240.m31MeZ1T017351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbYDAWkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 18:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, mchehab@infradead.org


The patch titled
     bttv: Bt832 - fix possible NULL pointer deref
has been added to the -mm tree.  Its filename is
     bttv-bt832-fix-possible-null-pointer-deref.patch

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
Subject: bttv: Bt832 - fix possible NULL pointer deref
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does fix potential NULL pointer dereference

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bt8xx/bt832.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/bt8xx/bt832.c~bttv-bt832-fix-possible-null-pointer-deref drivers/media/video/bt8xx/bt832.c
--- a/drivers/media/video/bt8xx/bt832.c~bttv-bt832-fix-possible-null-pointer-deref
+++ a/drivers/media/video/bt8xx/bt832.c
@@ -97,6 +97,11 @@ int bt832_init(struct i2c_client *i2c_cl
 	int rc;
 
 	buf=kmalloc(65,GFP_KERNEL);
+	if (!buf) {
+		v4l_err(&t->client,
+			"Unable to allocate memory. Detaching.\n");
+		return 0;
+	}
 	bt832_hexdump(i2c_client_s,buf);
 
 	if(buf[0x40] != 0x31) {
@@ -211,7 +216,12 @@ bt832_command(struct i2c_client *client,
 	switch (cmd) {
 		case BT832_HEXDUMP: {
 			unsigned char *buf;
-			buf=kmalloc(65,GFP_KERNEL);
+			buf=kmalloc(65, GFP_KERNEL);
+			if (!buf) {
+				v4l_err(&t->client,
+					"Unable to allocate memory\n");
+				break;
+			}
 			bt832_hexdump(&t->client,buf);
 			kfree(buf);
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

