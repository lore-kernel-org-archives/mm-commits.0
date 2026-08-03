Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6A42E007
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 18:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785780682; cv=none; b=vBOEziTy+WRGqvJJ9jEdEKwPU2fuBVenuOr26I/c0f8gsGxEARFmrkU2J5eAolf5/R1DUm6aqWqhE54ng15UC8p9E3qdKKEGyNsiPBEeuFxAfM4hxTapvfHlxl3k1jw8tE7uz/EnWKAKOHW6bZdtZx5POjXgmRWmBSaFhsSLVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785780682; c=relaxed/simple;
	bh=nw7XwTxCiu/GzWFO6ve2rmZttQmpgyZJ9lCqm3EW5eE=;
	h=Date:To:From:Subject:Message-Id; b=nFpmf8dcFm9ZTmJCpPNw5WKhvddxr63H1tAG1B1JBbR3QQrOrPqlwiat/1dhbTojOQN6ngpaH5VU4Q78TmZU3L+yiPw5LOgrxd3dkqw14vwtIogYFQF05x7QIL9VTC/A8PZfMj7scJ8D33dHFRzfCXysOitEbXlvosSh+sEv4vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ryaIEKNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ryaIEKNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E6B1F000E9;
	Mon,  3 Aug 2026 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785780680;
	bh=wVVMXMmbgf9AoNZYONgwageyj4uNnVPKD18zWzT9Hfc=;
	h=Date:To:From:Subject;
	b=ryaIEKNjj/IuqTIOpCtst2RfIzQpZxtq/ZUcpA52EHfaWVmenogAqdB4t5XI5lJJm
	 2Y5bR9AFXjqb3CwI1iRxnZLLnV98uScyBLVJevk1Zw+1T8ztNVv+hQ/npLAttixghJ
	 wktsNGF4L0Wt5SRJIYClYehEJJRM2Mg9DD0LEKXI=
Date: Mon, 03 Aug 2026 11:11:20 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ieidus@redhat.com,david@kernel.org,chengming.zhou@linux.dev,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch added to mm-new branch
Message-Id: <20260803181120.B1E6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

Link: https://lore.kernel.org/20260803152115.3479919-1-xialonglong2025@163.com
Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

