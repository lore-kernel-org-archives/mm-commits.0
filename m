Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B6E485CCA
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 16:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785946572; cv=none; b=Da/DAQnGeoDcEZ6Lm++vjZsQjQDUiZEEmXkb6g9W8N2gyvO6tjoZKdPjsRRMmqOcn2SSx6JskrGIdsiMcWltt1Z3/WErve0AgQFTSbegFQDE5hdQAseEPqZ9lpxlHJ7J/XjyeGAswLIUakIGZcyZXX7AmQB+GXPG6tfKDPp+Xec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785946572; c=relaxed/simple;
	bh=C+48VvCLE/agrP8TGl/KMtAk5InTxMarUybWfO9Db60=;
	h=Date:To:From:Subject:Message-Id; b=N+o78QFvQSOlqdcSGqb7iqvDnh/iAKN7RN9nZRbYQc1nu9TSDlSnYDTaz2fkfksNQMOvWQ/ZCDIThAWGLysrndm5ZDorwD8tujJaYAxiSsxz/tZe7FjwHBs+YlD7bDXAvVWJDwKgWnx4Dgcsz2gZNJw/XAFwf8eMrmbESIxgQkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1PRXUeOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1PRXUeOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9581F00A3A;
	Wed,  5 Aug 2026 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785946563;
	bh=TAhKhtKmOPRLe+/cEvLCcB3jqRM/yVlz01Gm/fD9nG4=;
	h=Date:To:From:Subject;
	b=1PRXUeOQIIbN+r6djfAp2QTkxoKFUZ03QA+KsZoNDYpJorjIJnzGFLt8cLtdXBGd3
	 rVP3+e2EbsnH/0oEnaIBTQbA+09YGrXYmCwuEl16PkQgSBHukjhYYcvebS3EbRlfbP
	 skNfqmQxkB2ejITQkpFxd9/kZC/N6QzzYPy6XSEA=
Date: Wed, 05 Aug 2026 09:16:02 -0700
To: mm-commits@vger.kernel.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch removed from -mm tree
Message-Id: <20260805161603.6A9581F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
has been removed from the -mm tree.  Its filename was
     mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
Date: Mon, 3 Aug 2026 23:21:15 +0800

__ksm_enter() decides whether ksmd needs a wakeup by checking if the mm
slot list is empty before inserting the new slot.

The empty check is currently outside ksm_mmlist_lock.  Another CPU can
remove the last slot and let ksmd go back to sleep after the unlocked
check, while this CPU inserts a new slot and skips the wakeup based on the
stale result.

Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
transition and the insertion are observed as one critical section.

Link: https://lore.kernel.org/20260805132736.1063408-1-xialonglong2025@163.com
Link: https://lore.kernel.org/20260803152115.3479919-1-xialonglong2025@163.com
Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter
+++ a/mm/ksm.c
@@ -3053,7 +3053,7 @@ int __ksm_enter(struct mm_struct *mm)
 {
 	struct ksm_mm_slot *mm_slot;
 	struct mm_slot *slot;
-	int needs_wakeup;
+	bool needs_wakeup;
 
 	mm_slot = mm_slot_alloc(mm_slot_cache);
 	if (!mm_slot)
@@ -3061,10 +3061,9 @@ int __ksm_enter(struct mm_struct *mm)
 
 	slot = &mm_slot->slot;
 
+	spin_lock(&ksm_mmlist_lock);
 	/* Check ksm_run too?  Would need tighter locking */
 	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
-
-	spin_lock(&ksm_mmlist_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
 	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch

