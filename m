Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E23A6B8F
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785946627; cv=none; b=Dh/DXxgPQdKfx6saNDT1rIIY3OxG1OkEKbJn3ckysutgzXep1NmNqcv7qxcce5jK3p110DCbbR7/dhk5KfS70BxHW/6sbPVlWJUGu8zy7qtB3CVocsm3yX1c2xi/0NNgbmDiZRELYgzwOiMTA6WCDuhC8hxshejLf0iFtb11zdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785946627; c=relaxed/simple;
	bh=hycgAqX4u+6jtB2TkgmB1GgSccWpnwMWC+afPgWB+mU=;
	h=Date:To:From:Subject:Message-Id; b=M/pOH0rbQKLR7Rau6ePL8KsI7jiUuEZo7kvDTL5TWiQi+QSiJgQ1HlVTsqO9EEWrsIifc4FpAgs5fPCVnlFjO29Zy4q8kK75OsBaFaKt748b1qk8bt/h0GWTiNksWFDi3fNZuqGSnF+eNTjg2FYwYbZDYKYBgEmoiGqF585Vml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkmpI8oS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkmpI8oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B5C1F000E9;
	Wed,  5 Aug 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785946625;
	bh=q7Yr2U4jFw90sBUItX0FYlNKKhkjhwBRPkkMoCSVjAw=;
	h=Date:To:From:Subject;
	b=FkmpI8oSocTQOs5QHh0Vpdas4Do1p0S7WcUmtFlDaBp0K2Wgr0Hj+H+sRaE8HEN8p
	 W8bYhamSdhUWk4RfvAUPHw77ZHGz4AsqVCaMYVvtoZbW1CcxxG7hHGKgLMpnEn12zh
	 xfr3k0mR0QDSXi6j5L0yzkU9yUVDO84daq1cscUQ=
Date: Wed, 05 Aug 2026 09:17:05 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,ieidus@redhat.com,david@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch added to mm-unstable branch
Message-Id: <20260805161705.64B5C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: avoid missing ksmd wakeups in ksm_enter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch

