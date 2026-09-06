Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB16D37BE95;
	Sun,  6 Sep 2026 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788661900; cv=none; b=lN2/ZUBITcFUM5hphNWLnI5tRHAHZ35eH320lpEFaLXLYJ2L0oOAp1i7y765ZMZx9dCBg3R70CtNWFrog4izw5aE9oDzbzNFC7IG7RKfh8hW/EdJfMvCzRh/Hp83UaE0mUC38GecIIBYIFTuI1+VmgqbpMSgYIuQFY7dasGttMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788661900; c=relaxed/simple;
	bh=ApGGcDce8kWz//QSrv5ZS/qY24q35jKqfWJkMH3GIis=;
	h=Date:To:From:Subject:Message-Id; b=Eg47bAJm+ojhYosHWi0LGePBqIAA0/sEKyvS8aVqc+yEhp+ANRHiSZiQSXvb6uACBGjDAZPCEyrPA22Yk9kNY/TAke42s8DowjvWPqguQLR0H2cZhVTbykisB4a6GQipnENB+dWyXyl1Os/idyXTx0zxn9QW90fQFXdJrdlLZBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HhJexe0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HhJexe0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114AF1F00A3A;
	Sun,  6 Sep 2026 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788661898;
	bh=p4lMuJbwGuvzmREU5r5GDQVDJIaMD9Dkkku21SgE80c=;
	h=Date:To:From:Subject;
	b=HhJexe0mwikG7y0hksd6Q3CwP0db6Rd6GTqVS9LfpTBWpTT2gfGhH9xtIPFL6/ejk
	 vyg+yPal0TgvamQdTdeYryBzBcqOBuJST2JqRezC0dYtqseyBkmrPtJviaPLYvW8hK
	 XhEKHVWhEEyNxQu2KhfBzgN+vCmCX2szrOifMpZ8=
Date: Sat, 05 Sep 2026 19:31:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mawupeng1@huawei.com,david@kernel.org,enderaoelyther@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260906023138.114AF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zhao Li <enderaoelyther@gmail.com>
Subject: mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
Date: Tue, 28 Apr 2026 19:30:38 +0800

Failed hugetlbfs page allocations can permanently consume the mount's
size= quota without allocating a huge page.  Repeated failures can make
the filesystem appear full and cause later huge-page faults or allocations
to fail with SIGBUS/allocation failure despite available huge pages and
unused real filesystem capacity.

alloc_hugetlb_folio() calls hugepage_subpool_get_pages() when map_chg is
set.  For a subpool with max_hpages != -1, that bumps used_hpages
regardless of whether it returns gbl_chg = 0 (rsv slot consumed) or
gbl_chg > 0 (used_hpages slot only).  If the allocation later fails before
a folio is returned, the unwind must undo the used_hpages bump.  The old
cleanup only ran for !gbl_chg, leaking used_hpages on the gbl_chg > 0
path.

For gbl_chg > 0 on max-only subpools (max_hpages != -1, min_hpages == -1),
hugepage_subpool_get_pages() took only a speculative used_hpages slot. 
Drop that slot directly under spool->lock.  In that configuration
hugepage_subpool_put_pages() cannot restore rsv_hpages, so the direct
decrement is the exact inverse and is race-free against concurrent puts. 
This matches the used_hpages-only part of hugetlb_reserve_pages()'s
out_put_pages cleanup, but restricts it to the max-only case where no
rsv_hpages restoration is possible.

Mounts with min_hpages != -1 are left unchanged for now.  v2's approach
(hugepage_subpool_put_pages() + h->resv_huge_pages++ to back a restored
rsv_hpages slot) double-counts global backing under concurrent
free_huge_folio() and creates phantom reservations under concurrent
hugetlb_unreserve_pages().  Safe cleanup of that quadrant needs a
coordinated fix across multiple call sites.

Reproduced on size=20M hugetlbfs with the faulting task in a hugetlb
cgroup whose limit is exceeded.  Vanilla leaks 6/8 hugepages of subpool
quota; this patch leaks 0/8.  Verified under QEMU.

Link: https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com
Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure
+++ a/mm/hugetlb.c
@@ -3070,13 +3070,24 @@ struct folio *alloc_hugetlb_folio(struct
 	return folio;
 
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		if (!gbl_chg) {
+			/* Full inverse when subpool_get_pages() consumed rsv_hpages. */
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (gbl_chg > 0 && spool && spool->min_hpages == -1 &&
+			   spool->max_hpages != -1) {
+			unsigned long flags;
+
+			/*
+			 * For max-only subpools, subpool_get_pages() took only a
+			 * speculative used_hpages slot. Drop that slot directly.
+			 */
+			spin_lock_irqsave(&spool->lock, flags);
+			if (spool->used_hpages > 0)
+				spool->used_hpages--;
+			unlock_or_release_subpool(spool, flags);
+		}
 	}
 
 out_end_reservation:
_

Patches currently in -mm which might be from enderaoelyther@gmail.com are

mm-hugetlb-fix-max-only-subpool-accounting-on-alloc_hugetlb_folio-failure.patch

