From: akpm@linux-foundation.org
Subject: + writeback-make-mapping-writeback_index-to-point-to-the-last-written-page.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:27:10 -0800
Message-ID: <201103072327.p27NRAFS001774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190Ab1CGX1S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:27:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, fengguang.wu@intel.com, jack@suse.cz


The patch titled
     writeback: make mapping->writeback_index to point to the last written page
has been added to the -mm tree.  Its filename is
     writeback-make-mapping-writeback_index-to-point-to-the-last-written-page.patch

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
Subject: writeback: make mapping->writeback_index to point to the last written page
From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

For range-cyclic writeback (e.g.  kupdate), the writeback code sets a
continuation point of the next writeback to mapping->writeback_index which
is set the page after the last written page.  This happens so that we
evenly write the whole file even if pages in it get continuously
redirtied.

However, in some cases, sequential writer is writing in the middle of the
page and it just redirties the last written page by continuing from that. 
For example with an application which uses a file as a big ring buffer we
see:

[1st writeback session]
       ...
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898514 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898522 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898530 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898538 + 8
       flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898546 + 8
     kworker/0:1-11    4571: block_rq_issue: 8,0 W 0 () 94898514 + 40
>>     flush-8:0-2743  4571: block_bio_queue: 8,0 W 94898554 + 8
>>     flush-8:0-2743  4571: block_rq_issue: 8,0 W 0 () 94898554 + 8

[2nd writeback session after 35sec]
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898562 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898570 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898578 + 8
       ...
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94898562 + 640
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899202 + 72
       ...
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899962 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899970 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899978 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899986 + 8
       flush-8:0-2743  4606: block_bio_queue: 8,0 W 94899994 + 8
     kworker/0:1-11    4606: block_rq_issue: 8,0 W 0 () 94899962 + 40
>>     flush-8:0-2743  4606: block_bio_queue: 8,0 W 94898554 + 8
>>     flush-8:0-2743  4606: block_rq_issue: 8,0 W 0 () 94898554 + 8

So we seeked back to 94898554 after we wrote all the pages at the end of
the file.

This extra seek seems unnecessary.  If we continue writeback from the last
written page, we can avoid it and do not cause harm to other cases.  The
original intent of even writeout over the whole file is preserved and if
the page does not get redirtied pagevec_lookup_tag() just skips it.

As an exceptional case, when I/O error happens, set done_index to the next
page as the comment in the code suggests.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-make-mapping-writeback_index-to-point-to-the-last-written-page mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-make-mapping-writeback_index-to-point-to-the-last-written-page
+++ a/mm/page-writeback.c
@@ -927,7 +927,7 @@ retry:
 				break;
 			}
 
-			done_index = page->index + 1;
+			done_index = page->index;
 
 			lock_page(page);
 
@@ -977,6 +977,7 @@ continue_unlock:
 					 * not be suitable for data integrity
 					 * writeout).
 					 */
+					done_index = page->index + 1;
 					done = 1;
 					break;
 				}
_

Patches currently in -mm which might be from j-nomura@ce.jp.nec.com are

writeback-make-mapping-writeback_index-to-point-to-the-last-written-page.patch

