Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332B92882CE;
	Thu, 23 Oct 2025 19:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761247174; cv=none; b=j2qgoD0NHA0zCGTRZSyjX2+1na7Asuu4kE2N5JHNSrFfRUI47BDhmMWgqGk2VTfni8ELDYtuymLcCXe8ObK764VHyM//VkCOr8DCbmoAmp0RTZ9xl73ZTne5rftWoOEB0Gx1S3c7RXT48KhefqSu0C6zMhKpVB9jVfHS8sw3pf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761247174; c=relaxed/simple;
	bh=xSN33ckHWy2DnDnDh/Q10bkVjzCcj1JNR/mdx/FDXy0=;
	h=Date:To:From:Subject:Message-Id; b=s++97Re8DNvsc+8C15k9jCtGST421eXsPok58vGN/nsy7rRUSQEZJQiybpFiIq0w1JPw8yRrThau67oz3VqtCxJqFH2w/dbK50AgNVDBs14kWBWvqrae125kxS6TDe33V3qm9gCnpKE/f57LSV9H7/lHbas0H+T76tDVhzl63EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tZ/Dw/+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZ/Dw/+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3237C4CEE7;
	Thu, 23 Oct 2025 19:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761247173;
	bh=xSN33ckHWy2DnDnDh/Q10bkVjzCcj1JNR/mdx/FDXy0=;
	h=Date:To:From:Subject:From;
	b=tZ/Dw/+q8EaRP2xR/QB1ZamBjgZucpfS7ZBI3i4RI98OgloiLVHaWGWD8dulE/nB4
	 LVnk5kGQN0OFAu7Kr8PjUSVtZ+1Ll4dJhXp+A6gQ961X/vrFAtADsdZ82Xp0843DyC
	 esaZa3DIKFBkqKUkWOig7M7pgsaIB0YiXgKG4dPs=
Date: Thu, 23 Oct 2025 12:19:33 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,david@redhat.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-do-not-perform-synchronous-discard-during-allocation.patch added to mm-new branch
Message-Id: <20251023191933.A3237C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: do not perform synchronous discard during allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-do-not-perform-synchronous-discard-during-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-do-not-perform-synchronous-discard-during-allocation.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: do not perform synchronous discard during allocation
Date: Fri, 24 Oct 2025 02:34:11 +0800

Patch series "mm, swap: misc cleanup and bugfix", v2.

A few cleanups and a bugfix that are either suitable after the swap table
phase I or found during code review.

Patch 1 is a bugfix and needs to be included in the stable branch, the
rest have no behavioral change.


This patch (of 5):

Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
fast path"), swap allocation is protected by a local lock, which means we
can't do any sleeping calls during allocation.

However, the discard routine is not taken well care of.  When the swap
allocator failed to find any usable cluster, it would look at the pending
discard cluster and try to issue some blocking discards.  It may not
necessarily sleep, but the cond_resched at the bio layer indicates this is
wrong when combined with a local lock.  And the bio GFP flag used for
discard bio is also wrong (not atomic).

It's arguable whether this synchronous discard is helpful at all.  In most
cases, the async discard is good enough.  And the swap allocator is doing
very differently at organizing the clusters since the recent change, so it
is very rare to see discard clusters piling up.

So far, no issues have been observed or reported with typical SSD setups
under months of high pressure.  This issue was found during my code
review.  But by hacking the kernel a bit: adding a mdelay(500) in the
async discard path, this issue will be observable with WARNING triggered
by the wrong GFP and cond_resched in the bio layer for debug builds.

So now let's apply a hotfix for this issue: remove the synchronous discard
in the swap allocation path.  And when order 0 is failing with all cluster
list drained on all swap devices, try to do a discard following the swap
device priority list.  If any discards released some cluster, try the
allocation again.  This way, we can still avoid OOM due to swap failure if
the hardware is very slow and memory pressure is extremely high.

This may cause more fragmentation issues if the discarding hardware is
really slow.  Ideally, we want to discard pending clusters before
continuing to iterate the fragment cluster lists.  This can be implemented
in a cleaner way if we clean up the device list iteration part first.

Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com
Link: https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com
Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast path")
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swap-do-not-perform-synchronous-discard-during-allocation
+++ a/mm/swapfile.c
@@ -1101,13 +1101,6 @@ new_cluster:
 			goto done;
 	}
 
-	/*
-	 * We don't have free cluster but have some clusters in discarding,
-	 * do discard now and reclaim them.
-	 */
-	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))
-		goto new_cluster;
-
 	if (order)
 		goto done;
 
@@ -1394,6 +1387,33 @@ start_over:
 	return false;
 }
 
+/*
+ * Discard pending clusters in a synchronized way when under high pressure.
+ * Return: true if any cluster is discarded.
+ */
+static bool swap_sync_discard(void)
+{
+	bool ret = false;
+	int nid = numa_node_id();
+	struct swap_info_struct *si, *next;
+
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+		spin_unlock(&swap_avail_lock);
+		if (get_swap_device_info(si)) {
+			if (si->flags & SWP_PAGE_DISCARD)
+				ret = swap_do_scheduled_discard(si);
+			put_swap_device(si);
+		}
+		if (ret)
+			return true;
+		spin_lock(&swap_avail_lock);
+	}
+	spin_unlock(&swap_avail_lock);
+
+	return false;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio
 		}
 	}
 
+again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(&entry, order))
 		swap_alloc_slow(&entry, order);
 	local_unlock(&percpu_swap_cluster.lock);
 
+	if (unlikely(!order && !entry.val)) {
+		if (swap_sync_discard())
+			goto again;
+	}
+
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (mem_cgroup_try_charge_swap(folio, entry))
 		goto out_free;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch
mm-swap-do-not-perform-synchronous-discard-during-allocation.patch
mm-swap-rename-helper-for-setup-bad-slots.patch
mm-swap-cleanup-swap-entry-allocation-parameter.patch
mm-migrate-swap-drop-usage-of-folio_index.patch
mm-swap-remove-redundant-argument-for-isolating-a-cluster.patch

