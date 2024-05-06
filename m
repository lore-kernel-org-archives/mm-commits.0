Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4E7F9CB
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956995; cv=none; b=YaWe7LGzUWRx+N4ad7plTrDBEXT39IeNstl9u/FVuroSC6/HiyhTag7PRAVxYBkH/tzqC8nVY4UZq9Rm0pbW0MCt4oiXBB320x4Xw0KNyIRs71xS+vJqiKmVtA/zJWob1RcWOwDJgNqQUMo0iMOXvXLd36FC06zBB+HvMNHQYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956995; c=relaxed/simple;
	bh=CT+olYaxZ0QVU/WQZaTMmqo4YdN9zapUCt8jglxEg7g=;
	h=Date:To:From:Subject:Message-Id; b=twQif1Lvxug6PFf1dGpBfNjy7RofRrUxo934vS+RZj7cVMmXEsKMegWk8pu3iPcBK2QO80R+wsNpUtBydoPPqgnoQ4fcGPTCba+7uKlq2pVErNaZXlcjWxx0K6CcZtEF4yWR8YG7OSMMZy5wJvTph9UzhfSIE4nWVD7bUqQX2mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2TQ8qbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2TQ8qbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D949FC113CC;
	Mon,  6 May 2024 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956994;
	bh=CT+olYaxZ0QVU/WQZaTMmqo4YdN9zapUCt8jglxEg7g=;
	h=Date:To:From:Subject:From;
	b=E2TQ8qbmoVWOWhXUtyjkbodstxCw0cE3op/TT/U6BiS/ZtNmmOIkK34S6OKhzSjf7
	 tZyt7P/A3nANP+UBgSaJdiyiDdpuJv1udK1FVMl4YzVJN+GOpNuJ7HfNGBkSABPE0r
	 CtA73BYebAj+AKsoz+MCvBiHmOM9duuZ6iuNJ+lQ=
Date: Sun, 05 May 2024 17:56:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-for-detecting-underflows-with-page_mapcount-again.patch removed from -mm tree
Message-Id: <20240506005634.D949FC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: allow for detecting underflows with page_mapcount() again
has been removed from the -mm tree.  Its filename was
     mm-allow-for-detecting-underflows-with-page_mapcount-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: allow for detecting underflows with page_mapcount() again
Date: Tue, 9 Apr 2024 21:22:44 +0200

Patch series "mm: mapcount for large folios + page_mapcount() cleanups".

This series tracks the mapcount of large folios in a single value, so it
can be read efficiently and atomically, just like the mapcount of small
folios.

folio_mapcount() is then used in a couple more places, most notably to
reduce false negatives in folio_likely_mapped_shared(), and many users of
page_mapcount() are cleaned up (that's maybe why you got CCed on the full
series, sorry sh+xtensa folks!  :) ).

The remaining s390x user and one KSM user of page_mapcount() are getting
removed separately on the list right now.  I have patches to handle the
other KSM one, the khugepaged one and the kpagecount one; as they are not
as "obvious", I will send them out separately in the future.  Once that is
all in place, I'm planning on moving page_mapcount() into
fs/proc/task_mmu.c, the remaining user for the time being (and we can
discuss at LSF/MM details on that :) ).

I proposed the mapcount for large folios (previously called total
mapcount) originally in part of [1] and I later included it in [2] where
it is a requirement.  In the meantime, I changed the patch a bit so I
dropped all RB's.  During the discussion of [1], Peter Xu correctly raised
that this additional tracking might affect the performance when PMD->PTE
remapping THPs.  In the meantime.  I addressed that by batching RMAP
operations during fork(), unmap/zap and when PMD->PTE remapping THPs.

Running some of my micro-benchmarks [3] (fork,munmap,cow-byte,remap) on 1
GiB of memory backed by folios with the same order, I observe the
following on an Intel(R) Xeon(R) Silver 4210R CPU @ 2.40GHz tuned for
reproducible results as much as possible:

Standard deviation is mostly < 1%, except for order-9, where it's < 2% for
fork() and munmap().

(1) Small folios are not affected (< 1%) in all 4 microbenchmarks.
(2) Order-4 folios are not affected (< 1%) in all 4 microbenchmarks. A bit
    weird comapred to the other orders ...
(3) PMD->PTE remapping of order-9 THPs is not affected (< 1%)
(4) COW-byte (COWing a single page by writing a single byte) is not
    affected for any order (< 1 %). The page copy_fault overhead dominates
    everything.
(5) fork() is mostly not affected (< 1%), except order-2, where we have
    a slowdown of ~4%. Already for order-3 folios, we're down to a slowdown
    of < 1%.
(6) munmap() sees a slowdown by < 3% for some orders (order-5,
    order-6, order-9), but less for others (< 1% for order-4 and order-8,
    < 2% for order-2, order-3, order-7).

Especially the fork() and munmap() benchmark are sensitive to each added
instruction and other system noise, so I suspect some of the change and
observed weirdness (order-4) is due to code layout changes and other
factors, but not really due to the added atomics.

So in the common case where we can batch, the added atomics don't really
make a big difference, especially in light of the recent improvements for
large folios that we recently gained due to batching.  Surprisingly, for
some cases where we cannot batch (e.g., COW), the added atomics don't seem
to matter, because other overhead dominates.

My fork and munmap micro-benchmarks don't cover cases where we cannot
batch-process bigger parts of large folios.  As this is not the common
case, I'm not worrying about that right now.

Future work is batching RMAP operations during swapout and folio
migration.

[1] https://lore.kernel.org/all/20230809083256.699513-1-david@redhat.com/
[2] https://lore.kernel.org/all/20231124132626.235350-1-david@redhat.com/
[3] https://gitlab.com/davidhildenbrand/scratchspace/-/raw/main/pte-mapped-folio-benchmarks.c?ref_type=heads


This patch (of 18):

Commit 53277bcf126d ("mm: support page_mapcount() on page_has_type()
pages") made it impossible to detect mapcount underflows by treating any
negative raw mapcount value as a mapcount of 0.

We perform such underflow checks in zap_present_folio_ptes() and
zap_huge_pmd(), which would currently no longer trigger.

Let's check against PAGE_MAPCOUNT_RESERVE instead by using
page_type_has_type(), like page_has_type() would, so we can still catch
some underflows.

[david@redhat.com: make page_mapcount() slighly more efficient]
  Link: https://lkml.kernel.org/r/1af4fd61-7926-47c8-be45-833c0dbec08b@redhat.com
Link: https://lkml.kernel.org/r/20240409192301.907377-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240409192301.907377-2-david@redhat.com
Fixes: 53277bcf126d ("mm: support page_mapcount() on page_has_type() pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-allow-for-detecting-underflows-with-page_mapcount-again
+++ a/include/linux/mm.h
@@ -1232,7 +1232,7 @@ static inline int page_mapcount(struct p
 	int mapcount = atomic_read(&page->_mapcount) + 1;
 
 	/* Handle page_has_type() pages */
-	if (mapcount < 0)
+	if (mapcount < PAGE_MAPCOUNT_RESERVE + 1)
 		mapcount = 0;
 	if (unlikely(PageCompound(page)))
 		mapcount += folio_entire_mapcount(page_folio(page));
_

Patches currently in -mm which might be from david@redhat.com are


