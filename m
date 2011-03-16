From: akpm@linux-foundation.org
Subject: + memstick-add-support-for-legacy-memorysticks-update-2.patch added to -mm tree
Date: Tue, 15 Mar 2011 17:55:13 -0700
Message-ID: <201103160057.p2G0vPWZ022644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757416Ab1CPA52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Mar 2011 20:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, fujita.tomonori@lab.ntt.co.jp, oakad@yahoo.com


The patch titled
     memstick-add-support-for-legacy-memorysticks-update-2
has been added to the -mm tree.  Its filename is
     memstick-add-support-for-legacy-memorysticks-update-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick-add-support-for-legacy-memorysticks-update-2
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/ms_block.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update-2 drivers/memstick/core/ms_block.c
--- a/drivers/memstick/core/ms_block.c~memstick-add-support-for-legacy-memorysticks-update-2
+++ a/drivers/memstick/core/ms_block.c
@@ -437,7 +437,7 @@ again:
 
 	case 5: /* send the MS_TPC_WRITE_LONG_DATA to perform the write*/
 		sg_init_table(sg, ARRAY_SIZE(sg));
-		sg_copy(msb->current_sg, sg, msb->page_size);
+		sg_copy(msb->current_sg, sg, ARRAY_SIZE(sg), msb->page_size);
 		memstick_init_req_sg(mrq, MS_TPC_WRITE_LONG_DATA, sg);
 		mrq->need_card_int = 1;
 		break;
@@ -446,7 +446,7 @@ again:
 		msb->current_page++;
 
 		if (msb->current_page < msb->pages_in_block) {
-			msb->current_sg = sg_advance(msb->current_sg, msb->page_size);
+			msb->current_sg = sg_truncate(msb->current_sg, msb->page_size);
 
 			if (!msb->current_sg) {
 				ms_printk(
@@ -780,7 +780,8 @@ static int msb_read_page(struct msb_data
 
 		msb->current_sg = msb->sg;
 		sg_init_table(msb->current_sg, MS_BLOCK_MAX_SEGS+1);
-		sg_copy(sg, msb->current_sg, msb->page_size);
+		sg_copy(sg, msb->current_sg, MS_BLOCK_MAX_SEGS+1,
+							msb->page_size);
 		error = msb_run_state_machine(msb, h_msb_read_page);
 
 
@@ -862,7 +863,8 @@ static bool msb_verify_block(struct msb_
 		page++;
 	}
 
-	if (sg_compare_to_buffer(orig_sg, msb->block_buffer, msb->block_size))
+	if (sg_compare_to_buffer(orig_sg, sg_nents(orig_sg),
+				msb->block_buffer, msb->block_size))
 		return -EIO;
 	return 0;
 }
@@ -920,7 +922,8 @@ static int msb_write_block(struct msb_da
 
 		msb->current_sg = msb->sg;
 		sg_init_table(msb->current_sg, MS_BLOCK_MAX_SEGS+1);
-		sg_copy(sg, msb->current_sg, msb->block_size);
+		sg_copy(sg, msb->current_sg, MS_BLOCK_MAX_SEGS+1,
+							msb->block_size);
 		msb->current_page = 0;
 
 		error = msb_run_state_machine(msb, h_msb_write_block);
@@ -1173,7 +1176,7 @@ static int msb_read_bad_block_table(stru
 		if (error)
 			goto out;
 
-		sg_ptr = sg_advance(sg_ptr, msb->page_size);
+		sg_ptr = sg_truncate(sg_ptr, msb->page_size);
 		page++;
 		if (page == msb->pages_in_block) {
 			ms_printk(
@@ -1686,7 +1689,7 @@ static int msb_do_write_request(struct m
 			if (error)
 				return error;
 
-			sg = sg_advance(sg, msb->block_size);
+			sg = sg_truncate(sg, msb->block_size);
 			*sucessfuly_written += msb->block_size;
 			lba++;
 			continue;
@@ -1696,7 +1699,7 @@ static int msb_do_write_request(struct m
 		if (error)
 			return error;
 
-		sg = sg_advance(sg, msb->page_size);
+		sg = sg_truncate(sg, msb->page_size);
 		*sucessfuly_written += msb->page_size;
 
 		page++;
@@ -1720,7 +1723,7 @@ static int msb_do_read_request(struct ms
 		if (error)
 			return error;
 
-		sg = sg_advance(sg, msb->page_size);
+		sg = sg_truncate(sg, msb->page_size);
 		*sucessfuly_read += msb->page_size;
 
 		page++;
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-media-path.patch
scatterlist-new-helper-functions.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update-2.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-alex-dubov-to-maintainers-of-the-memstick-core.patch

