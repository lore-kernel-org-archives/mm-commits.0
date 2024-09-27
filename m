Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1BF524B0;
	Fri, 27 Sep 2024 18:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727461390; cv=none; b=lc6INFfETYWvoT7Npv4p96PGBMg3ZH6ylSTf1mkOmRF/aAl5Qallwjc+2N4SBSl+8olFWveijUvrGfo+dDzjVgWYmqllmnFB0gMYSllKxAjxiz+D0dZvnh2d/edXv3x6XLXGF4yCZcJTgxQbsVf4pMWkejFc+WrjWg90xEteEFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727461390; c=relaxed/simple;
	bh=nYfhe1qyLkVxhTGavQXlFl3mIst3+pK1yM6ZZ6AGcnM=;
	h=Date:To:From:Subject:Message-Id; b=ZvzpirMnQP59UTXsxHid5uUSff8OOsy9/SMCZdqPrD0eQhmW5KKm4eWm537avCHF5drAJvZmnKHlyfSNmThmHoQ1PUmHPvmxgNBwg7rRa0mEEWrQoIms5oE7VnKx+1z92BdaVZAVx7HS4hwmqaWfzkb/ZGbRDv4ECi8XhmUvAP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=he9+Knjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="he9+Knjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEE2C4CEC4;
	Fri, 27 Sep 2024 18:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727461390;
	bh=nYfhe1qyLkVxhTGavQXlFl3mIst3+pK1yM6ZZ6AGcnM=;
	h=Date:To:From:Subject:From;
	b=he9+Knjz5PUXrvI7xmn1az5SgD6a4mJISNCjBo4jGOgaSp9oIzV2gtXbCschQ5ki4
	 eQ4T+8n48tRjwT//seMx/5woaAulRLvSWoDXwHQdSur6MJAyAjF/VHsB7d2pyjiGoW
	 TLold/0zCe5nuK3i/SY+1CeqW0bjOKUrShOPprPo=
Date: Fri, 27 Sep 2024 11:23:09 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,liyangouwen1@oppo.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20240927182310.0AEE2C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: avoid unconditional one-tick sleep when swapcache_prepare fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: avoid unconditional one-tick sleep when swapcache_prepare fails
Date: Fri, 27 Sep 2024 09:19:36 +1200

Commit 13ddaf26be32 ("mm/swap: fix race when skipping swapcache")
introduced an unconditional one-tick sleep when `swapcache_prepare()`
fails, which has led to reports of UI stuttering on latency-sensitive
Android devices.  To address this, we can use a waitqueue to wake up tasks
that fail `swapcache_prepare()` sooner, instead of always sleeping for a
full tick.  While tasks may occasionally be woken by an unrelated
`do_swap_page()`, this method is preferable to two scenarios: rapid
re-entry into page faults, which can cause livelocks, and multiple
millisecond sleeps, which visibly degrade user experience.

Oven's testing shows that a single waitqueue resolves the UI stuttering
issue.  If a 'thundering herd' problem becomes apparent later, a waitqueue
hash similar to `folio_wait_table[PAGE_WAIT_TABLE_SIZE]` for page bit
locks can be introduced.

Link: https://lkml.kernel.org/r/20240926211936.75373-1-21cnbao@gmail.com
Fixes: 13ddaf26be32 ("mm/swap: fix race when skipping swapcache")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Oven Liyang <liyangouwen1@oppo.com>
Tested-by: Oven Liyang <liyangouwen1@oppo.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails
+++ a/mm/memory.c
@@ -4192,6 +4192,8 @@ static struct folio *alloc_swap_folio(st
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -4204,6 +4206,7 @@ vm_fault_t do_swap_page(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *swapcache, *folio = NULL;
+	DECLARE_WAITQUEUE(wait, current);
 	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
@@ -4302,7 +4305,9 @@ vm_fault_t do_swap_page(struct vm_fault
 					 * Relax a bit to prevent rapid
 					 * repeated page faults.
 					 */
+					add_wait_queue(&swapcache_wq, &wait);
 					schedule_timeout_uninterruptible(1);
+					remove_wait_queue(&swapcache_wq, &wait);
 					goto out_page;
 				}
 				need_clear_cache = true;
@@ -4609,8 +4614,10 @@ unlock:
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
-	if (need_clear_cache)
+	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
+		wake_up(&swapcache_wq);
+	}
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -4625,8 +4632,10 @@ out_release:
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}
-	if (need_clear_cache)
+	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
+		wake_up(&swapcache_wq);
+	}
 	if (si)
 		put_swap_device(si);
 	return ret;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch

