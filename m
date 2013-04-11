From: akpm@linux-foundation.org
Subject: + mm-allow-for-outstanding-swap-writeback-accounting.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:11:39 -0700
Message-ID: <20130411231139.E080931C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:50444 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765536Ab3DKXLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:11:41 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so197220ggc.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:11:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, dan.magenheimer@oracle.com, konrad.wilk@oracle.com, minchan@kernel.org


The patch titled
     Subject: mm: allow for outstanding swap writeback accounting
has been added to the -mm tree.  Its filename is
     mm-allow-for-outstanding-swap-writeback-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: mm: allow for outstanding swap writeback accounting

To prevent flooding the swap device with writebacks, frontswap backends
need to count and limit the number of outstanding writebacks.  The
incrementing of the counter can be done before the call to
__swap_writepage().  However, the caller must receive a notification when
the writeback completes in order to decrement the counter.

To achieve this functionality, this patch modifies __swap_writepage() to
take the bio completion callback function as an argument.

end_swap_bio_write(), the normal bio completion function, is also made
non-static so that code doing the accounting can call it after the
accounting is done.

There should be no behavioural change to existing code.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 +++-
 mm/page_io.c         |    9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-allow-for-outstanding-swap-writeback-accounting include/linux/swap.h
--- a/include/linux/swap.h~mm-allow-for-outstanding-swap-writeback-accounting
+++ a/include/linux/swap.h
@@ -330,7 +330,9 @@ static inline void mem_cgroup_uncharge_s
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern int __swap_writepage(struct page *page, struct writeback_control *wbc);
+extern void end_swap_bio_write(struct bio *bio, int err);
+extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
+	void (*end_write_func)(struct bio *, int));
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
diff -puN mm/page_io.c~mm-allow-for-outstanding-swap-writeback-accounting mm/page_io.c
--- a/mm/page_io.c~mm-allow-for-outstanding-swap-writeback-accounting
+++ a/mm/page_io.c
@@ -41,7 +41,7 @@ static struct bio *get_swap_bio(gfp_t gf
 	return bio;
 }
 
-static void end_swap_bio_write(struct bio *bio, int err)
+void end_swap_bio_write(struct bio *bio, int err)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -196,12 +196,13 @@ int swap_writepage(struct page *page, st
 		end_page_writeback(page);
 		goto out;
 	}
-	ret = __swap_writepage(page, wbc);
+	ret = __swap_writepage(page, wbc, end_swap_bio_write);
 out:
 	return ret;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc)
+int __swap_writepage(struct page *page, struct writeback_control *wbc,
+	void (*end_write_func)(struct bio *, int))
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
@@ -233,7 +234,7 @@ int __swap_writepage(struct page *page,
 		return ret;
 	}
 
-	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
+	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

mm-break-up-swap_writepage-for-frontswap-backends.patch
mm-allow-for-outstanding-swap-writeback-accounting.patch

