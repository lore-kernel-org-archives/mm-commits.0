Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C51A76CE
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 19:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724874617; cv=none; b=Sfp2NCtYCtXHO4W4Cb0rEveX2b5bLelluG7BQ/oqllcjYZ74LVwMdvq9Bj3aL2xmqXOJvOzDrg4hDlEgF2JJxWYSAASrQ+79kNttjvFGgz7lUFckp1FvyTBnJ/KgYHf0bywlWxt1rvxOIn5FsZVOtE1UkUpwz/1UkXdijFbQx9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724874617; c=relaxed/simple;
	bh=Uq+txNRJdltLqWypB0HHoOziiE6gRmX7zv5sD+5WEuI=;
	h=Date:To:From:Subject:Message-Id; b=rLLqE/G6HJKqJW0XX5n/3eLD+T5gYpjk8Xm32a/8v9sYirvS8CWlID/zLD5NFnVPRObgPBbLz+yDQnoS1hExjEHtwjMQB3kAgUZd0To/CPQJPtjybmQKbrmdoKfV8CUBAiLhwehyZKYGZXamBFrI1lvO2TC8GWstnHc0jNmxd1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RmM9tod6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RmM9tod6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67247C4CEC1;
	Wed, 28 Aug 2024 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724874616;
	bh=Uq+txNRJdltLqWypB0HHoOziiE6gRmX7zv5sD+5WEuI=;
	h=Date:To:From:Subject:From;
	b=RmM9tod6JY7OQo9z60glMpWwhbNIQU390G+qBebds8qlOdPcceTf+tNb43jAm83pP
	 F5f3wBrWO/Er68bVihtM87OFEpw0/UmVd5nHsipRdoVsa6HWJHI276VgpOaUpbhzwJ
	 UmG4PCntC9cuohVt7hy+u8b3bOkDdOjIRGoELMtc=
Date: Wed, 28 Aug 2024 12:50:15 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mjguzik@gmail.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-sort-out-global-lock-annotations-fix.patch added to mm-unstable branch
Message-Id: <20240828195016.67247C4CEC1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-sort-out-global-lock-annotations-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-sort-out-global-lock-annotations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-sort-out-global-lock-annotations-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-sort-out-global-lock-annotations-fix
Date: Wed Aug 28 12:48:16 PM PDT 2024

move section directives to the end of the definitions, per convention

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations-fix
+++ a/mm/hugetlb.c
@@ -72,14 +72,14 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
+DEFINE_SPINLOCK(hugetlb_lock) __cacheline_aligned_in_smp;
 
 /*
  * Serializes faults on the same logical page.  This is used to
  * prevent spurious OOMs when the hugepage pool is fully utilized.
  */
-static __ro_after_init int num_fault_mutexes;
-__ro_after_init struct mutex *hugetlb_fault_mutex_table;
+static int num_fault_mutexes __ro_after_init;
+struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-migrate-convert-to-folio_isolate_movable-checkpatch-fixes.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

