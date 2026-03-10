Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BBE3B19D7
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160985; cv=none; b=OzLAFOO+qgtrLT5ORBWAGRoxwXSu8yq/WEc5VwOibpHkyNxuaKEOCMFYjKYfjTEkoz+6NCCdIEVwZnhkZdYlB6JxZjNXprUIjGoSkvH+Apo914d+fhkNHAustzXGfoW7QQFiVBycqjr8c0U9f5WdAbOLH8DYxcgOX9sIZCq4f3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160985; c=relaxed/simple;
	bh=oFkMGYS4nHkQOeV3i1t5txgy5tYRJ9qdlnIZo5ACLmk=;
	h=Date:To:From:Subject:Message-Id; b=PuZdmqX7I2tBAdzKXph0+HAMS50qdMr2BfYUQ9F+VPpgxGBbi6/iHnEuRK8jEWUTlwbilWtrnU1Zxq3YEJnJN/uE9wJBJoilLw25GrLubsbezb87C0i6tqel+UwCPieVOdyxVd/pSel9oBkA3JkY+k9ps/XxZZmC3O+ww/dc40U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NVHwgIsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NVHwgIsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F175C19423;
	Tue, 10 Mar 2026 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773160984;
	bh=oFkMGYS4nHkQOeV3i1t5txgy5tYRJ9qdlnIZo5ACLmk=;
	h=Date:To:From:Subject:From;
	b=NVHwgIsGG2UNxbeD86sTAFH9trVA97IWWaV4SMK+6Su12vQ3AOHC6CsapX0Rk6TGD
	 t0+QH7g3OeO7QdrDKd0OoSabhWcHcBZZcpiI0zmwCwa4BwzH8IQ0h1n+eXJkapqRHo
	 9ffLpxRBIz4aKnUTnsTxtAgRlyWajDMYMvEo0hBk=
Date: Tue, 10 Mar 2026 09:43:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.anjum@collabora.com,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ritesh.list@gmail.com,osalvador@suse.de,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch added to mm-new branch
Message-Id: <20260310164304.9F175C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
has been added to the -mm mm-new branch.  Its filename is
     selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch

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
Subject: selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
Date: Tue, 10 Mar 2026 15:19:22 +0530

Launch write_to_hugetlbfs as a separate process and move only its PID into
the target cgroup before waiting for completion.  This avoids moving the
test shell itself, prevents unintended charging to the shell, and ensures
hugetlb and memcg accounting is attributed only to the intended workload.

Add a short delay before the hugetlb allocation to avoid a race where
memory may be charged before the task migration takes effect, which can
lead to incorrect accounting and intermittent test failures.

Also increase the assert_with_retry() tolerance from 7MB to 8MB.  With
MEMCG_CHARGE_BATCH=64U and a 64K base page size, per-CPU batching can
result in up to 8MB of temporary charge being attributed to the parent. 
The previous 7MB threshold could be exceeded, causing false failures;
raise the limit to cover the maximum expected batched charge.

Link: https://lkml.kernel.org/r/f3e1599ae0235e0c41bc1033a3d90fb71d2e3cab.1773134177.git.sayalip@linux.ibm.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
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

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   17 ++++------
 tools/testing/selftests/mm/write_to_hugetlbfs.c        |    5 ++
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -70,7 +70,7 @@ function cleanup() {
 function assert_with_retry() {
   local actual_path="$1"
   local expected="$2"
-  local tolerance=$((7 * 1024 * 1024))
+  local tolerance=$((8 * 1024 * 1024))
   local timeout=20
   local interval=1
   local start_time
@@ -153,18 +153,17 @@ write_hugetlbfs() {
   local size="$3"
 
   if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/$cgroup/cgroup.procs
+    cg_file="$CGROUP_ROOT/$cgroup/cgroup.procs"
   else
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.mems
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.cpus
-    echo $$ >"$CGROUP_ROOT/$cgroup/tasks"
-  fi
-  ./write_to_hugetlbfs -p "$path" -s "$size" -m 0 -o
-  if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/cgroup.procs
-  else
-    echo $$ >"$CGROUP_ROOT/tasks"
+    cg_file="$CGROUP_ROOT/$cgroup/tasks"
   fi
+
+  # Spawn write_to_hugetlbfs in a separate task to ensure correct cgroup accounting
+  ./write_to_hugetlbfs -p "$path" -s "$size" -m 0 -o -d & pid=$!
+  echo "$pid" > "$cg_file"
+  wait "$pid"
   echo
 }
 
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	setvbuf(stdout, NULL, _IONBF, 0);
 	self = argv[0];
 
-	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
+	while ((c = getopt(argc, argv, "s:p:m:owlrnd")) != -1) {
 		switch (c) {
 		case 's':
 			if (sscanf(optarg, "%zu", &size) != 1) {
@@ -118,6 +118,9 @@ int main(int argc, char **argv)
 		case 'n':
 			reserve = 0;
 			break;
+		case 'd':
+			sleep(1);
+			break;
 		default:
 			errno = EINVAL;
 			perror("Invalid arg");
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

