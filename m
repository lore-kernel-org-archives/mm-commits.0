Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB0F42AAF
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750628932; cv=none; b=KVvkGGo7WvJMHXJ+uFmHY5j9jz8hePBs+sFXxNWhMOsWSFAif8uyYYgI/+R8qKARWN4/lPouNbAyBLqb5IYm8LdMnSKPd5v8gREAyq/Ty9Eh8wEPghNiYhXyAwRJUxZciel96xGvQIchwo7sSbzvis30peYnyLlNw68IPnGloUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750628932; c=relaxed/simple;
	bh=xIV3ea2yvHo7e1+0UHo33KbTFzIUx1IqXlizAnbQ2zc=;
	h=Date:To:From:Subject:Message-Id; b=O7xHJ4lYS+/qy6XKdvtATGFIYtctkGSzjKk+xJdjjzrSkd1WF72SL7YgqrA8N5/18rplp4JOP1nqSDe9xkqzFh0Ko2O+7As9Vp2dkkPKfiKosOM+3kV3IDOE+9FxdFPxpqdcMmP4g40E8ruj69oXK48x1fkP9HKCyzYLQ1zteaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=03Il7IZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="03Il7IZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68711C4CEEA;
	Sun, 22 Jun 2025 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750628932;
	bh=xIV3ea2yvHo7e1+0UHo33KbTFzIUx1IqXlizAnbQ2zc=;
	h=Date:To:From:Subject:From;
	b=03Il7IZ1rDFpGv60kH1+1WgGFBYRG/wgnpxkFlUHpfi6x37nD/wtxjpBVSitlL97u
	 DqsJkOAHY045t6YIV0MH5t//bi8dkB6WCSNZjakhHPk1FK7duV5O9B2D7jHCZwihOG
	 gJDJyd++KEX4KyxIUErOx0wZ/5NhMdD8hBxTXUQk=
Date: Sun, 22 Jun 2025 14:48:51 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,gavinguo@igalia.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch added to mm-new branch
Message-Id: <20250622214852.68711C4CEEA@smtp.kernel.org>
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
Date: Fri, 20 Jun 2025 14:30:13 +0200

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

The way we handle this is different nowadays, so drop the misleading comment.

Link: https://lkml.kernel.org/r/20250620123014.29748-5-osalvador@suse.de
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
@@ -6724,13 +6724,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
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
mmhugetlb-rename-anon_rmap-to-new_anon_folio-and-make-it-boolean-fix.patch
mmhugetlb-drop-obsolete-comment-about-non-present-pte-and-second-faults.patch
mmhugetlb-drop-unlikelys-from-hugetlb_fault.patch

