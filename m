Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC393595E;
	Sun, 20 Jul 2025 02:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978405; cv=none; b=VbNxkfgjYI946LKQ7bcSPnQWCZJKi1utAbWnCC3hP7Dr6GtPIkLPA6axlmw5QMlxcr+ILrfbo6SbuTurC6IM9o78A/t1EQLBfqInxwN8ISkU/b0/ImDF/zG02Y0B/WZdyiUwXFAIPoHqxvlzYa7UH/bxOFoATZ6Gc5PLeERJ6+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978405; c=relaxed/simple;
	bh=MSFXIWf/LMVChuvwG9jeF47vF+hV+ouF7NQoXmsmye0=;
	h=Date:To:From:Subject:Message-Id; b=WvQbU+RnPChyEUwARRb0uuEWBb7amwoAmd7Urubun+TYRS+4NPR22ili6fZNCypg6c7BubxUMOGRM5F4BWGDLTFSCU4/eHyZZgdG8q5TCU5UqNBmK5Nr3e/D5p5VYmncNZ+XSw55Z5terAbgRbuFpXU+D/BHAC+h+7BAVw2ibBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H+hCagAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H+hCagAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC37C4CEE3;
	Sun, 20 Jul 2025 02:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978404;
	bh=MSFXIWf/LMVChuvwG9jeF47vF+hV+ouF7NQoXmsmye0=;
	h=Date:To:From:Subject:From;
	b=H+hCagANn8tQ9EaHfzhr93HfNGuQLt8SWdSojQQZsBCSR++thMGbpyVKlaV6H0v40
	 L40SZq10mXRn6oy/iyX/XEPwynJ5f8fJPpjh7rsslfiCaI31iz1eTqgeSHAoLt8AHQ
	 QFm0urDujxfMsKkSvRmiIj8eRzDDC1Fsac+8lyUI=
Date: Sat, 19 Jul 2025 19:26:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch removed from -mm tree
Message-Id: <20250720022644.9CC37C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list
Date: Fri, 27 Jun 2025 20:57:46 +0800

In shrink_folio_list(), the hwpoisoned folio may be large folio, which
can't be handled by unmap_poisoned_folio().  For THP, try_to_unmap_one()
must be passed with TTU_SPLIT_HUGE_PMD to split huge PMD first and then
retry.  Without TTU_SPLIT_HUGE_PMD, we will trigger null-ptr deref of
pvmw.pte.  Even we passed TTU_SPLIT_HUGE_PMD, we will trigger a
WARN_ON_ONCE due to the page isn't in swapcache.

Since UCE is rare in real world, and race with reclaimation is more rare,
just skipping the hwpoisoned large folio is enough.  memory_failure() will
handle it if the UCE is triggered again.

This happens when memory reclaim for large folio races with
memory_failure(), and will lead to kernel panic.  The race is as
follows:

cpu0      cpu1
 shrink_folio_list memory_failure
  TestSetPageHWPoison
  unmap_poisoned_folio
  --> trigger BUG_ON due to
  unmap_poisoned_folio couldn't
   handle large folio

[tujinjiang@huawei.com: add comment to unmap_poisoned_folio()]
  Link: https://lkml.kernel.org/r/69fd4e00-1b13-d5f7-1c82-705c7d977ea4@huawei.com
Link: https://lkml.kernel.org/r/20250627125747.3094074-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Fixes: 1b0449544c64 ("mm/vmscan: don't try to reclaim hwpoison folio")
Reported-by: syzbot+3b220254df55d8ca8a61@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68412d57.050a0220.2461cf.000e.GAE@google.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++++
 mm/vmscan.c         |    8 ++++++++
 2 files changed, 12 insertions(+)

--- a/mm/memory-failure.c~mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list
+++ a/mm/memory-failure.c
@@ -1561,6 +1561,10 @@ static int get_hwpoison_page(struct page
 	return ret;
 }
 
+/*
+ * The caller must guarantee the folio isn't large folio, except hugetlb.
+ * try_to_unmap() can't handle it.
+ */
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC | TTU_HWPOISON;
--- a/mm/vmscan.c~mm-vmscan-fix-hwpoisoned-large-folio-handling-in-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1138,6 +1138,14 @@ retry:
 			goto keep;
 
 		if (folio_contain_hwpoisoned_page(folio)) {
+			/*
+			 * unmap_poisoned_folio() can't handle large
+			 * folio, just skip it. memory_failure() will
+			 * handle it if the UCE is triggered again.
+			 */
+			if (folio_test_large(folio))
+				goto keep_locked;
+
 			unmap_poisoned_folio(folio, folio_pfn(folio), false);
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

