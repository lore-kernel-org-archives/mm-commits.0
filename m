Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D641136A;
	Fri, 28 Jun 2024 00:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719533203; cv=none; b=ZBEu7r47wsBcMb7eSZJ3cblitJ9fnAgA8qIOxOqVWFPcLl7UOltWGjHv8fYjZ0IusS7nBGWNpXmTz4mWPgvUuSlXStH8Ij7OS4MnJRy0lsmaBfrrX3KtqEOg7520CwHLDlwm8Og47cILLMw/9Jq4bBz+WSQwL42Mj1UJQItEAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719533203; c=relaxed/simple;
	bh=sI5AQVrutHMN2QVy+K6J59Bt4KdrpoG5KngC/PMWTjU=;
	h=Date:To:From:Subject:Message-Id; b=crfLJTClpAuPMLmqsc21WApyKRdWzTu/Yi4zxokRydOJlk6I36ztmmikGg9SRS34PpC5BCnPH/RP8zRby2RPqdcHTERs2FXJvC1AttHdLML8Cx4giSkptVwJ+uhRiIhQzwNW//fa2tiAiX0/mLZ2DbL27ph6HbksqN7acKDIHws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z6zcAe2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z6zcAe2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24182C2BBFC;
	Fri, 28 Jun 2024 00:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719533203;
	bh=sI5AQVrutHMN2QVy+K6J59Bt4KdrpoG5KngC/PMWTjU=;
	h=Date:To:From:Subject:From;
	b=Z6zcAe2yiwQQB1Tomo+TENoINRGE/HEA/7DmISejEdzaRczmQyWMH3RVZq2nyOW5v
	 9QU3OVYq7H3hzR6Kkn09XlTA8y0uvBVEmpSH4X8ItH4Gz/ycPHc1q/eemrAi3KTNqM
	 GsojyV3XIvi2+EF1I2VBH0upCHazTJQ6gmu1uoUE=
Date: Thu, 27 Jun 2024 17:06:42 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,stable@vger.kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch removed from -mm tree
Message-Id: <20240628000643.24182C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
has been removed from the -mm tree.  Its filename was
     revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
Date: Fri, 21 Jun 2024 16:42:37 +0200

Patch series "mm: Avoid possible overflows in dirty throttling".

Dirty throttling logic assumes dirty limits in page units fit into
32-bits.  This patch series makes sure this is true (see patch 2/2 for
more details).


This patch (of 2):

This reverts commit 9319b647902cbd5cc884ac08a8a6d54ce111fc78.

The commit is broken in several ways.  Firstly, the removed (u64) cast
from the multiplication will introduce a multiplication overflow on 32-bit
archs if wb_thresh * bg_thresh >= 1<<32 (which is actually common - the
default settings with 4GB of RAM will trigger this).  Secondly, the
div64_u64() is unnecessarily expensive on 32-bit archs.  We have
div64_ul() in case we want to be safe & cheap.  Thirdly, if dirty
thresholds are larger than 1<<32 pages, then dirty balancing is going to
blow up in many other spectacular ways anyway so trying to fix one
possible overflow is just moot.

Link: https://lkml.kernel.org/r/20240621144017.30993-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240621144246.11148-1-jack@suse.cz
Fixes: 9319b647902c ("mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-By: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again
+++ a/mm/page-writeback.c
@@ -1660,7 +1660,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc, dtc->thresh);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-make-sure-sync-readahead-reads-needed-page.patch
filemap-fix-page_cache_next_miss-when-no-hole-found.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-drop-pointless-index-from-force_page_cache_ra.patch
readahead-drop-index-argument-of-page_cache_async_readahead.patch
readahead-drop-dead-code-in-page_cache_ra_order.patch
readahead-drop-dead-code-in-ondemand_readahead.patch
readahead-disentangle-async-and-sync-readahead.patch
readahead-fold-try_context_readahead-into-its-single-caller.patch
readahead-simplify-gotos-in-page_cache_sync_ra.patch

