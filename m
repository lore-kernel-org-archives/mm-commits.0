Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6FE2C11F3
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160978; cv=none; b=BE2oEuFPt3rWL9g9VDi/4NFjbpMtG2VSuepa5u7x5DieoiKPBqKoXsRz52R3ux7HfYx0hvVXYjqVhUe2hY22eZgVKg8EuCh0+ikRae4Ngux7QTwvw+/hbFsSW2uFonxguWN7j8HxtHwKORaauuFbl0DxSLAnzVLOb+/YWpBnL/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160978; c=relaxed/simple;
	bh=1msxsdQE9+MA+ZD7C0w/m+uFbcAZZ86sN0f+gTL4qWE=;
	h=Date:To:From:Subject:Message-Id; b=kiOMD5AHrPSZp8cp4qUxjw3QqG9vKn0YoEtZu4XpwvCYCA6gmz5sPESbAbxZRec1lakhmKzqiF4q92GqP+ABlS+U0qhuz5xttIkDs6cLM9nIRSnp6VOjmEKpimJHuW3Kjb1bYd6p2oP490bonaP0bCIUm1SZfkVr0JMvURgSWl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bocaz1Az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bocaz1Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D90C19423;
	Tue, 10 Mar 2026 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773160977;
	bh=1msxsdQE9+MA+ZD7C0w/m+uFbcAZZ86sN0f+gTL4qWE=;
	h=Date:To:From:Subject:From;
	b=Bocaz1Azd0PjjgjOyHmRslbDREP2QiqEcaX26UAGinLUBFnKZoK2bjRbof+pei3OF
	 dc8/jO8WZb8N+H7Cux34p1ttFoQ1JQS0cBarleSX6jJJRzBH5ZSAPIe2q+hF8D3Kl3
	 dOLvgD3vTp3ZrUYCWfuiJ89TK0ee1ISt5VJJ37g0=
Date: Tue, 10 Mar 2026 09:42:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@collabora.com,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch added to mm-new branch
Message-Id: <20260310164257.B5D90C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: restore default nr_hugepages value during cleanup in charge_reserved_hugetlb.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh.patch

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
Subject: selftests/mm: restore default nr_hugepages value during cleanup in charge_reserved_hugetlb.sh
Date: Tue, 10 Mar 2026 15:19:19 +0530

Patch series "selftests/mm: fix failures and robustness improvements".

Powerpc systems with a 64K base page size exposed several issues while
running mm selftests. Some tests assume specific hugetlb configurations,
use incorrect interfaces, or fail instead of skipping when the required
kernel features are not available.

This series fixes these issues and improves test robustness.


This patch (of 13):

During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
set to 0.  At the end of the test, if all tests pass, the original
nr_hugepages value is restored.  However, if any test fails, it remains
set to 0.

With this patch, we ensure that the original nr_hugepages value is
restored during cleanup, regardless of whether the test passes or fails.

Link: https://lkml.kernel.org/r/cover.1773134177.git.sayalip@linux.ibm.com
Link: https://lkml.kernel.org/r/aef8d9c1c6fb2b80af90543be21e15030e720733.1773134177.git.sayalip@linux.ibm.com
Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
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

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-charge_reserved_hugetlbsh
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -65,7 +65,7 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
+  echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
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

