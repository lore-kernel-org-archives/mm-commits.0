Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3EE3396F1
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675073; cv=none; b=h8AePHVPCRnpWuLKpbOB4BK5byySqPLvFM0SvxNbU3mlDg7CF8GPNTk7tMYt1cE8I2V3RA5I+WEsfDghAIz5kjETPafjAmHqFwN5RJZjEDzR/5piK5cDrEu7Pe4ob357NZ8kk6v9v5xi1QmuHZeZSS9WslipzYcx3h6ihLsP4GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675073; c=relaxed/simple;
	bh=dC2KDsTkVtqaiCZsw8avvs/zRmSbvS3UMQXirwj2foA=;
	h=Date:To:From:Subject:Message-Id; b=Rgmc45uHL4vOdVXIsHNprWNzXUd+ex8Q34w6So0Ccn4FOFjCa7E5b4+dhWg0aWlfBV9lyDolYcrbVX0TbBCsWQ/hEKVHdFqpoK1+wLokyKw/VdGBez/YCrxGnxFVeZMJ5FYWzJ4RcGqOvJXed/3L7JZiwVfLxkoS6mSiZqUrOFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzlootFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzlootFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3ACC4CEF1;
	Thu, 20 Nov 2025 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675073;
	bh=dC2KDsTkVtqaiCZsw8avvs/zRmSbvS3UMQXirwj2foA=;
	h=Date:To:From:Subject:From;
	b=MzlootFMJMGAmU7GIPA3UroQGcgqnqt4aUTbcxRnJPNAx5umSjnj/1wTh+GPK6l/o
	 cBqjFY+s5mSIfxDE8HaWQDcQijaqH1EE7oLDQCVdmQuV85Yf0Ch/DM6mHfzP2UBtXw
	 wY+daz/DF6oIcw+IXPC9Yw+ymQg2tzrRBTzKvS8Y=
Date: Thu, 20 Nov 2025 13:44:32 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-folio_test_private-check-in-pageout.patch removed from -mm tree
Message-Id: <20251120214433.5C3ACC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: remove folio_test_private() check in pageout()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-folio_test_private-check-in-pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: redo comment, per David]
  Link: https://lkml.kernel.org/r/17d1b293-e393-4989-a357-7eea74b3c805@redhat.com
[baolin.wang@linux.alibaba.com: remove comment and WARNing, per Hugh and others]
  Link: https://lkml.kernel.org/r/392a9ca3-31ac-4447-bd44-3c656d63e4ca@linux.alibaba.com
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

 mm/vmscan.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-folio_test_private-check-in-pageout
+++ a/mm/vmscan.c
@@ -697,23 +697,8 @@ static pageout_t pageout(struct folio *f
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
 	 */
-	if (!is_page_cache_freeable(folio))
+	if (!is_page_cache_freeable(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!mapping) {
-		/*
-		 * Some data journaling orphaned folios can have
-		 * folio->mapping == NULL while being dirty with clean buffers.
-		 */
-		if (folio_test_private(folio)) {
-			if (try_to_free_buffers(folio)) {
-				folio_clear_dirty(folio);
-				pr_info("%s: orphaned folio\n", __func__);
-				return PAGE_CLEAN;
-			}
-		}
-		return PAGE_KEEP;
-	}
-
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

