Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622CE36E466
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027610; cv=none; b=JPqtlV7XJf8eQUll4MzUJO4Q7qJokjrQF6VjznIiiCgvRlou/nEgpMRwVbKANeyLqgd6SBFVGeT2DhnDnXjn9wlPN39JkU9YZRpx0pD/ZOjS1tffx6ZQZj6AIYN0op9ET27J0D5/mrnzEKOIVdAQfCwhPq7cj/nXmkDD9ygpcWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027610; c=relaxed/simple;
	bh=PStCw95KYXyEfF5McA01K969EkZ2uBPiuc9CHXAr76g=;
	h=Date:To:From:Subject:Message-Id; b=Ac2CuVR78L3fh7VA1mXhjqcWLcqBedCGmvQUHxJcYAI8wPkB+5OqVz3E7hZipqOHEI9KJP6R2YrmxxDb/IHeM0kgqrOk5Tmf3lmOvSLfrvUbuZq353D0jZu/uVNnZuwKAH+2++C/f2tVoGUsUI+U1oEWkjXa3IBVUxpQQL3tXVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BA2lem3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BA2lem3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366571F00898;
	Fri, 29 May 2026 04:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027609;
	bh=DjESzRzSl+KBTj1Qi3NHzjbVzF4HpL1K6AAATSlhhiU=;
	h=Date:To:From:Subject;
	b=BA2lem3TY59lPNsoGgJj3A0j19AZNeJGdcQtbYfJMJwYO9qwYtK50dvxReBFRiq62
	 1C/3mLRQqhjvQzR7ZlRaJB4sLRXjV/WLNg6mlUdUg3YTffp7C0DRcMV08b/EcjsMp2
	 MtwGRrVAixKrQK2dfiBMsgg4pwLHdCrE1Yixyuro=
Date: Thu, 28 May 2026 21:06:48 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-use-bool-for-forcekill-state.patch removed from -mm tree
Message-Id: <20260529040649.366571F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: use bool for forcekill state
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-bool-for-forcekill-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/memory-failure: use bool for forcekill state
Date: Fri, 10 Apr 2026 15:47:39 +0800

'forcekill' is used as a boolean flag to control whether processes should
be forcibly killed.  It is only assigned from boolean expressions and
never used in arithmetic or bitmask operations.

Convert it from int to bool.

No functional change intended.

Link: https://lore.kernel.org/20260410074740.2524718-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-bool-for-forcekill-state
+++ a/mm/memory-failure.c
@@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct
  * Only do anything when FORCEKILL is set, otherwise just free the
  * list (this is used for clean pages which do not need killing)
  */
-static void kill_procs(struct list_head *to_kill, int forcekill,
+static void kill_procs(struct list_head *to_kill, bool forcekill,
 		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
@@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struc
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int forcekill;
+	bool forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
 	/*
@@ -1703,7 +1703,7 @@ static void unmap_and_kill(struct list_h
 		unmap_mapping_range(mapping, start, size, 0);
 	}
 
-	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
+	kill_procs(to_kill, !!(flags & MF_MUST_KILL), pfn, flags);
 }
 
 /*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-khugepaged-fix-inconsistent-mmf_vm_hugepage-flag-due-to-allocation-failure-order.patch
tools-mm-page-types-fix-typo-in-madvise-error-message.patch
tools-mm-page-types-fix-ternary-operator-precedence-in-sigbus-handler.patch
tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch
mm-memory-failure-remove-hugetlb-output-parameter-from-try_memory_failure_hugetlb.patch

