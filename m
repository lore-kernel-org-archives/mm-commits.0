From: akpm@linux-foundation.org
Subject: - bttv-bt832-fix-possible-null-pointer-deref.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:06 -0700
Message-ID: <200804021920.m32JK6Yc030238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756435AbYDBTUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     bttv: Bt832 - fix possible NULL pointer deref
has been removed from the -mm tree.  Its filename was
     bttv-bt832-fix-possible-null-pointer-deref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-avr32.patch
git-dvb.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

