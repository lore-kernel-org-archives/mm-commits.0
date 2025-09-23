Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80718275AFA;
	Tue, 23 Sep 2025 20:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758660810; cv=none; b=ekClo3/bMbn8qBwUuGkrEdyss7M6FPf509VV+i8D47A71Fc1A0Txp6OQeBfYfhsIuIa+oPH5U1mLrWXl/pvvkzUA0ARFWtjH/Kcn4P/y4Vh1tIaJDpMHHtFC38bz36ckzmBXOLB2ghB+sW46RhOHzYSAXCUYy6IfLWKjyPjjMSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758660810; c=relaxed/simple;
	bh=S7kuV4IM5np6xEYITyuYJE0L8KFy4LYGQWHw/4jQr8Q=;
	h=Date:To:From:Subject:Message-Id; b=eUnV8gRv26nq5Giq3LqkkHupNSFPSgtUTdhaTGvfp4vT/ofRX5YBfLqyO8U857NqL6ezwQU3qRWb1QKnL6tn/y3I1b/YfnZ3ZaSnXRszivX/gE6uLOD9gdUUJMwYBiYpZANebS0stFmLPYOD4BGcoLz2jEss9qkhb/mC0aKUAMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNlQXMEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNlQXMEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA450C4CEF5;
	Tue, 23 Sep 2025 20:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758660809;
	bh=S7kuV4IM5np6xEYITyuYJE0L8KFy4LYGQWHw/4jQr8Q=;
	h=Date:To:From:Subject:From;
	b=uNlQXMEMoTsikM6b4cUBDhRYVt2QuO1qQnfGA2tqFca7xDjfI4CyfGMqvqH2r3iGS
	 4AVtjWoDo8fdXWcYDsaC5d6wfbZWkDbWG/bs+AZdrfrTfGAlqlH13J8z1KnzdgRTJr
	 xLTf6z8QZ+yfKaVCKbu+OTDOSRfhhEmKDkwr7TgE=
Date: Tue, 23 Sep 2025 13:53:29 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,ritesh.list@gmail.com,richard.weiyang@gmail.com,david@redhat.com,chengming.zhou@linux.dev,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch added to mm-unstable branch
Message-Id: <20250923205329.DA450C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix incorrect KSM counter handling in mm_struct during fork
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch

This patch will later appear in the mm-unstable branch at
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
From: Donet Tom <donettom@linux.ibm.com>
Subject: mm/ksm: fix incorrect KSM counter handling in mm_struct during fork
Date: Wed, 24 Sep 2025 00:16:59 +0530

Patch series "mm/ksm: Fix incorrect accounting of KSM counters during
fork", v3.

The first patch in this series fixes the incorrect accounting of KSM
counters such as ksm_merging_pages, ksm_rmap_items, and the global
ksm_zero_pages during fork.

The following patch add a selftest to verify the ksm_merging_pages counter
was updated correctly during fork.

Test Results
============
Without the first patch
-----------------------
 # [RUN] test_fork_ksm_merging_page_count
 not ok 10 ksm_merging_page in child: 32

With the first patch
--------------------
 # [RUN] test_fork_ksm_merging_page_count
 ok 10 ksm_merging_pages is not inherited after fork


This patch (of 2):

Currently, the KSM-related counters in `mm_struct`, such as
`ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are inherited
by the child process during fork.  This results in inconsistent
accounting.

When a process uses KSM, identical pages are merged and an rmap item is
created for each merged page.  The `ksm_merging_pages` and
`ksm_rmap_items` counters are updated accordingly.  However, after a fork,
these counters are copied to the child while the corresponding rmap items
are not.  As a result, when the child later triggers an unmerge, there are
no rmap items present in the child, so the counters remain stale, leading
to incorrect accounting.

A similar issue exists with `ksm_zero_pages`, which maintains both a
global counter and a per-process counter.  During fork, the per-process
counter is inherited by the child, but the global counter is not
incremented.  Since the child also references zero pages, the global
counter should be updated as well.  Otherwise, during zero-page unmerge,
both the global and per-process counters are decremented, causing the
global counter to become inconsistent.

To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0 during
fork, and the global ksm_zero_pages counter is updated with the
per-process ksm_zero_pages value inherited by the child.  This ensures
that KSM statistics remain accurate and reflect the activity of each
process correctly.

Link: https://lkml.kernel.org/r/cover.1758648700.git.donettom@linux.ibm.com
Link: https://lkml.kernel.org/r/7b9870eb67ccc0d79593940d9dbd4a0b39b5d396.1758648700.git.donettom@linux.ibm.com
Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/ksm.h~mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork
+++ a/include/linux/ksm.h
@@ -56,8 +56,14 @@ static inline long mm_ksm_zero_pages(str
 static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	/* Adding mm to ksm is best effort on fork. */
-	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
+	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
+		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
+
+		mm->ksm_merging_pages = 0;
+		mm->ksm_rmap_items = 0;
+		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
 		__ksm_enter(mm);
+	}
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-fix-double-free-in-register_one_node.patch
mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch
selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch

