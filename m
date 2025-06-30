Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8D120103A
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751324139; cv=none; b=IeXjGc+ktZpvGxV+mpeCJIWXgGoPJGkqZaQFxoChtNUGRZQzL8pahK+w6sIMKQJWjghZZom96m9+viMvWP2HNt2nFqwrKyXDZyS0peZGL6kc3fNY/EsUf0PEiA+VDE8GTrJZykMRJfrSHfKITxqNgxUiIAwn+eu6yaJggj+4+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751324139; c=relaxed/simple;
	bh=Or+Y2pJY6El08LJ6e3LWQW8ZVR8XgA46Loi1bTQ2/sU=;
	h=Date:To:From:Subject:Message-Id; b=DgtfwD0G5WTlaHfKTbMjptl9gS0mb6klHDbeYNr8IWlSf73BFoGzPGtSgOzT8FdbVvLpeBTMvrNLowqMrkWHn6ATNAIMS4AsNd9UteA8Q7aAZQHI1EjOdQ87CnpGHt5s1A5/Wr5HqryFysb8bYxAMNSZfFZ1TvxrpBYMxKQq87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0AojQZ5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0AojQZ5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81373C4CEEF;
	Mon, 30 Jun 2025 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751324137;
	bh=Or+Y2pJY6El08LJ6e3LWQW8ZVR8XgA46Loi1bTQ2/sU=;
	h=Date:To:From:Subject:From;
	b=0AojQZ5i7Ee0Tsgu143jos6kEJRHCOiB6uu/SFCUBKEtN4olldkt6lOw+Qsu7Ppx9
	 V13eX29R27O/Z99DqUpHoS/tlmb+cwndeJrnLbWxwWeMyhD3pY/9aXPyLf0/kZ7htX
	 XW1IXG5UaCDvsy0iffbPm093Y5RYhSOHt7plMyu8=
Date: Mon, 30 Jun 2025 15:55:37 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch added to mm-new branch
Message-Id: <20250630225537.81373C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,hugetlb: drop obsolete comment about non-present pte and second faults
has been added to the -mm mm-new branch.  Its filename is
     mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hugetlb: drop obsolete comment about non-present pte and second faults
Date: Mon, 30 Jun 2025 16:42:11 +0200

There is a comment in hugetlb_fault() that does not hold anymore.  This
one:

 /*
  * vmf.orig_pte could be a migration/hwpoison vmf.orig_pte at this
  * point, so this check prevents the kernel from going below assuming
  * that we have an active hugepage in pagecache. This goto expects
  * the 2nd page fault, and is_hugetlb_entry_(migration|hwpoisoned)
  * check will properly handle it.
  */

This was written because back in the day we used to do:

 hugetlb_fault () {
  ptep = huge_pte_offset(...)
  if (ptep) {
    entry = huge_ptep_get(ptep)
    if (unlikely(is_hugetlb_entry_migration(entry))
        ...
    else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
        ...
  }

  ...
  ...

  /*
   * entry could be a migration/hwpoison entry at this point, so this
   * check prevents the kernel from going below assuming that we have
   * a active hugepage in pagecache. This goto expects the 2nd page fault,
   * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
   * handle it.
   */
  if (!pte_present(entry))
          goto out_mutex;
  ...
 }

The code was designed to check for hwpoisoned/migration entries upfront,
and then bail out if further down the pte was not present anymore, relying
on the second fault to properly handle migration/hwpoison entries that
time around.

The way we handle this is different nowadays, so drop the misleading
comment.

Link: https://lkml.kernel.org/r/20250627102904.107202-5-osalvador@suse.de
Link: https://lkml.kernel.org/r/20250630144212.156938-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/hugetlb.c~mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults
+++ a/mm/hugetlb.c
@@ -6746,13 +6746,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	ret = 0;
 
-	/*
-	 * vmf.orig_pte could be a migration/hwpoison vmf.orig_pte at this
-	 * point, so this check prevents the kernel from going below assuming
-	 * that we have an active hugepage in pagecache. This goto expects
-	 * the 2nd page fault, and is_hugetlb_entry_(migration|hwpoisoned)
-	 * check will properly handle it.
-	 */
+	/* Not present, either a migration or a hwpoisoned entry */
 	if (!pte_present(vmf.orig_pte)) {
 		if (unlikely(is_hugetlb_entry_migration(vmf.orig_pte))) {
 			/*
_

Patches currently in -mm which might be from osalvador@suse.de are

mmslub-do-not-special-case-n_normal-nodes-for-slab_nodes.patch
mmmemory_hotplug-remove-status_change_nid_normal-and-update-documentation.patch
mmmemory_hotplug-implement-numa-node-notifier.patch
mmslub-use-node-notifier-instead-of-memory-notifier.patch
mmmemory-tiers-use-node-notifier-instead-of-memory-notifier.patch
driverscxl-use-node-notifier-instead-of-memory-notifier.patch
drivershmat-use-node-notifier-instead-of-memory-notifier.patch
kernelcpuset-use-node-notifier-instead-of-memory-notifier.patch
mmmempolicy-use-node-notifier-instead-of-memory-notifier.patch
mmpage_ext-derive-the-node-from-the-pfn.patch
mmmemory_hotplug-drop-status_change_nid-parameter-from-memory_notify.patch
mmhugetlb-change-mechanism-to-detect-a-cow-on-private-mapping.patch
mmhugetlb-sort-out-folio-locking-in-the-faulting-path.patch
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean.patch
mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch
mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

