From: akpm@linux-foundation.org
Subject: + v4l-drx397xdc-sparse-annotations.patch added to -mm tree
Date: Tue, 29 Jul 2008 14:54:06 -0700
Message-ID: <200807292154.m6TLs6Jt023532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYG2VyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     v4l: drx397xD.c sparse annotations
has been added to the -mm tree.  Its filename is
     v4l-drx397xdc-sparse-annotations.patch

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
Subject: v4l: drx397xD.c sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/drx397xD.c |   14 +++++++-------
 drivers/media/dvb/frontends/drx397xD.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/media/dvb/frontends/drx397xD.c~v4l-drx397xdc-sparse-annotations drivers/media/dvb/frontends/drx397xD.c
--- a/drivers/media/dvb/frontends/drx397xD.c~v4l-drx397xdc-sparse-annotations
+++ a/drivers/media/dvb/frontends/drx397xD.c
@@ -235,11 +235,11 @@ static int write_fw(struct drx397xD_stat
 }
 
 /* Function is not endian safe, use the RD16 wrapper below */
-static int _read16(struct drx397xD_state *s, u32 i2c_adr)
+static int _read16(struct drx397xD_state *s, __le32 i2c_adr)
 {
 	int rc;
 	u8 a[4];
-	u16 v;
+	__le16 v;
 	struct i2c_msg msg[2] = {
 		{
 		 .addr = s->config.demod_address,
@@ -250,12 +250,12 @@ static int _read16(struct drx397xD_state
 		, {
 		   .addr = s->config.demod_address,
 		   .flags = I2C_M_RD,
-		   .buf = (u8 *) & v,
+		   .buf = (u8 *)&v,
 		   .len = sizeof(v)
 		   }
 	};
 
-	*(u32 *) a = i2c_adr;
+	*(__le32 *)a = i2c_adr;
 
 	rc = i2c_transfer(s->i2c, msg, 2);
 	if (rc != 2)
@@ -265,7 +265,7 @@ static int _read16(struct drx397xD_state
 }
 
 /* Function is not endian safe, use the WR16.. wrappers below */
-static int _write16(struct drx397xD_state *s, u32 i2c_adr, u16 val)
+static int _write16(struct drx397xD_state *s, __le32 i2c_adr, __le16 val)
 {
 	u8 a[6];
 	int rc;
@@ -276,8 +276,8 @@ static int _write16(struct drx397xD_stat
 		.len = sizeof(a)
 	};
 
-	*(u32 *) a = i2c_adr;
-	*(u16 *) & a[4] = val;
+	*(__le32 *)a = i2c_adr;
+	*(__le16 *)&a[4] = val;
 
 	rc = i2c_transfer(s->i2c, &msg, 1);
 	if (rc != 1)
diff -puN drivers/media/dvb/frontends/drx397xD.h~v4l-drx397xdc-sparse-annotations drivers/media/dvb/frontends/drx397xD.h
--- a/drivers/media/dvb/frontends/drx397xD.h~v4l-drx397xdc-sparse-annotations
+++ a/drivers/media/dvb/frontends/drx397xD.h
@@ -28,7 +28,7 @@
 #define DRX_F_OFFSET	36000000
 
 #define I2C_ADR_C0(x) \
-(	(u32)cpu_to_le32( \
+(	cpu_to_le32( \
 		(u32)( \
 			(((u32)(x) & (u32)0x000000ffUL)      ) | \
 			(((u32)(x) & (u32)0x0000ff00UL) << 16) | \
@@ -38,7 +38,7 @@
 )
 
 #define I2C_ADR_E0(x) \
-(	(u32)cpu_to_le32( \
+(	cpu_to_le32( \
 		(u32)( \
 			(((u32)(x) & (u32)0x000000ffUL)      ) | \
 			(((u32)(x) & (u32)0x0000ff00UL) << 16) | \
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

