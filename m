Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA3938B148;
	Wed, 16 Sep 2026 01:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789523224; cv=none; b=dCsZTpJ5+4Hah0rpW8NOVZcU0JVMoEj7s7+wtbEhPHCgJI3PrbNjyViImm3qhouNn4mqyYrbQLjPWi2G0vpT5hF6/+52ShKBshl0UvZyG2kXY9Du4TwLB6GnbGIU04OL/zMbBhdwPVbKNyz5FH+FwDzEVqRgioEP7C828WGdYxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789523224; c=relaxed/simple;
	bh=BiXbxRUPREdKbU9GcoHfxnGsX8SwxeGRcFZOz4d5tMw=;
	h=Date:To:From:Subject:Message-Id; b=L23OiekU3Ha9JKI1KKvAS59wIavppCdZ2GgdmuWgRJwN1NMBdIQPwdBKdldrKcExpTAKUAIZl36Ef9NH6OI08KiQL96+a3dMFhnXGXQl0ZVYX71EGwl1oBE1Pcw7ROWWnLjdn0PTP+4riMApy1zexVDB/2wwBajMByQFxfY6dpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2qOQXvYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2qOQXvYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0ED1F000FF;
	Wed, 16 Sep 2026 01:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789523211;
	bh=dfWF3yRHXzRYsxOIoMGYdMiNRuIaKO3z05pZwfILbIc=;
	h=Date:To:From:Subject;
	b=2qOQXvYcVQClkU/QpXQycqdvj+dTmrOOTwDP6PcSkFP43q506NQ+gFdNWdtt+8lP2
	 KPHfGwNZQjcyCjHAozg1Kzy/rXqR9YdaU5wYIkF9VhKQOjb3irOKIZ5iaomoCGMzJh
	 3MqluMQZHz9DsRJP9Iv2Bb4p6wqZIo5xFNOs+Hos=
Date: Tue, 15 Sep 2026 18:46:50 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch added to mm-new branch
Message-Id: <20260916014651.0D0ED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: use folio_trylock() in the cold/pageout PMD split
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/madvise: use folio_trylock() in the cold/pageout PMD split
Date: Sat, 12 Sep 2026 07:05:40 -0400

MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
madvise_cold_or_pageout_pte_range().  Two threads doing that to the same
THP create spurious failures.

  CPU0                          CPU1
  ----                          ----
  folio_get()
  spin_unlock(ptl)
  folio_lock()
                                folio_get()
                                spin_unlock(ptl)
                                folio_lock()  <- blocks, keeps its ref
  split_folio()
    folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
    -EAGAIN

CPU1 cannot drop its reference until it gets the lock CPU0 holds, so
CPU0's split always fails.  folio_trylock() makes CPU1 leave without ever
taking a reference.  The PTE branch of this same function already does
this, as do madvise_free_pte_range() and madvise_free_huge_pmd().

Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
/proc/vmstat:

                     thp_split_page   thp_split_page_failed
    before                     3186                     860
    after                      3200                       0

The short before count is rounds where every thread failed and the advice
was dropped for that THP entirely.

On failure the walker returns 0 and nothing retries.  The PMD path becomes
best effort when the folio lock is held elsewhere - same as the PTE path.

Link: https://lore.kernel.org/20260912110540.3203010-1-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: LLM
Cc: <stable@vger.kernel.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split
+++ a/mm/madvise.c
@@ -418,9 +418,10 @@ static int madvise_cold_or_pageout_pte_r
 		if (next - addr != HPAGE_PMD_SIZE) {
 			int err;
 
+			if (!folio_trylock(folio))
+				goto huge_unlock;
 			folio_get(folio);
 			spin_unlock(ptl);
-			folio_lock(folio);
 			err = split_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch
mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

