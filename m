Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7481415E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628294; cv=none; b=SlY2L2w/glNRfj7VsZraUY5rkTGOIgQVR8d/2A6hYYq+Z1l1mdShcDVARbL4/uwy3fW0TIx92Ua+BWP1zvDkDhXCpbadQ3ePuTP9jQlisODtneIbXqSelpyOhEENytEOMiJpS4DUw9yrMJArDJNSfFfX6KCRFdXGTLmB/k4LJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628294; c=relaxed/simple;
	bh=sAr5dQ0lesbNRYPeub+CqzckWg0LUfiSRH/vqk5qO2w=;
	h=Date:To:From:Subject:Message-Id; b=OqrUKVbL/oZxi6qdUqK+mkZ6C9JG6NCqZPbk5bu/p968j5572cQLEZeR3/mU9JortHfTytChrnBJRCdpYg8NqShGjsrdnWEZI55vjDdX2GSGvkbx5cj3q+SW70lyPFUc+tje5XksrBtsU2Vevm9LiRV9veg8mGW5zwAYFQcDUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhngMYNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhngMYNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CABBC116B1;
	Sat, 29 Jun 2024 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628294;
	bh=sAr5dQ0lesbNRYPeub+CqzckWg0LUfiSRH/vqk5qO2w=;
	h=Date:To:From:Subject:From;
	b=GhngMYNiYPU+/rEKetiTdxLakDfmAEk14Eat7h/fJSjsLq3h1gcx3Urnr4fqs1jly
	 NuFxtDITaAdtaCqvEg1UtvEAlI4xdwxWusOP3UOI6naAV0A+VGICe7p+g4L2zDqG2X
	 TcNpUwV4K9wdMqzQ/g+4nOJsQAFp9HUVDv68nzEE=
Date: Fri, 28 Jun 2024 19:31:33 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-make-sure-sync-readahead-reads-needed-page.patch removed from -mm tree
Message-Id: <20240629023134.4CABBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: make sure sync readahead reads needed page
has been removed from the -mm tree.  Its filename was
     readahead-make-sure-sync-readahead-reads-needed-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Zhang Peng reported:

: I test this batch of patch with fio, it indeed has a huge sppedup
: in sequential read when block size is 4KiB. The result as follow,
: for async read, iodepth is set to 128, and other settings
: are self-evident.
: 
: casename                upstream   withFix speedup
: ----------------        --------   -------- -------
: randread-4k-sync        48991      47
: seqread-4k-sync         1162758    14229
: seqread-1024k-sync      1460208    1452522 
: randread-4k-libaio      47467      4730
: randread-4k-posixaio    49190      49512
: seqread-4k-libaio       1085932    1234635
: seqread-1024k-libaio    1423341    1402214 -1
: seqread-4k-posixaio     1165084    1369613 1
: seqread-1024k-posixaio  1435422    1408808 -1.8


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
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
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


