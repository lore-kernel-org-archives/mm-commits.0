Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEE73403F9
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400519; cv=none; b=iu4EfGwGXrh5EKeg7CKPzYhC3Vno1bzuYTlnCrvm6pQHM61K1TImMOnYnf+2R5VeWzAxijWdweMopwL9/2pC/DTI7wxV87AGjOmD1rF0v7YSKt0QZpCVfXsG5NBfQ64iiiL+CnkU+Qfu0Ng4Il9PvuIvxmFR+CmuCI1GG7XeOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400519; c=relaxed/simple;
	bh=ilQMhFmXMAbeKbJUwqlq7ZT+M27/P4Mke+HcLsuFz+c=;
	h=Date:To:From:Subject:Message-Id; b=PJd1c2rG0d5T0lmsf/i+sSCcEYvzK2fFITBJf3KL9kJF7agHA6HFPXCCfCKZ2seToVR2s/9h+z77m9jXHDi8i90oURH+gED+ouCnBNeYyYapTSd6LxkWMJCD6xkFHRZulX0NnksfH/SmlhWtBE/P8nZXCakNh9ocMufyzV1ZfHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmgCWW5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmgCWW5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6762C1F000E9;
	Thu, 21 May 2026 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400517;
	bh=gzQhFN3Ukjfc3SakzPhu0XyFLHL0lcHRrXnF0X3rbRQ=;
	h=Date:To:From:Subject;
	b=rmgCWW5drfUynIYbwBiCdbyO9SozJ5f3OGfMgMN+gvptOY7+Z8qHQnGpGGtuXvahu
	 zXp/LUKEdo7/+TK9tcrj/Q6J72L9zvCcFCAgGscyC9RHDrm/BT48p0o4aqZ0pxHU0l
	 1JSn7oJjDFw5KXSk01SSk90pi9IHmVzAIgA6m8Z0=
Date: Thu, 21 May 2026 14:55:17 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch added to mm-new branch
Message-Id: <20260521215517.6762C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch

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
Subject: selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
Date: Thu, 21 May 2026 12:17:45 +0530

The test currently moves the calling shell ($$) into the target cgroup
before executing write_to_hugetlbfs.  This results in the shell and any
intermediate allocations being charged to the cgroup, introducing noise
and nondeterminism in accounting.  It also requires moving the shell back
to the root cgroup after execution.

Spawn a helper process that joins the target cgroup and exec()'s
write_to_hugetlbfs.  This ensures that only the workload is accounted to
the cgroup and avoids unintended charging from the shell.

The test currently validates both hugetlb usage and memory.current. 
However, memory.current includes internal memcg allocations and per-CPU
batched accounting (MEMCG_CHARGE_BATCH), which are not synchronized and
can vary across systems, leading to non-deterministic results.

Since hugetlb memory is accounted via hugetlb.<size>.current,
memory.current is not a reliable indicator here.  Drop memory.current
checks and rely only on hugetlb controller statistics for stable and
accurate validation.

Link: https://lore.kernel.org/fb57491ba83cb0a499c72922e1579b61bee514db.1779296493.git.sayalip@linux.ibm.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   42 ++++------
 1 file changed, 18 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -105,22 +105,17 @@ function assert_with_retry() {
 }
 
 function assert_state() {
-  local expected_a="$1"
-  local expected_a_hugetlb="$2"
-  local expected_b=""
+  local expected_a_hugetlb="$1"
   local expected_b_hugetlb=""
 
-  if [ ! -z ${3:-} ] && [ ! -z ${4:-} ]; then
-    expected_b="$3"
-    expected_b_hugetlb="$4"
+  if [ ! -z ${2:-} ]; then
+    expected_b_hugetlb="$2"
   fi
 
-  assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
   assert_with_retry \
 	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
-  if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
-    assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
+  if [[ -n "$expected_b_hugetlb" ]]; then
     assert_with_retry \
 	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
@@ -154,18 +149,17 @@ write_hugetlbfs() {
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
+  # Spawn helper to join cgroup before exec to ensure correct cgroup accounting
+  bash -c 'echo $$ > "$1"; exec ./write_to_hugetlbfs -p "$2" -s "$3" -m 0 -o' _ \
+	  "$cg_file" "$path" "$size" & pid=$!
+  wait "$pid"
   echo
 }
 
@@ -203,21 +197,21 @@ if [[ ! $cgroup2 ]]; then
   write_hugetlbfs a "$MNT"/test $size
 
   echo Assert memory charged correctly for parent use.
-  assert_state 0 $size 0 0
+  assert_state $size 0
 
   write_hugetlbfs a/b "$MNT"/test2 $size
 
   echo Assert memory charged correctly for child use.
-  assert_state 0 $(($size * 2)) 0 $size
+  assert_state $(($size * 2)) $size
 
   rmdir "$CGROUP_ROOT"/a/b
   echo Assert memory reparent correctly.
-  assert_state 0 $(($size * 2))
+  assert_state $(($size * 2))
 
   rm -rf "$MNT"/*
   umount "$MNT"
   echo Assert memory uncharged correctly.
-  assert_state 0 0
+  assert_state 0
 
   cleanup
 fi
@@ -231,16 +225,16 @@ echo write
 write_hugetlbfs a/b "$MNT"/test2 $size
 
 echo Assert memory charged correctly for child only use.
-assert_state 0 $(($size)) 0 $size
+assert_state $(($size)) $size
 
 rmdir "$CGROUP_ROOT"/a/b
 echo Assert memory reparent correctly.
-assert_state 0 $size
+assert_state $size
 
 rm -rf "$MNT"/*
 umount "$MNT"
 echo Assert memory uncharged correctly.
-assert_state 0 0
+assert_state 0
 
 cleanup
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch
selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch
selftests-mm-fix-cgroup-task-placement-and-drop-memorycurrent-checks-in-hugetlb_reparenting_testsh.patch
selftests-mm-size-tmpfs-according-to-pmd-page-size-in-split_huge_page_test.patch
selftests-mm-free-dynamically-allocated-pmd-sized-buffers-in-split_huge_page_test.patch
selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch
selftests-mm-ensure-destination-is-hugetlb-backed-in-hugetlb-mremap.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero.patch
selftests-mm-skip-uffd-stress-test-when-nr_pages_per_cpu-is-zero-fix.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

