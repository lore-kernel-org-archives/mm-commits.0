From: akpm@linux-foundation.org
Subject: - video-limit-stack-usage-of-ir-kbd-i2cc.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:09:20 -0800
Message-ID: <200803042009.m24K9Kf2026742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761273AbYCDUJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, khali@linux-fr.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     video: limit stack usage of ir-kbd-i2c.c
has been removed from the -mm tree.  Its filename was
     video-limit-stack-usage-of-ir-kbd-i2cc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: limit stack usage of ir-kbd-i2c.c
From: Marcin Slusarz <marcin.slusarz@gmail.com>

ir_probe allocated struct i2c_client on stack; it's pretty big structure,
so allocate it with kzalloc

make checkstack output without this patch:
x059d ir_probe [ir-kbd-i2c]:                           1000

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ir-kbd-i2c.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/media/video/ir-kbd-i2c.c~video-limit-stack-usage-of-ir-kbd-i2cc drivers/media/video/ir-kbd-i2c.c
--- a/drivers/media/video/ir-kbd-i2c.c~video-limit-stack-usage-of-ir-kbd-i2cc
+++ a/drivers/media/video/ir-kbd-i2c.c
@@ -510,9 +510,9 @@ static int ir_probe(struct i2c_adapter *
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
 	static const int probe_cx23885[] = { 0x6b, -1 };
 	const int *probe = NULL;
-	struct i2c_client c;
+	struct i2c_client *c;
 	unsigned char buf;
-	int i,rc;
+	int i, rc;
 
 	switch (adap->id) {
 	case I2C_HW_B_BT848:
@@ -537,19 +537,23 @@ static int ir_probe(struct i2c_adapter *
 	if (NULL == probe)
 		return 0;
 
-	memset(&c,0,sizeof(c));
-	c.adapter = adap;
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->adapter = adap;
 	for (i = 0; -1 != probe[i]; i++) {
-		c.addr = probe[i];
-		rc = i2c_master_recv(&c,&buf,0);
+		c->addr = probe[i];
+		rc = i2c_master_recv(c, &buf, 0);
 		dprintk(1,"probe 0x%02x @ %s: %s\n",
 			probe[i], adap->name,
 			(0 == rc) ? "yes" : "no");
 		if (0 == rc) {
-			ir_attach(adap,probe[i],0,0);
+			ir_attach(adap, probe[i], 0, 0);
 			break;
 		}
 	}
+	kfree(c);
 	return 0;
 }
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
git-udf.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
git-ocfs2.patch
git-sched.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

