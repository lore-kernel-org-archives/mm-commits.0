Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C60C2288D5
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 22:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758233002; cv=none; b=HUYOuSEVoT+kZH7RetfKqQ4NYpkR9BG5R2OuMJF43BMXAWJNh861CCiIURRxojVCYryp22uwXv0ELmgfOmyTQ+E8cqQejvO+v/7mwDcfP1lnIdJIXAoEeeJkGfgmv5QW92KhXGM1c55Me/y3kl5wZo05bIWyLg0rc0kXV3PQMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758233002; c=relaxed/simple;
	bh=coRMql9klCR/J1e/rhRxbsYD1sKTAPzDindX7Oup+fQ=;
	h=Date:To:From:Subject:Message-Id; b=b5Mz3iZdki1razRDWScv4r7Q1XCO9odbG9dM8yIAzzsFFEi2mg4qRNjAWLJkVIGW2fzaA9QRXcW6CqP6wn9t2QOKjrWvcmtbBERGr80lhCK/sZC3Mr0skEteuwLdzgFgN85olxlz+hdjXfZCYXK+L32r3jy0FJgciAm4WYF2Lpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hPHo1TSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hPHo1TSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1FEC4CEE7;
	Thu, 18 Sep 2025 22:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758233002;
	bh=coRMql9klCR/J1e/rhRxbsYD1sKTAPzDindX7Oup+fQ=;
	h=Date:To:From:Subject:From;
	b=hPHo1TSGrJ/xEKR6khNT6TE9S+Bsph1utRzkiSTtnig9LRESTj1xjw/EyV4wC5tA8
	 Mx4ZXowPfn+0wdMOgsatHMyeNZHyZGDbnj8wI1L/oyLPs6gkkeVwfVCM/6rmw2RiSk
	 XpVZj7i3eUXaVH1AwUYZeNkeZWKnwseNsQzoVZeE=
Date: Thu, 18 Sep 2025 15:03:21 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-folio_test_private-check-in-pageout.patch added to mm-new branch
Message-Id: <20250918220322.2B1FEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: remove folio_test_private() check in pageout()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-remove-folio_test_private-check-in-pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-folio_test_private-check-in-pageout.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: remove folio_test_private() check in pageout()
Date: Thu, 18 Sep 2025 11:46:53 +0800

Patch series "some cleanups for pageout()", v2.

Since we no longer attempt to write back filesystem folios in pageout(),
and only tmpfs/shmem folios and anonymous swapcache folios can be written
back, we can remove the redundant folio_test_private() related logic to
simplify the logic of pageout(), as tmpfs/shmem and swapcache folios do
not use the PG_private flag.


This patch (of 2):

The folio_test_private() check in pageout() was introduced by commit
ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from a
history tree[1]).  As the commit message mentioned, it was to address the
issue where reiserfs pagecache may be truncated while still pinned.  To
further explain, the truncation removes the page->mapping, but the page is
still listed in the VM queues because it still has buffers.

In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
data=journal") seems to be dealing with a similar issue, where the page
becomes dirty after truncation, and it provides a very useful call stack:

truncate_complete_page()
      cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
      do_invalidatepage()
        ext3_invalidatepage()
          journal_invalidatepage()
            journal_unmap_buffer()
              __dispose_buffer()
                __journal_unfile_buffer()
                  __journal_temp_unlink_buffer()
                    mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

In this commit a2b345642f530, we forcefully clear the page's dirty flag
during truncation (in truncate_complete_page()).

Now it seems this was just a peculiar usage specific to reiserfs.  Maybe
reiserfs had some extra refcount on these pages, which caused them to pass
the is_page_cache_freeable() check.

With the fix provided by commit a2b345642f530 and reiserfs being removed
in 2024 by commit fb6f20ecb121 ("reiserfs: The last commit"), such a case
is unlikely to occur again.  So let's remove the redundant
folio_test_private() checks and related buffer_head release logic, and
just leave a warning here to catch such a bug.

Link: https://lkml.kernel.org/r/cover.1758166683.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com
Link: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git [1]
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-folio_test_private-check-in-pageout
+++ a/mm/vmscan.c
@@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *f
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
-		 * Some data journaling orphaned folios can have
-		 * folio->mapping == NULL while being dirty with clean buffers.
+		 * Is it still possible to have a dirty folio with
+		 * a NULL mapping? I think not.
 		 */
-		if (folio_test_private(folio)) {
-			if (try_to_free_buffers(folio)) {
-				folio_clear_dirty(folio);
-				pr_info("%s: orphaned folio\n", __func__);
-				return PAGE_CLEAN;
-			}
-		}
+		VM_WARN_ON_FOLIO(true, folio);
 		return PAGE_KEEP;
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options.patch
mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

