Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5860EEF;
	Fri, 26 Jan 2024 07:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255703; cv=none; b=SZebnuOW8PsujikD13GkpaW5082DAMmOZk8J9zmqNDBZ9iA8TUY+5u0gY8W5TznfPW8XKKRMTf+ZqNw5lyvhLK+rNUNHQ8l1DM74Tpk3Boe859bSWqpL6QINjLwSK8hTYKRLm1FJEG+AJDtXtUq/qtDjxjfaN0eSxI6KL2XCR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255703; c=relaxed/simple;
	bh=kiNLb7GzhcbT2o4rr2pUw0itc7bycYniyvbhiLUZfjA=;
	h=Date:To:From:Subject:Message-Id; b=I6SGZNBH1VNa745s+0wAOyxh6vyszSEW2GvfxaFAwprZOD+U0ATjMUiSOdftnpwTzyX8Rojntt0SfpX0mS2SRbyhq9DWsrmilPWHoHqyUv6U5wvTJP8ekBIN3PCbT7k5UaIwg48WiMhytUK5ruA5BgvMwm5gvb5gF1+nnOzaVOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJ3ddfck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJ3ddfck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12961C433F1;
	Fri, 26 Jan 2024 07:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255703;
	bh=kiNLb7GzhcbT2o4rr2pUw0itc7bycYniyvbhiLUZfjA=;
	h=Date:To:From:Subject:From;
	b=FJ3ddfck9AomSWOtVLpKFc5Ifcqc9YVyE6PjPmF+ATmw/Q97R8avunSnsDGqfSG05
	 Agz8OIVRS1t9NolwYenrGbNLoS0e68OBfFEZffe0XcK8xt8m5YOBjTAdoTHt/pvl8y
	 20Rzw+oh/gzKs3IKr+l8UkLhC4Yj0q7AZU6H8t+Y=
Date: Thu, 25 Jan 2024 23:55:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,guoxuenan@huawei.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-avoid-multiple-marked-readahead-pages.patch removed from -mm tree
Message-Id: <20240126075503.12961C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: avoid multiple marked readahead pages
has been removed from the -mm tree.  Its filename was
     readahead-avoid-multiple-marked-readahead-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: avoid multiple marked readahead pages
Date: Thu, 4 Jan 2024 09:58:39 +0100

ra_alloc_folio() marks a page that should trigger next round of async
readahead.  However it rounds up computed index to the order of page being
allocated.  This can however lead to multiple consecutive pages being
marked with readahead flag.  Consider situation with index == 1, mark ==
1, order == 0.  We insert order 0 page at index 1 and mark it.  Then we
bump order to 1, index to 2, mark (still == 1) is rounded up to 2 so page
at index 2 is marked as well.  Then we bump order to 2, index is
incremented to 4, mark gets rounded to 4 so page at index 4 is marked as
well.  The fact that multiple pages get marked within a single readahead
window confuses the readahead logic and results in readahead window being
trimmed back to 1.  This situation is triggered in particular when maximum
readahead window size is not a power of two (in the observed case it was
768 KB) and as a result sequential read throughput suffers.

Fix the problem by rounding 'mark' down instead of up.  Because the index
is naturally aligned to 'order', we are guaranteed 'rounded mark' == index
iff 'mark' is within the page we are allocating at 'index' and thus
exactly one page is marked with readahead flag as required by the
readahead code and sequential read performance is restored.

This effectively reverts part of commit b9ff43dd2743 ("mm/readahead: Fix
readahead with large folios").  The commit changed the rounding with the
rationale:

"...  we were setting the readahead flag on the folio which contains the
last byte read from the block.  This is wrong because we will trigger
readahead at the end of the read without waiting to see if a subsequent
read is going to use the pages we just read."

Although this is true, the fact is this was always the case with read
sizes not aligned to folio boundaries and large folios in the page cache
just make the situation more obvious (and frequent).  Also for sequential
read workloads it is better to trigger the readahead earlier rather than
later.  It is true that the difference in the rounding and thus earlier
triggering of the readahead can result in reading more for semi-random
workloads.  However workloads really suffering from this seem to be rare. 
In particular I have verified that the workload described in commit
b9ff43dd2743 ("mm/readahead: Fix readahead with large folios") of reading
random 100k blocks from a file like:

[reader]
bs=100k
rw=randread
numjobs=1
size=64g
runtime=60s

is not impacted by the rounding change and achieves ~70MB/s in both cases.

[jack@suse.cz: fix one more place where mark rounding was done as well]
  Link: https://lkml.kernel.org/r/20240123153254.5206-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240104085839.21029-1-jack@suse.cz
Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~readahead-avoid-multiple-marked-readahead-pages
+++ a/mm/readahead.c
@@ -469,7 +469,7 @@ static inline int ra_alloc_folio(struct
 
 	if (!folio)
 		return -ENOMEM;
-	mark = round_up(mark, 1UL << order);
+	mark = round_down(mark, 1UL << order);
 	if (index == mark)
 		folio_set_readahead(folio);
 	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
@@ -575,7 +575,7 @@ static void ondemand_readahead(struct re
 	 * It's the expected callback index, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	expected = round_up(ra->start + ra->size - ra->async_size,
+	expected = round_down(ra->start + ra->size - ra->async_size,
 			1UL << order);
 	if (index == expected || index == (ra->start + ra->size)) {
 		ra->start += ra->size;
_

Patches currently in -mm which might be from jack@suse.cz are


