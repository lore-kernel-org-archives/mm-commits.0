Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116E314F112
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379753; cv=none; b=ccypQwkb0uTFgRyHwiMQJZXbGM1E8wAZqs79PSMsQsZp7Eib2Cd17Fik5Ry3y6FIljLEp2rtq8pASzjdvmfBafVtS4tqd6uqwPWXNPhXgnCLc55egzSs7AKNEwcHebdBc7uHSiBsqdvv9lVR5gQElVTuhIbX59aPje87UL6qd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379753; c=relaxed/simple;
	bh=VRRFjDBvQLgLh1iMtMXquST/KBMmLaim2gMP1TRjnqw=;
	h=Date:To:From:Subject:Message-Id; b=EqEeXxGRtRHbV5OuqW1U88XKEavlP7Y1QHUJmAvk4u+g3XhPL2dn1gmAvsRIlYhvY28SQ1MrJoi2UNKYh90RSnQ68L6Zi1UYFGeLI/IC1oCiaMiQ7csdH3Rvr3g50OCOO61cGr8ykcLt9qYJ6/HVUkCSqL1xm+yN0A1BuPE4X3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vHApRQo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vHApRQo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783D61F000E9;
	Mon,  6 Jul 2026 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379751;
	bh=xJr1iShGie+YNQbif70k7E+l+mkSSZLScclIXs4M8Zo=;
	h=Date:To:From:Subject;
	b=vHApRQo6KHOzu7b+bllS8+OnkskbBCS+m7u/JZVzmPRayvArwSAgESLhos2Fry9od
	 JN1hvKHjn0E7eaO5jG2bEiPLau+2lWfcaKCwHXNyq7Lg0Fh1CrLn1/ElZ52jrRANeh
	 O9HbLITqlEPwkOgqfRvmCCXyvzSOPg4iso2s6wWA=
Date: Mon, 06 Jul 2026 16:15:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch added to mm-new branch
Message-Id: <20260706231551.783D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch

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
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
Date: Thu, 2 Jul 2026 07:59:52 +0800

Patch series "mm: drop redundant lru_add_drain in anon folio reuse paths",
v3.

We are doing a large number of redundant lru_add_drain() calls in both
wp_can_reuse_anon_folio() and do_swap_page(), leading to LRU lock
contention and unnecessary overhead.

In wp_can_reuse_anon_folio(), we can check the refcount against the
lru_cache before deciding to drain.  In do_swap_page(), the drain is now
entirely redundant after Kairui's work to route SYNC I/O through the
swapcache in the same way as ASYNC I/O.

Build the kernel within a 1 GB memcg using 20 threads with zRAM swap.  The
number of lru_add_drain() calls is reduced from 276,278 to 226,318, a
reduction of about 18%.

Build the kernel within an 800 MB memcg using 20 threads with zRAM swap. 
The number of lru_add_drain() calls is reduced from 778,950 to 541,149, a
reduction of 30.5%.


This patch (of 4):

There is a case where `folio_ref_count(folio) == 3` and
`!folio_test_swapcache(folio)`. In that case, both
`folio_ref_count(folio) > 3` and
`folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
false, causing an unnecessary local LRU drain.

During an Ubuntu boot, I observed over 5,000 redundant local LRU drains. 
For a kernel build with a minimal configuration, I observed more than
20,000 redundant drains.

Fix this by checking against: `1 + in_swapcache + in_lrucache` instead of
hardcoding `folio_ref_count(folio) > 3`.

Link: https://lore.kernel.org/20260701235955.36126-1-baohua@kernel.org
Link: https://lore.kernel.org/20260701235955.36126-2-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio
+++ a/mm/memory.c
@@ -4174,6 +4174,9 @@ static bool __wp_can_reuse_large_anon_fo
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
+	const bool in_lru_cache = !folio_test_lru(folio);
+	const bool in_swapcache = folio_test_swapcache(folio);
+
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
 		return __wp_can_reuse_large_anon_folio(folio, vma);
 
@@ -4184,15 +4187,16 @@ static bool wp_can_reuse_anon_folio(stru
 	 *
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
-	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
+	if (folio_test_ksm(folio) ||
+	    folio_ref_count(folio) > 1 + in_lru_cache + in_swapcache)
 		return false;
-	if (!folio_test_lru(folio))
+	if (in_lru_cache)
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
 		 */
 		lru_add_drain();
-	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
+	if (folio_ref_count(folio) > 1 + in_swapcache)
 		return false;
 	if (!folio_trylock(folio))
 		return false;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch

