Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F13317B516
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340174; cv=none; b=l+d+RV1vMgCWGzrkR9Cnx4EMGxTTaeUF6AWJH0m7iRGcaL/PjLXuawqE5/7pytjSDsvcnB7IzahjJV0cH2RVxOWeQgjQqDmdsb59UZXM/7K+rWsxZgBPOFem72qApGg4N56RnUMeLfNgZvdgnQBAEC5RNqDMZzMOGB4Xp5eXYHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340174; c=relaxed/simple;
	bh=IcY/TQ7uNfnfr+JOhnyeWAR+Oyrq9YNTLloDYwL0Mvc=;
	h=Date:To:From:Subject:Message-Id; b=NX+aH+87tdv2yu9PiIchIB9MPAapwylLbKvORKG5TcXsAPUQQTMobSeKwbeGZ/SfcUf4PsucMK0uHrXTW+LXwiUSKqPLKjXjQ51rJqoARa4JcWcWWia11abBs5vHHE8LYA85anK8zjVYfKzLKBXLR2TiMnifC2amuUlPLqQiqPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2CzeIZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2CzeIZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D5AC32781;
	Tue, 25 Jun 2024 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340173;
	bh=IcY/TQ7uNfnfr+JOhnyeWAR+Oyrq9YNTLloDYwL0Mvc=;
	h=Date:To:From:Subject:From;
	b=Z2CzeIZZ1KTgA121L24r/2lwzcHclIic7lkfbNQilqak7D6Vy9COf4EuawZm4QfrM
	 kTbYIZ4G6J3DvVMvWK2lGaZvG4x4SeyjFz1JpR90/KEO8Zm1ny/VHRrBYXpZ9LnqJK
	 luGN9Bi5svV29NQvEnqP7J6HImtbCPqBsZnpFYLU=
Date: Tue, 25 Jun 2024 11:29:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-make-sure-sync-readahead-reads-needed-page.patch added to mm-unstable branch
Message-Id: <20240625182933.A4D5AC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: make sure sync readahead reads needed page
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-make-sure-sync-readahead-reads-needed-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-make-sure-sync-readahead-reads-needed-page.patch

This patch will later appear in the mm-unstable branch at
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
Subject: readahead: make sure sync readahead reads needed page
Date: Tue, 25 Jun 2024 12:18:51 +0200

Patch series "mm: Fix various readahead quirks".

When we were internally testing performance of recent kernels, we have
noticed quite variable performance of readahead arising from various
quirks in readahead code.  So I went on a cleaning spree there.  This is a
batch of patches resulting out of that.  A quick testing in my test VM
with the following fio job file:

[global]
direct=0
ioengine=sync
invalidate=1
blocksize=4k
size=10g
readwrite=read

[reader]
numjobs=1

shows that this patch series improves the throughput from variable one in
310-340 MB/s range to rather stable one at 350 MB/s.  As a side effect
these cleanups also address the issue noticed by Bruz Zhang [1].

[1] https://lore.kernel.org/all/20240618114941.5935-1-zhangpengpeng0808@gmail.com/


This patch (of 10):

page_cache_sync_ra() is called when a folio we want to read is not in the
page cache.  It is expected that it creates the folio (and perhaps the
following folios as well) and submits reads for them unless some error
happens.  However if index == ra->start + ra->size, ondemand_readahead()
will treat the call as another async readahead hit.  Thus ra->start will
be advanced and we create pages and queue reads from ra->start + ra->size
further.  Consequentially the page at 'index' is not created and
filemap_get_pages() has to always go through filemap_create_folio() path.

This behavior has particularly unfortunate consequences when we have two
IO threads sequentially reading from a shared file (as is the case when
NFS serves sequential reads).  In that case what can happen is:

suppose ra->size == ra->async_size == 128, ra->start = 512

T1					T2
reads 128 pages at index 512
  - hits async readahead mark
    filemap_readahead()
      ondemand_readahead()
        if (index == expected ...)
	  ra->start = 512 + 128 = 640
          ra->size = 128
	  ra->async_size = 128
	page_cache_ra_order()
	  blocks in ra_alloc_folio()
					reads 128 pages at index 640
					  - no page found
					  page_cache_sync_readahead()
					    ondemand_readahead()
					      if (index == expected ...)
						ra->start = 640 + 128 = 768
						ra->size = 128
						ra->async_size = 128
					    page_cache_ra_order()
					      submits reads from 768
					  - still no page found at index 640
					    filemap_create_folio()
					  - goes on to index 641
					  page_cache_sync_readahead()
					    ondemand_readahead()
					      - founds ra is confused,
					        trims is to small size
  	  finds pages were already inserted

And as a result read performance suffers.

Fix the problem by triggering async readahead case in ondemand_readahead()
only if we are calling the function because we hit the readahead marker. 
In any other case we need to read the folio at 'index' and thus we cannot
really use the current ra state.

Note that the above situation could be viewed as a special case of
file->f_ra state corruption.  In fact two thread reading using the shared
file can also seemingly corrupt file->f_ra in interesting ways due to
concurrent access.  I never saw that in practice and the fix is going to
be much more complex so for now at least fix this practical problem while
we ponder about the theoretically correct solution.

Link: https://lkml.kernel.org/r/20240625100859.15507-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240625101909.12234-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-make-sure-sync-readahead-reads-needed-page
+++ a/mm/readahead.c
@@ -580,7 +580,7 @@ static void ondemand_readahead(struct re
 	 */
 	expected = round_down(ra->start + ra->size - ra->async_size,
 			1UL << order);
-	if (index == expected || index == (ra->start + ra->size)) {
+	if (folio && index == expected) {
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max_pages);
 		ra->async_size = ra->size;
_

Patches currently in -mm which might be from jack@suse.cz are

revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch
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

