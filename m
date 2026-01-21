Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33AB21ABBB
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769024207; cv=none; b=jh37VRarODczt+U84MHbS4BwilD00cvaJ1m7z7FMJMtA+5vatvHrI+41Rl+wfQRkxMhjE2RyNS1m3EqQK6KxKSv/Z/ZWmQXF46dhRmObn8sBud4f8IXcCna96mSexlzu5jjLgN8wXB34OlpsrkYkcN0rAmUMg4iG3EP17UUmvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769024207; c=relaxed/simple;
	bh=1wVoZcqysCxHRvp8u1hBKNex6WnDO+ChzTCNRXaE0us=;
	h=Date:To:From:Subject:Message-Id; b=nn5sxZUEcpRMILTL8Ys1tdNOYQUOC2G3MJfCzUiu12wBH6gVWAVRWb5N9/uBfiETa9z1EN/ihy5DYsZ1bcQUyjUlCi5mk2daPJJJQbxvw9AwqEf6hBACyfqwV+uArdEIzdDr1n0d3o/7DIS+A8ASONjjHrBJQKMZcGSCOzatWPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hbf8r3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hbf8r3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58144C4CEF1;
	Wed, 21 Jan 2026 19:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769024206;
	bh=1wVoZcqysCxHRvp8u1hBKNex6WnDO+ChzTCNRXaE0us=;
	h=Date:To:From:Subject:From;
	b=0hbf8r3NldNN801R+foZoak+kQajOIT6DfZeRrN2miJY8kRjPG8vQw6qu3quRHB5k
	 9Ik8VkETNy1lj2WEEsAqSRdv1HIAKxW9C/qNxfRAd1foCNhF9Fx99Yxg+L1y80VL61
	 KtJOledT+2MMwp6uZJ+qP5ggbhVFNMlu/X/b4hgE=
Date: Wed, 21 Jan 2026 11:36:45 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,songmuchun@bytedance.com,lkp@intel.com,kartikey406@gmail.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch removed from -mm tree
Message-Id: <20260121193646.58144C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
Date: Thu Jan 15 12:37:55 PM PST 2026

add missed rcu_unlock(), needed by "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record".

Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix
+++ a/mm/memcontrol-v1.c
@@ -639,8 +639,10 @@ void memcg1_swapout(struct folio *folio,
 	 * in swapcache, reusing the same swap entries.
 	 */
 	oldid = lookup_swap_cgroup_id(entry);
-	if (oldid == mem_cgroup_id(memcg))
+	if (oldid == mem_cgroup_id(memcg)) {
+		rcu_read_unlock();
 		return;
+	}
 	VM_WARN_ON_ONCE(oldid != 0);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

