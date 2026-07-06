Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CED83E7BCC
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783379757; cv=none; b=vDTADiBdVXly1zRKqa4oflgg9n7Kft6dkENnLdzsQ1G6oCHK85EfUUS/TXT5w21uqCjGFavXOC86uvJetp/VJ8ddQJDb7qIiQniR0IDZ6o0bxhi0pkf9yClucXUTzfgvgabw86BfWhEbWEQFsEsmpv+nTG8al+eNpMTPa0vly2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783379757; c=relaxed/simple;
	bh=2pEJnVwVYFyRQv5l1cFjHq887ArmCjIyO9nGouqFUSk=;
	h=Date:To:From:Subject:Message-Id; b=qJNuH3ot94uT2krsgya6FeCUrVuBd+SRoD6uYUSjBuxFn/t3EeLtM3Qwn86O/0tPlMY2yLKnjuHOAvc4ST3JzwgwqWYdKHLf0TrIicvhtN5Akf9K8BE4mbSys8HQmzCEqAvSI410sZJ3NHCTgyW8vgwMJSbHpsPMg9O5xvrv5yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYoRTLd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYoRTLd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960111F000E9;
	Mon,  6 Jul 2026 23:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783379753;
	bh=aqofgGxUf0Qz/O1ChU3ffDD2lzo17IXUPRWQkc2dZu0=;
	h=Date:To:From:Subject;
	b=dYoRTLd4FA/eH19Pd8yGcUSP/rWaHzbtVTAwGQ8a0pgQ2VwjyXv0wPIC7/YS2yIcj
	 KzDRJe1hU2NERnwCUww7T/mhRzOTXr7pcQ7Y9a1EecE+NaSIJK8lIx/ZNlOMQ527Qc
	 fYtMqJq//TmHlWy8Ebcqpyz1QQC+fObGPh7xoJgc=
Date: Mon, 06 Jul 2026 16:15:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch added to mm-new branch
Message-Id: <20260706231553.960111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch

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
Subject: mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
Date: Thu, 2 Jul 2026 07:59:53 +0800

The "we just allocated them without exposing them to the swapcache" case
no longer exists, as Kairui has routed synchronous I/O through the
swapcache as well in his series "unify swapin use swap cache and cleanup
flags"[1].  As a result, folio_ref_count() should never be 1 in this path,
since at least two references are held (base ref plus swapcache).  Remove
the folio_ref_count()==1 check and update the comment accordingly.

Link: https://lore.kernel.org/20260701235955.36126-3-baohua@kernel.org
Link: https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/ [1]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic
+++ a/mm/memory.c
@@ -5039,13 +5039,10 @@ check_folio:
 		pte = pte_mkuffd_wp(pte);
 
 	/*
-	 * Same logic as in do_wp_page(); however, optimize for pages that are
-	 * certainly not shared either because we just allocated them without
-	 * exposing them to the swapcache or because the swap entry indicates
-	 * exclusivity.
+	 * Similar logic as in do_wp_page(); however, optimize for pages that are
+	 * certainly not because the swap entry indicates exclusivity.
 	 */
-	if (!folio_test_ksm(folio) &&
-	    (exclusive || folio_ref_count(folio) == 1)) {
+	if (exclusive) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch

