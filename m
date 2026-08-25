Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822FD32ED4E
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622829; cv=none; b=fl5e6G6AYFZClKavPzs4e3+Tmh2d80qmnnOvihvcFnA18G3dESszIK5fsjYdzzfmDum6Fh7/hJWoPwMXIKlohpSrDzuiMGr2/T2C5QwRFKqczDHAmKmD3qPWW4Lf9j4f1A2cOhEEsGbB/fXNXgjg8i7Re93uHQ1P/aV739B8uCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622829; c=relaxed/simple;
	bh=ttkTQiDxjuUuYzu8+XgOfcEH6seiW+u5dOg4e7w8+Mc=;
	h=Date:To:From:Subject:Message-Id; b=TEKzjEIjaPaF0O6TuwYx09r9Egw7FVOUy0vc4xHb/tKEhJ24WqqCuctLmlu5VMARkTrbqN0nnJp9mk4Aej/rFV6wGV73KueyuSeMCl/pThtItNOSDUHFm5mlrTxld4Ft4E/QHEMJoSaKDrOeA3J/+HhLOtBfMwAgo7mC4uYmk5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRQlIckN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRQlIckN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3821F00A3A;
	Tue, 25 Aug 2026 01:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622828;
	bh=ZlzSH70x47/UcKtW9i0fuus4x+D8kFvKTMkABNkh66Y=;
	h=Date:To:From:Subject;
	b=hRQlIckNIPU8iwU6Re2S/lJahv+0xTY5XYHWSee+nzO3ox/et44jbtu80NSzY5Zc6
	 2vZfVQJNHysDDEVO9cH0upK9ACJDFFhxmvNHzbf7b2HIGeMoUSd3rAP/9NVY04DiJM
	 BMKF7afqa72SATth0VeTE9Ot4gczeooCj9mPNdW4=
Date: Mon, 24 Aug 2026 18:53:47 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ieidus@redhat.com,david@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch removed from -mm tree
Message-Id: <20260825015348.1A3821F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
has been removed from the -mm tree.  Its filename was
     mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
Date: Wed, 5 Aug 2026 21:27:34 +0800

__ksm_enter() decides whether ksmd needs a wakeup by checking if the mm
slot list is empty before inserting the new slot.

The empty check is currently outside ksm_mmlist_lock.  Another CPU can
remove the last slot and let ksmd go back to sleep after the unlocked
check, while this CPU inserts a new slot and skips the wakeup based on the
stale result.

Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
transition and the insertion are observed as one critical section.

Link: https://lore.kernel.org/20260805132736.1063408-1-xialonglong2025@163.com
Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter
+++ a/mm/ksm.c
@@ -3060,10 +3060,9 @@ int __ksm_enter(struct mm_struct *mm)
 
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

mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

