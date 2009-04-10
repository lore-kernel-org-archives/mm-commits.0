From: akpm@linux-foundation.org
Subject: + readahead-increase-interleaved-readahead-size.patch added to -mm tree
Date: Fri, 10 Apr 2009 16:39:13 -0700
Message-ID: <200904102339.n3ANdDQj021240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753744AbZDJXls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 19:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, xcf@ustc.edu.cn, yinghan@google.com


The patch titled
     readahead: increase interleaved readahead size
has been added to the -mm tree.  Its filename is
     readahead-increase-interleaved-readahead-size.patch

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
Subject: readahead: increase interleaved readahead size
From: Wu Fengguang <fengguang.wu@intel.com>

Make sure interleaved readahead size is larger than request size.  This
also makes the readahead window grow up more quickly.

Reported-by: Xu Chenfeng <xcf@ustc.edu.cn>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/readahead.c~readahead-increase-interleaved-readahead-size mm/readahead.c
--- a/mm/readahead.c~readahead-increase-interleaved-readahead-size
+++ a/mm/readahead.c
@@ -403,6 +403,7 @@ ondemand_readahead(struct address_space 
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
+		ra->size += req_size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch

