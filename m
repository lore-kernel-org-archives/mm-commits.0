From: akpm@linux-foundation.org
Subject: +
 bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch added to -mm tree
Date: Thu, 01 May 2014 12:50:10 -0700
Message-ID: <5362a572.Uf3wbGEMrJ5fdJP5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEATuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2014 15:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, kmo@daterainc.com, hch@lst.de, axboe@kernel.dk, mlombard@redhat.com

Subject: + bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch added to -mm tree
To: mlombard@redhat.com,axboe@kernel.dk,hch@lst.de,kmo@daterainc.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 01 May 2014 12:50:10 -0700


The patch titled
     Subject: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3
has been added to the -mm tree.  Its filename is
     bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/bio.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3 fs/bio.c
--- a/fs/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3
+++ a/fs/bio.c
@@ -699,7 +699,6 @@ static int __bio_add_page(struct request
 			  unsigned int max_sectors)
 {
 	int retried_segments = 0;
-	unsigned int bi_phys_segments_orig;
 	struct bio_vec *bvec;
 
 	/*
@@ -759,7 +758,6 @@ static int __bio_add_page(struct request
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
-	bi_phys_segments_orig = bio->bi_phys_segments;
 	bio->bi_phys_segments++;
 
 	/*
@@ -810,8 +808,7 @@ static int __bio_add_page(struct request
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
-	bio->bi_phys_segments = bi_phys_segments_orig;
