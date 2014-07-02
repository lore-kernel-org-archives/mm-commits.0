From: akpm@linux-foundation.org
Subject: [merged]
 bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload.patch
 removed from -mm tree
Date: Wed, 02 Jul 2014 11:03:59 -0700
Message-ID: <53b4498f.bTkAMI+9YejycK6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:35510 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaGBSEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 14:04:00 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so1308855veb.5
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 11:04:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, axboe@kernel.dk, kmo@daterainc.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
has been removed from the -mm tree.  Its filename was
     bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload

Commit 08778795 ("block: Fix nr_vecs for inline integrity vectors") from
Martin introduces the function bip_integrity_vecs(get the useful vectors)
to fix the issue about nr_vecs for inline integrity vectors that reported
by David Milburn.

But it seems that bip_integrity_vecs() will return the wrong number if the
bio is not based on any bio_set for some reason(bio->bi_pool == NULL),
because in that case, the bip_inline_vecs[0] is malloced directly.  So
here we add the bip_max_vcnt to record the count of vector slots, and
cleanup the function bip_integrity_vecs().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio-integrity.c |   12 +++---------
 include/linux/bio.h   |    1 +
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -puN block/bio-integrity.c~bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload block/bio-integrity.c
--- a/block/bio-integrity.c~bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload
+++ a/block/bio-integrity.c
@@ -70,8 +70,10 @@ struct bio_integrity_payload *bio_integr
 					  bs->bvec_integrity_pool);
 		if (!bip->bip_vec)
 			goto err;
+		bip->bip_max_vcnt = bvec_nr_vecs(idx);
 	} else {
 		bip->bip_vec = bip->bip_inline_vecs;
+		bip->bip_max_vcnt = inline_vecs;
 	}
 
 	bip->bip_slab = idx;
@@ -114,14 +116,6 @@ void bio_integrity_free(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_free);
 
-static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
-{
-	if (bip->bip_slab == BIO_POOL_NONE)
-		return BIP_INLINE_VECS;
-
-	return bvec_nr_vecs(bip->bip_slab);
-}
-
 /**
  * bio_integrity_add_page - Attach integrity metadata
  * @bio:	bio to update
@@ -137,7 +131,7 @@ int bio_integrity_add_page(struct bio *b
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
+	if (bip->bip_vcnt >= bip->bip_max_vcnt) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
diff -puN include/linux/bio.h~bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload include/linux/bio.h
--- a/include/linux/bio.h~bio-integrity-add-bip_max_vcnt-into-struct-bio_integrity_payload
+++ a/include/linux/bio.h
@@ -308,6 +308,7 @@ struct bio_integrity_payload {
 
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
+	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned		bip_owns_buf:1;	/* should free bip_buf */
 
 	struct work_struct	bip_work;	/* I/O completion */
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch
linux-next.patch

