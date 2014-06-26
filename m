From: akpm@linux-foundation.org
Subject: +
 bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix.patch added to -mm tree
Date: Thu, 26 Jun 2014 13:18:56 -0700
Message-ID: <53ac8030.NLoFyVwv9wbkFxf2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaFZUS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 16:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.lei@canonical.com, axboe@kernel.dk, dongsu.park@profitbricks.com, hch@lst.de, jet.chen@intel.com, kmo@daterainc.com, mlombard@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block/bio.c: update bi_iter.bi_size before recounting segments
has been added to the -mm tree.  Its filename is
     bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: block/bio.c: update bi_iter.bi_size before recounting segments

The patch of "bio: modify __bio_add_page() to accept pages that
don't start a new segment" changes the way for adding one page
to bio:

	- previously by adding page after checking successfully
	- now by trying to add page and recover if it fails

Unfortunately the patch forgets to update bio->bi_iter.bi_size
before trying to add page, then the last vector for holding
the added page may not be covered if recouning segments is needed,
so bio->bi_phys_segments may become not consistent with the
actual bio page buffers after the page is added successfully
to the bio(after bi_iter.bi_size is added by 'len')

Suppose the page in the last vector can't be merged to bio, tragedy
will happen when __bio_add_page() is called to add another page:

	- blk_recount_segments() is called and the actual segments get
	figured out correctly

	- the actual segments may become queue_max_segments(q) plus one
	in failure path

	- driver will find the segment count is too big to handle.

The patch fixes the virtio-blk oops bug reported from Jet Chen in
below link:

	http://marc.info/?l=linux-kernel&m=140113053817095&w=2

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/bio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix block/bio.c
--- a/block/bio.c~bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix
+++ a/block/bio.c
@@ -744,6 +744,7 @@ static int __bio_add_page(struct request
 				}
 			}
 
+			bio->bi_iter.bi_size += len;
 			goto done;
 		}
 	}
@@ -761,6 +762,7 @@ static int __bio_add_page(struct request
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
+	bio->bi_iter.bi_size += len;
 
 	/*
 	 * Perform a recount if the number of segments is greater
@@ -802,7 +804,6 @@ static int __bio_add_page(struct request
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
  done:
-	bio->bi_iter.bi_size += len;
 	return len;
 
  failed:
@@ -810,6 +811,7 @@ static int __bio_add_page(struct request
 	bvec->bv_len = 0;
 	bvec->bv_offset = 0;
 	bio->bi_vcnt--;
+	bio->bi_iter.bi_size -= len;
 	blk_recount_segments(q, bio);
 	return 0;
 }
_

Patches currently in -mm which might be from ming.lei@canonical.com are

block-bioc-update-bi_iterbi_size-before-recounting-segments.patch
bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-fix.patch

