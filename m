From: akpm@linux-foundation.org
Subject: [folded-merged]
 bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch removed from -mm tree
Date: Mon, 09 Jun 2014 16:07:19 -0700
Message-ID: <53963e27.BXaeaP/1KwhCnZQf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051AbaFIXHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 19:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kmo@daterainc.com, hch@lst.de, axboe@kernel.dk, mlombard@redhat.com

Subject: [folded-merged] bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch removed from -mm tree
To: mlombard@redhat.com,axboe@kernel.dk,hch@lst.de,kmo@daterainc.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 16:07:19 -0700


The patch titled
     Subject: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3
has been removed from the -mm tree.  Its filename was
     bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch

This patch was dropped because it was folded into bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment.patch

------------------------------------------------------
From: Maurizio Lombardi <mlombard@redhat.com>
Subject: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3

Changes in V3:

In case of error, V2 restored the previous number of segments but left
the BIO_SEG_FLAG set.
To avoid problems, after the page is removed from the bio vec,
V3 performs a recount of the segments in the error code path.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3 block/bio.c
--- a/block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3
+++ a/block/bio.c
@@ -701,7 +701,6 @@ static int __bio_add_page(struct request
 			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
-	unsigned int bi_phys_segments_orig;
 	struct bio_vec *bvec;
 
 	/*
@@ -761,7 +760,6 @@ static int __bio_add_page(struct request
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
-	bi_phys_segments_orig = bio->bi_phys_segments;
 	bio->bi_phys_segments++;
 
 	/*
@@ -812,8 +810,7 @@ static int __bio_add_page(struct request
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
-	bio->bi_phys_segments = bi_phys_segments_orig;
