Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34343B961A
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773161002; cv=none; b=D5FCQESEEBhHgoAvjgcSSOBUgWs2Lql0rYY8DuUkQt2T6DNK8l5j8x4K4xFu2c/zwGhHYpdTXwFdoaBWp61+gQI6YztnlWyzyaQz669MLnTESQtq/5zZ7Ps3CarDDimtBZfdOzdLj2U00592gqvXk76465i3lBE2QY0al5mJBx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773161002; c=relaxed/simple;
	bh=XXF5cb2oyWqEPfizNsD+ITdCLv0zqFNnvhpCMbKCW1o=;
	h=Date:To:From:Subject:Message-Id; b=Zgh98f3uynbF/8kAgssmShn69wA4NKws/L6Al5bgULcFUNen3shG4A0uP6FE+db5qvyB0WuUgBF07yaRT8lEo8Wsd5a4rwhUP1IZsdw6fU166VCid6BS0BSMqQs/H+BSSUBLUlgu+180wFytzXfT0QT8VaGA/64pTLPYJ5kKyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jXXdLS1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jXXdLS1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C7CC19423;
	Tue, 10 Mar 2026 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773161001;
	bh=XXF5cb2oyWqEPfizNsD+ITdCLv0zqFNnvhpCMbKCW1o=;
	h=Date:To:From:Subject:From;
	b=jXXdLS1eM5rv+JGZehwxUIDnH4rT4JZ1t8TixCewvLMKKOEuwZCX9KK0mRyDLEOnI
	 StflxBlQF8TWr0fYeoxDw6L4kz+0WYkGk3yzOw6vFPqox9P+geMIZrxBTBQjn2s9v1
	 xmoWWacCl9zLu/0mXDhrROpdoBjc55dAR+rFt3KI=
Date: Tue, 10 Mar 2026 09:43:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@collabora.com,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch added to mm-new branch
Message-Id: <20260310164321.76C7CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix double increment in linked list cleanup in compaction_test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch

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
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: fix double increment in linked list cleanup in compaction_test
Date: Tue, 10 Mar 2026 15:19:29 +0530

The cleanup loop of allocated memory currently uses:

    for (entry = list; entry != NULL; entry = entry->next) {
        munmap(entry->map, MAP_SIZE);
        if (!entry->next)
            break;
        entry = entry->next;
    }

The inner entry = entry->next causes the loop to skip every other node,
resulting in only half of the mapped regions being unmapped.

Remove the redundant increment to ensure every entry is visited and
unmapped during cleanup.

Link: https://lkml.kernel.org/r/00fdaa3c84427958f51eaefa7603094a090fcebc.1773134177.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -263,9 +263,6 @@ int main(int argc, char **argv)
 
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 
 	if (check_compaction(mem_free, hugepage_size,
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

