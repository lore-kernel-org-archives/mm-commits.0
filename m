Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176581AAC9
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398403; cv=none; b=s0ga46SGpHb3gZYZJAV6KzqeK/FtqnSm41acy6L+E+tHLfYncM4ISIj8oAk0SWmjyoX/iTEwOg1jkx7/8pGCL86LAYh3oXn2sgWf4fkYQ5ZosIoZ3xCYQI/1zsF+wckEjhJa6vDjPhKXWeZJGVXf6Ofg3ec4c5CTQvivRXgFyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398403; c=relaxed/simple;
	bh=ybtrG0QfmypogTlOmuIjn1Y2VNRuo+Zzhree4BLKrhU=;
	h=Date:To:From:Subject:Message-Id; b=sNQYe4SHjAOw6aiehBXBRB41Wj41ZofGKVvKtBJ2ygnEbS4hXZ0VYiv8++xEY8CL6HgsUaKKVJ0olVB+CFf+xLUxOuABVD22YDRC1U+kTdWfnE7yDjUVjEIMQG1JL0wggThwSGRqiR2SNmXvzpwT5beAKCvJM++t2tjyTf5HWUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YtYQGrne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YtYQGrne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78917C4CEE2;
	Thu,  9 Jan 2025 04:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398402;
	bh=ybtrG0QfmypogTlOmuIjn1Y2VNRuo+Zzhree4BLKrhU=;
	h=Date:To:From:Subject:From;
	b=YtYQGrneI0mwdO9zwdoH1gGStKs777y+G5rDc81aS7jwZnGS2EtKJzSM8KP3ODCDV
	 rwN1Q2LSOYoX6fowtKic7fGP2Z/KQwJHkLFfdHIIBf91dukJ1ASFKSa62Vf6cUX3oQ
	 MQFoqEsWoNMwv+oOUsCNGdFyAvu6CgYTslTMCdw8=
Date: Wed, 08 Jan 2025 20:53:21 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,mjguzik@gmail.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch removed from -mm tree
Message-Id: <20250109045322.78917C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
Date: Mon Dec  9 07:53:02 PM PST 2024

add comment from David

Link: https://lkml.kernel.org/r/f5a65bf5-5105-4376-9c1c-164a15a4ab79@redhat.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/page_ref.h~mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix
+++ a/include/linux/page_ref.h
@@ -234,8 +234,15 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page))
+	if (!page_is_fake_head(page)) {
+		/*
+		 * atomic_add_unless() will currently never modify the value
+		 * if it already is u. If that ever changes, we'd have to have
+		 * a separate check here, such that we won't be writing to
+		 * write-protected vmemmap areas.
+		 */
 		ret = atomic_add_unless(&page->_refcount, nr, u);
+	}
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch
huge_memory-add-vmf_insert_folio_pud-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

