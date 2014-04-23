From: akpm@linux-foundation.org
Subject: [merged] fs-bio-remove-bs-paramater-in-biovec_create_pool.patch
 removed from -mm tree
Date: Wed, 23 Apr 2014 10:55:44 -0700
Message-ID: <5357fea0.ETPPw3xujqip1YWv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaDWRzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 13:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, fabf@skynet.be

Subject: [merged] fs-bio-remove-bs-paramater-in-biovec_create_pool.patch removed from -mm tree
To: fabf@skynet.be,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 10:55:44 -0700


The patch titled
     Subject: fs/bio: remove bs paramater in biovec_create_pool
has been removed from the -mm tree.  Its filename was
     fs-bio-remove-bs-paramater-in-biovec_create_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/bio: remove bs paramater in biovec_create_pool

bs is no longer used in biovec_create_pool since 9f060e2231ca96 ("block:
Convert integrity to bvec_alloc_bs()")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c  |    2 +-
 fs/bio.c            |    4 ++--
 include/linux/bio.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/bio-integrity.c~fs-bio-remove-bs-paramater-in-biovec_create_pool fs/bio-integrity.c
--- a/fs/bio-integrity.c~fs-bio-remove-bs-paramater-in-biovec_create_pool
+++ a/fs/bio-integrity.c
@@ -617,7 +617,7 @@ int bioset_integrity_create(struct bio_s
 	if (!bs->bio_integrity_pool)
 		return -1;
 
-	bs->bvec_integrity_pool = biovec_create_pool(bs, pool_size);
+	bs->bvec_integrity_pool = biovec_create_pool(pool_size);
 	if (!bs->bvec_integrity_pool) {
 		mempool_destroy(bs->bio_integrity_pool);
 		return -1;
diff -puN fs/bio.c~fs-bio-remove-bs-paramater-in-biovec_create_pool fs/bio.c
--- a/fs/bio.c~fs-bio-remove-bs-paramater-in-biovec_create_pool
+++ a/fs/bio.c
@@ -1862,7 +1862,7 @@ EXPORT_SYMBOL_GPL(bio_trim);
  * create memory pools for biovec's in a bio_set.
  * use the global biovec slabs created for general use.
  */
-mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries)
+mempool_t *biovec_create_pool(int pool_entries)
 {
 	struct biovec_slab *bp = bvec_slabs + BIOVEC_MAX_IDX;
 
@@ -1925,7 +1925,7 @@ struct bio_set *bioset_create(unsigned i
 	if (!bs->bio_pool)
 		goto bad;
 
-	bs->bvec_pool = biovec_create_pool(bs, pool_size);
+	bs->bvec_pool = biovec_create_pool(pool_size);
 	if (!bs->bvec_pool)
 		goto bad;
 
diff -puN include/linux/bio.h~fs-bio-remove-bs-paramater-in-biovec_create_pool include/linux/bio.h
--- a/include/linux/bio.h~fs-bio-remove-bs-paramater-in-biovec_create_pool
+++ a/include/linux/bio.h
@@ -333,7 +333,7 @@ static inline struct bio *bio_next_split
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
-extern mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
+extern mempool_t *biovec_create_pool(int pool_entries);
 
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

