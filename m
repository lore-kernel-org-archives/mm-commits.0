From: akpm@linux-foundation.org
Subject: [merged] bio-change-some-signed-vars-to-unsigned.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:50 -0800
Message-ID: <201111172021.pAHKLohC023408@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33229 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab1KQUVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:52 -0500
Received: by yenm10 with SMTP id m10so257075yen.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, axboe@kernel.dk, error27@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bio: change some signed vars to unsigned
has been removed from the -mm tree.  Its filename was
     bio-change-some-signed-vars-to-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: bio: change some signed vars to unsigned

This is just a cleanup patch to silence a static checker warning.

The problem is that we cap "nr_iovecs" so it can't be larger than
"UIO_MAXIOV" but we don't check for negative values.  It turns out this is
prevented at other layers, but logically it doesn't make sense to have
negative nr_iovecs so making it unsigned is nicer.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c            |    7 ++++---
 include/linux/bio.h |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/bio.c~bio-change-some-signed-vars-to-unsigned fs/bio.c
--- a/fs/bio.c~bio-change-some-signed-vars-to-unsigned
+++ a/fs/bio.c
@@ -337,7 +337,7 @@ static void bio_fs_destructor(struct bio
  *	RETURNS:
  *	Pointer to new bio on success, NULL on failure.
  */
-struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
 
@@ -365,7 +365,7 @@ static void bio_kmalloc_destructor(struc
  *   %__GFP_WAIT, the allocation is guaranteed to succeed.
  *
  **/
-struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	struct bio *bio;
 
@@ -696,7 +696,8 @@ static void bio_free_map_data(struct bio
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
+static struct bio_map_data *bio_alloc_map_data(int nr_segs,
+					       unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
diff -puN include/linux/bio.h~bio-change-some-signed-vars-to-unsigned include/linux/bio.h
--- a/include/linux/bio.h~bio-change-some-signed-vars-to-unsigned
+++ a/include/linux/bio.h
@@ -211,8 +211,8 @@ extern void bio_pair_release(struct bio_
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 
-extern struct bio *bio_alloc(gfp_t, int);
-extern struct bio *bio_kmalloc(gfp_t, int);
+extern struct bio *bio_alloc(gfp_t, unsigned int);
+extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

