Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F3420C490;
	Tue, 23 Dec 2025 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455286; cv=none; b=HwH0L7uFWTQtK9OCwon5FbI/Sem/4nmrHe3ntq+O+YB2XJT1P4gNvjnrntTqDo/DfBuamz9qo7ndHDvW3fqzNlQvimAKk+M/pQuhcNTj4odZ/Dzf3ylemgbXpC0yCZ/cg0g9K99qi/oW6lx/p0GiVEABhRztI/OnSp/0gszKe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455286; c=relaxed/simple;
	bh=VibKW4rFrlqEVk5lvNzEgf8tiJl1ks8BIBvxSH4K4qE=;
	h=Date:To:From:Subject:Message-Id; b=JVzLYLB7bJyZLJ9yzzF0fHoyX6+2ddAKzOjLPE7P2Vx4G9ouzX+vZ6csx0ToxgKP1qoVe88myE6HH7xuLvVcJkMvjBh7iAYXHgYOcPV9+t+abs/m5cCQkO7Y3zc7SHqUl1+g3uFS18SK2YbQqsNdBBn0pO3j/rij3bzkKznx0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j1lsA8QB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j1lsA8QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86B6C4CEF1;
	Tue, 23 Dec 2025 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455285;
	bh=VibKW4rFrlqEVk5lvNzEgf8tiJl1ks8BIBvxSH4K4qE=;
	h=Date:To:From:Subject:From;
	b=j1lsA8QBnkfKnaR1+nwrSLxHdhY0fOP1hZWqcWZAzqG7obDiTpFrHvzlYNRs0zBs/
	 x9fvzAxnv0UcD9IMZNiErNMrqlIw33ZdUHexGl/Dv0E0/Op721DFFOMDmH1ptRXuiU
	 13Bv4UhsNR81aR7DS0imT2i+IM5Y33eC08JrNkJY=
Date: Mon, 22 Dec 2025 18:01:25 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,broonie@kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch added to mm-new branch
Message-Id: <20251223020125.A86B6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add missing static initializer for init_mm::mm_cid.lock
has been added to the -mm mm-new branch.  Its filename is
     mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: add missing static initializer for init_mm::mm_cid.lock
Date: Sun, 21 Dec 2025 18:29:22 -0500

Patch series "MM_CID and HPCC mm_struct static init fixes".

Mark Brown reported a regression [1] on linux next due to the hierarchical
percpu counters (HPCC).  You mentioned they were only in mm-new (and
therefore not pulled into -next) [2], but it looks like they got more
exposure that we expected.  :)

This bug hunting got me to fix static initialization issues in both MM_CID
(for upstream) and HPCC (mm-new).  Mark tested my series and confirmed
that it fixes his issues.


This patch (of 5):

Initialize the mm_cid.lock struct member of init_mm.

Link: https://lkml.kernel.org/r/20251221232926.450602-2-mathieu.desnoyers@efficios.com
Fixes: 8cea569ca785 ("sched/mmcid: Use proper data structures")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/init-mm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/init-mm.c~mm-add-missing-static-initializer-for-init_mm-mm_cidlock
+++ a/mm/init-mm.c
@@ -44,6 +44,9 @@ struct mm_struct init_mm = {
 	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
+#ifdef CONFIG_SCHED_MM_CID
+	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
+#endif
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch
mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch
tsacct-skip-all-kernel-threads.patch

