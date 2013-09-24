From: akpm@linux-foundation.org
Subject: + fs-bio-integrityc-remove-duplicate-code.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:22:41 -0700
Message-ID: <52421ec1.DJSXx+06C2vOgRL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3IXXWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, martin.petersen@oracle.com, axboe@kernel.dk, guz.fnst@cn.fujitsu.com

Subject: + fs-bio-integrityc-remove-duplicate-code.patch added to -mm tree
To: guz.fnst@cn.fujitsu.com,axboe@kernel.dk,martin.petersen@oracle.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:22:41 -0700


The patch titled
     Subject: fs/bio-integrity.c: remove duplicate code
has been added to the -mm tree.  Its filename is
     fs-bio-integrityc-remove-duplicate-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-bio-integrityc-remove-duplicate-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-bio-integrityc-remove-duplicate-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/bio-integrity.c: remove duplicate code

Most code of function bio_integrity_verify and bio_integrity_generate is
the same, so introduce a common function bio_integrity_generate_verify()
to remove the reduplicate code.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c |   86 +++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff -puN fs/bio-integrity.c~fs-bio-integrityc-remove-duplicate-code fs/bio-integrity.c
--- a/fs/bio-integrity.c~fs-bio-integrityc-remove-duplicate-code
+++ a/fs/bio-integrity.c
@@ -287,24 +287,25 @@ int bio_integrity_get_tag(struct bio *bi
 EXPORT_SYMBOL(bio_integrity_get_tag);
 
 /**
- * bio_integrity_generate - Generate integrity metadata for a bio
- * @bio:	bio to generate integrity metadata for
- *
- * Description: Generates integrity metadata for a bio by calling the
- * block device's generation callback function.  The bio must have a
- * bip attached with enough room to accommodate the generated
- * integrity metadata.
+ * bio_integrity_generate_verify - Generate/verify integrity metadata for a bio
+ * @bio:	bio to generate/verify integrity metadata for
+ * @operate:	operate number, 1 for generate, 0 for verify
  */
-static void bio_integrity_generate(struct bio *bio)
+static int bio_integrity_generate_verify(struct bio *bio, int operate)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
-	sector_t sector = bio->bi_sector;
-	unsigned int i, sectors, total;
+	sector_t sector;
+	unsigned int i, sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
-	total = 0;
+	if (operate)
+		sector = bio->bi_sector;
+	else
+		sector = bio->bi_integrity->bip_sector;
+
+	ret = total = 0;
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
@@ -314,8 +315,15 @@ static void bio_integrity_generate(struc
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
 		bix.sector = sector;
-
-		bi->generate_fn(&bix);
+		if (operate) {
+			bi->generate_fn(&bix);
+		} else {
+			ret = bi->verify_fn(&bix);
+			if (ret) {
+				kunmap_atomic(kaddr);
+				return ret;
+			}
+		}
 
 		sectors = bv->bv_len / bi->sector_size;
 		sector += sectors;
@@ -325,6 +333,22 @@ static void bio_integrity_generate(struc
 
 		kunmap_atomic(kaddr);
 	}
+
+	return ret;
+}
+
+/**
+ * bio_integrity_generate - Generate integrity metadata for a bio
+ * @bio:	bio to generate integrity metadata for
+ *
+ * Description: Generates integrity metadata for a bio by calling the
+ * block device's generation callback function.  The bio must have a
+ * bip attached with enough room to accommodate the generated
+ * integrity metadata.
+ */
+static void bio_integrity_generate(struct bio *bio)
+{
+	bio_integrity_generate_verify(bio, 1);
 }
 
 static inline unsigned short blk_integrity_tuple_size(struct blk_integrity *bi)
@@ -439,41 +463,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_sector;
-	unsigned int i, sectors, total, ret;
-	void *prot_buf = bio->bi_integrity->bip_buf;
-
-	ret = total = 0;
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
-
-	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
-		bix.data_buf = kaddr + bv->bv_offset;
-		bix.data_size = bv->bv_len;
-		bix.prot_buf = prot_buf;
-		bix.sector = sector;
-
-		ret = bi->verify_fn(&bix);
-
-		if (ret) {
-			kunmap_atomic(kaddr);
-			return ret;
-		}
-
-		sectors = bv->bv_len / bi->sector_size;
-		sector += sectors;
-		prot_buf += sectors * bi->tuple_size;
-		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_size);
-
-		kunmap_atomic(kaddr);
-	}
