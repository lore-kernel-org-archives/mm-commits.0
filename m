From: akpm@linux-foundation.org
Subject: [merged] fs-bio-integrity-remove-duplicate-code.patch removed
 from -mm tree
Date: Mon, 24 Feb 2014 12:39:51 -0800
Message-ID: <530bae17.KiQ7uyEmdtmW0n6z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaBXUjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 15:39:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org, kmo@daterainc.com, axboe@kernel.dk, guz.fnst@cn.fujitsu.com

Subject: [merged] fs-bio-integrity-remove-duplicate-code.patch removed from -mm tree
To: guz.fnst@cn.fujitsu.com,axboe@kernel.dk,kmo@daterainc.com,tj@kernel.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 12:39:51 -0800


The patch titled
     Subject: fs/bio-integrity: remove duplicate code
has been removed from the -mm tree.  Its filename was
     fs-bio-integrity-remove-duplicate-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: fs/bio-integrity: remove duplicate code

Most code in bio_integrity_verify() and bio_integrity_generate() is the
same, so introduce a helper function bio_integrity_generate_verify() to
remove the duplicate code.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c |   86 ++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 49 deletions(-)

diff -puN fs/bio-integrity.c~fs-bio-integrity-remove-duplicate-code fs/bio-integrity.c
--- a/fs/bio-integrity.c~fs-bio-integrity-remove-duplicate-code
+++ a/fs/bio-integrity.c
@@ -301,25 +301,26 @@ int bio_integrity_get_tag(struct bio *bi
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
 	struct bio_vec bv;
 	struct bvec_iter iter;
-	sector_t sector = bio->bi_iter.bi_sector;
-	unsigned int sectors, total;
+	sector_t sector;
+	unsigned int sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
-	total = 0;
+	if (operate)
+		sector = bio->bi_iter.bi_sector;
+	else
+		sector = bio->bi_integrity->bip_iter.bi_sector;
+
+	total = ret = 0;
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
@@ -330,7 +331,15 @@ static void bio_integrity_generate(struc
 		bix.prot_buf = prot_buf;
 		bix.sector = sector;
 
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
 
 		sectors = bv.bv_len / bi->sector_size;
 		sector += sectors;
@@ -340,6 +349,21 @@ static void bio_integrity_generate(struc
 
 		kunmap_atomic(kaddr);
 	}
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
@@ -454,43 +478,7 @@ EXPORT_SYMBOL(bio_integrity_prep);
  */
 static int bio_integrity_verify(struct bio *bio)
 {
-	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	struct blk_integrity_exchg bix;
-	struct bio_vec *bv;
-	sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
-	unsigned int sectors, total, ret;
-	void *prot_buf = bio->bi_integrity->bip_buf;
-	int i;
-
-	ret = total = 0;
-	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	bix.sector_size = bi->sector_size;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
-
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
-		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
-
-		kunmap_atomic(kaddr);
-	}
