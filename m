Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B4ADF56;
	Wed, 10 Jan 2024 05:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f1r611M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8C3C433F1;
	Wed, 10 Jan 2024 05:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704866394;
	bh=m5CUiue0GETYIesq8P6U7DRL+kDKwEeBo1yCttuE0MM=;
	h=Date:To:From:Subject:From;
	b=f1r611M2gDviTlNg/+s3CxLtKtFipOLq/M5sAVMEnu+UK1TamscCUECb57AXBhe3K
	 sqT5K6LmyABWZNxhexz3mcrte7KjPasdmNjbKhBh0hiWC4F3bjcKurnkfpXvjssT+P
	 c0rK8t3CW4IkuovBajr+NOHd0h32cgCZ9mTBMu8g=
Date: Tue, 09 Jan 2024 21:59:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,guoxuenan@huawei.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-avoid-multiple-marked-readahead-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110055954.2A8C3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: avoid multiple marked readahead pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     readahead-avoid-multiple-marked-readahead-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-avoid-multiple-marked-readahead-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20240104085839.21029-1-jack@suse.cz
Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-avoid-multiple-marked-readahead-pages.patch

