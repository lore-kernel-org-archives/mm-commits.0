Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62A63264F7
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788222273; cv=none; b=DccXf8DNiM4QIqDQAMwG4dVNcAwVFOtfyXBxN3ZikbWfinx/sGjYvD+ed5we0KtPSu201o311GEHVWUyxogKK3Hybuc4xNQvHBrBX/fBYz51y4+D1i2w5lTp7dJvB7o3JsFogs1ngb232b66e7ZScTQYnkdK/pKnNgJXQDUkXP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788222273; c=relaxed/simple;
	bh=3xkECFiWjBdilDKXS3V1BjlW0OKwrKL8M1bqeRC7jfc=;
	h=Date:To:From:Subject:Message-Id; b=jQjtdvG8jF5Cq/iQu2RBC1WTbw56usIJAA8EK/bUm287ZwvyLm7yzFYuPXKJD3chyUAFzuj/OShiK/kAvxs1QrPRlhc0DQfIi+WG4J9l3RdHTFFHPp9E0rUOCQczalEPzyALMafxMiXf//YJHZ4Ctt6jk2Xp1MG/zvXAOV7VgpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NvtkWlGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NvtkWlGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9178F1F000E9;
	Tue,  1 Sep 2026 00:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788222271;
	bh=1PsGCYSABrPLvruxTUTKgE1C+aNutgr0NsCwlHhujH0=;
	h=Date:To:From:Subject;
	b=NvtkWlGmKmKmOy87cKxyhSyp83qbUHTuh1AdWGcc2FCK+GPUP2PsdJgzK605ceFyq
	 NlW3zVoPf6zhvjUSwNtL6ugHqquhNrgFfHOZpR4ISPFhvEt4+99HfDvrt1m8xJJgvy
	 ZgkMgxG/m7DOdqdEJYgGmJTyyaUBTswefapFOBOc=
Date: Mon, 31 Aug 2026 17:24:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch added to mm-new branch
Message-Id: <20260901002431.9178F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Mon, 31 Aug 2026 10:15:13 +0100

Patch series "Fix deferred_split_isolate() and drop the split workaround",
v2.

deferred_split_isolate() probes each queued folio with folio_try_get(). 
folio_try_get() failure is treated as a lost race with folio_put().

It leads to wrong results when !folio_try_get() was not caused by
folio_put(): for a frozen folio, PG_partially_mapped gets wrongfully
cleared and the folio dropped from the queue.

It came up in the review of my collapse RFC series:

  https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/

The bug is inert in upstream code:

  - __folio_split() works around it;
  - __folio_migrate_mapping() freezes a folio it is about to replace;
  - reclaim freezes only what try_to_unmap() already unmapped.

No stable@ needed.  But my collapse rework steps on it, so it is worth
fixing.

The branch the first patch removes also hid an inert, pre-existing bug in
the zone device path:

  https://lore.kernel.org/all/20260827163838.1813081-1-usama.arif@linux.dev/

The first patch fixes deferred_split_isolate().

The second patch removes the workaround for this deferred_split_isolate()
behaviour from __folio_freeze_and_split_unmapped().

Tested in a VM: split_huge_page_test, folio_split_race_test and cow pass.

Also ran a test that leaves 16 partially mapped THPs on the deferred split
queue and drives thp-deferred_split through debugfs, checking
nr_anon_partially_mapped.


This patch (of 2):

deferred_split_isolate() probes each queued folio with folio_try_get(). 
folio_try_get() failure is treated as a lost race with folio_put(): clear
PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take the
folio off the queue.

The folio_put() race is the most common case for !folio_try_get(), but it
is not the only option.  Another scenario is folio_ref_freeze().

A zero refcount in such cases does not mean the folio is going away.  It
means "don't touch me" and current deferred_split_isolate() doesn't
respect it.  It can lead to unqueueing folios from the deferred list for
no reason:

    CPU 0                            CPU 1
    ---------------------------      ------------------------------
    freeze a mapped folio            deferred_split_scan()
      folio_ref_freeze()               folio_try_get() fails
                                       folio_clear_partially_mapped()
                                       NR_ANON_PARTIALLY_MAPPED--
                                       folio off the queue
    give up, put it back
      folio_ref_unfreeze()

The folio is still partially mapped, but it is no longer a split
candidate.  Nothing queues it again until part of it is unmapped once
more.

Skip the folio instead: whoever freezes the folio, owns it and owner is
responsible for its fate.  It also covers the folio_put() case:
__folio_put() unqueues the folio via folio_unqueue_deferred_split().

Nothing is lost by skipping.  Everything that frees a queued folio
unqueues it first, and folio_unqueue_deferred_split() clears
PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down on
the way:

    __folio_put(), folios_put_refs()   mm/folio.c
    __folio_migrate_mapping()          mm/migrate.c
    shrink_folio_list()                mm/vmscan.c

__folio_freeze_and_split_unmapped() does the same by hand, under the
list_lru lock it holds across the freeze.  A freeze that ends in
folio_ref_unfreeze() leaves a folio that is still partially mapped and
still belongs on the queue.

Link: https://lore.kernel.org/20260831091514.1879786-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260831091514.1879786-2-kirill@shutemov.name
Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
Assisted-by: Claude-Code:claude-opus-5
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate
+++ a/mm/huge_memory.c
@@ -4638,22 +4638,11 @@ static enum lru_status deferred_split_is
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
 
-	if (folio_try_get(folio)) {
-		list_lru_isolate_move(lru, item, freeable);
-		return LRU_REMOVED;
-	}
+	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
+	if (!folio_try_get(folio))
+		return LRU_SKIP;
 
-	/*
-	 * We lost race with folio_put(). Read folio state before the
-	 * isolate: folio_unqueue_deferred_split() checks list_empty()
-	 * locklessly, so once removed the folio can be freed any time.
-	 */
-	if (folio_test_partially_mapped(folio)) {
-		folio_clear_partially_mapped(folio);
-		mod_mthp_stat(folio_order(folio),
-			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-	}
-	list_lru_isolate(lru, item);
+	list_lru_isolate_move(lru, item, freeable);
 	return LRU_REMOVED;
 }
 
_

Patches currently in -mm which might be from kas@kernel.org are

maintainers-add-myself-as-a-thp-reviewer.patch
mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch

