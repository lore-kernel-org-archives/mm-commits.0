Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0C3FEB27
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634347; cv=none; b=YaGrBHMmuGbHU4K85QyqSp0Z3z0ducjMQcChb8R2l2rQrQIMgvpTegZRIp/BSZQ/oEPEMczaCJKeFE/jpfU/wAYjzM99laySydwWAYheAn4sskxf0mma2LoBHQ2JtWpixODGwq9FWn8d859ABcvCHJAD3uoN68sBE+0nRQjHd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634347; c=relaxed/simple;
	bh=RzdJd/0Q0nOfhZuW+HltfpmIc8m/gGS3SY1G6gWKAws=;
	h=Date:To:From:Subject:Message-Id; b=i7+Q0IrFbFtoQ89jaYbOji03ATZzioBcFeTgD6Yi7s+8yyL+qW6Z34Pgy6Wpe8zRn6QYRn+OZdhMZebZ1DCQ58Sk+kb6mxFvy2/5JRAGCKssWNBnUAty5jJYBukaoohgN8ab17XyqGwj2Qf/C/+QsesJt7CkQ7FB4bXabXZCiQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkDG1GFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkDG1GFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EDDC19423;
	Fri, 27 Mar 2026 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634347;
	bh=RzdJd/0Q0nOfhZuW+HltfpmIc8m/gGS3SY1G6gWKAws=;
	h=Date:To:From:Subject:From;
	b=lkDG1GFduGtKa4p8sBuu0XoIemqXbGKEfyL7ZlXWxjRh5g+/qjsKcY3q4j5H90Oz4
	 DVpETcuc+JQ4pwEa5Nc4hdK0i2kwL+EFnA5Auv9OIueT3NoMYR0XhZfagxSdsgUMq4
	 niLPQvpJBxHauekFrSlMjwSAwt9YWUomvHIiHbDU=
Date: Fri, 27 Mar 2026 10:59:06 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch removed from -mm tree
Message-Id: <20260327175907.32EDDC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
has been removed from the -mm tree.  Its filename was
     selftest-mm-fix-cgroup-task-placement-and-tolerance-in-hugetlb_reparenting_testsh.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
Date: Thu, 12 Mar 2026 17:55:31 +0530

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

Link: https://lkml.kernel.org/r/3b5b4275fed509e13567bba7471a9130bbfa6841.1773305677.git.sayalip@linux.ibm.com
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
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

a.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftest-mm-adjust-hugepage-mremap-test-size-for-large-huge-pages.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugepage-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugepage-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

