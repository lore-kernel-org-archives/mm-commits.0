From: akpm@linux-foundation.org
Subject: + dm-crypt-add-null-iv.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:44 -0700
Message-ID: <200705090054.l490siK1006370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968414AbXEIAzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ludwig.nussel@suse.de, agk@redhat.com, christophe@saout.de


The patch titled
     dm crypt: add null iv
has been added to the -mm tree.  Its filename is
     dm-crypt-add-null-iv.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm crypt: add null iv
From: Ludwig Nussel <ludwig.nussel@suse.de>

Add a new IV generation method 'null' to read old filesystem images created
with SuSE's loop_fish2 module.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Acked-By: Christophe Saout <christophe@saout.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/md/dm-crypt.c~dm-crypt-add-null-iv drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-add-null-iv
+++ a/drivers/md/dm-crypt.c
@@ -121,6 +121,9 @@ static void clone_init(struct crypt_io *
  * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
  *        (needed for LRW-32-AES and possible other narrow block modes)
  *
+ * null: the initial vector is always zero.  Provides compatibility with
+ *       obsolete loop_fish2 devices.  Do not use for new devices.
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -257,6 +260,13 @@ static int crypt_iv_benbi_gen(struct cry
 	return 0;
 }
 
+static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+{
+	memset(iv, 0, cc->iv_size);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -273,6 +283,10 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_benbi_gen
 };
 
+static struct crypt_iv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
+
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
                           struct scatterlist *in, unsigned int length,
@@ -803,6 +817,8 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
 	else if (strcmp(ivmode, "benbi") == 0)
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ivmode, "null") == 0)
+		cc->iv_gen_ops = &crypt_iv_null_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;
@@ -1030,7 +1046,7 @@ error:
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version= {1, 3, 0},
+	.version= {1, 5, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
_

Patches currently in -mm which might be from ludwig.nussel@suse.de are

dm-crypt-add-null-iv.patch
