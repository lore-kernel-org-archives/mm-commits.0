Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9862C161;
	Sat, 26 Oct 2024 00:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729901685; cv=none; b=A0bKs9clA6yIPIO9/K0W3ncJXwOc9YieSCERr9MuYeE0IDPFKc6ZmYL9Et2qjDGyoI5rhKMhVdCpwQrfYpU4TCdyMFNMJYLPoArj8QHj6ASCFEQWlTrmLCl4lrm7+NOi782RN5PekQIVVZGF5Rn6PyF2DdEJM7ETgyLBasZ7b7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729901685; c=relaxed/simple;
	bh=JCTwkerKsQ8saY+K1MWicExBbuKZ8wwvOZSbsUVZ7R4=;
	h=Date:To:From:Subject:Message-Id; b=Sy/3LMzAY5DrbyHRvClPLqbx8M9btujyLct+EmLpImI/+5PIzumdN0XFXbg8IlJMldtWgGarsFX7Nuh1yp8BOINtAibCQMt5Hz4ypJtDa3MRabWvlXzqBa5yBuooo5LAgjjD5zwlyc8VUKw6bYN5S6lV/nBQnmD/ILBthw06sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yGcpODAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yGcpODAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C719C4CEC3;
	Sat, 26 Oct 2024 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729901685;
	bh=JCTwkerKsQ8saY+K1MWicExBbuKZ8wwvOZSbsUVZ7R4=;
	h=Date:To:From:Subject:From;
	b=yGcpODAsamMIQcObo2K7w2nxt4I2WW1tAxT8vfbwDXXQslvKOND1ZJIgAfiYcz7J5
	 i0g6PRIF0aTeWI6XWTcDrhVS4PQYa8FQJ929P1q6Zs3agHhkeOC/3jB8Yk6zaHEbGS
	 bl3T731if3WNxtJ6CWcepN/rs7pwWiddAsxyW10M=
Date: Fri, 25 Oct 2024 17:14:44 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,liyangouwen1@oppo.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch removed from -mm tree
Message-Id: <20241026001445.2C719C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid unconditional one-tick sleep when swapcache_prepare fails
has been removed from the -mm tree.  Its filename was
     mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[v-songbaohua@oppo.com: wake_up only when swapcache_wq waitqueue is active]
  Link: https://lkml.kernel.org/r/20241008130807.40833-1-21cnbao@gmail.com
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

 mm/memory.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails
+++ a/mm/memory.c
@@ -4187,6 +4187,8 @@ static struct folio *alloc_swap_folio(st
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -4199,6 +4201,7 @@ vm_fault_t do_swap_page(struct vm_fault
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *swapcache, *folio = NULL;
+	DECLARE_WAITQUEUE(wait, current);
 	struct page *page;
 	struct swap_info_struct *si = NULL;
 	rmap_t rmap_flags = RMAP_NONE;
@@ -4297,7 +4300,9 @@ vm_fault_t do_swap_page(struct vm_fault
 					 * Relax a bit to prevent rapid
 					 * repeated page faults.
 					 */
+					add_wait_queue(&swapcache_wq, &wait);
 					schedule_timeout_uninterruptible(1);
+					remove_wait_queue(&swapcache_wq, &wait);
 					goto out_page;
 				}
 				need_clear_cache = true;
@@ -4604,8 +4609,11 @@ unlock:
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
-	if (need_clear_cache)
+	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
+	}
 	if (si)
 		put_swap_device(si);
 	return ret;
@@ -4620,8 +4628,11 @@ out_release:
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}
-	if (need_clear_cache)
+	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
+	}
 	if (si)
 		put_swap_device(si);
 	return ret;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-pswpin-counter-for-large-folios-swap-in.patch

