Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A478B33CEA2
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400513; cv=none; b=T3JZaPoDzre6+224PWSkA/9gA4qgYgwyVNGZE/OXn8ZiE11x/Ka2PtPGIM39Lxlumy6PKDoiKFTDzHhcif2bvoPfcpxQuvDUrKNDL8U2Vt1NdrcukMVJMr1zFAzsXiTGmYpWgjyADaNgsjCmQePd0FN+u7GlD15KX3bDWSZql+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400513; c=relaxed/simple;
	bh=pMfUyqYU8AjsQ6BzQuN8UXk7c97PicUfbAliWcepS/M=;
	h=Date:To:From:Subject:Message-Id; b=YR8//KbMs5AtkEZ79EZkuFYn5R9lOPE9KGii+kLVQQEST1lI9Q26hhp0FrPxRXRVMq0FOSulZ+PRWLpLpnCv5LczExHEhMNfPCWGttLqvXUJimLgzL8FKvT3kTW5Wfn0U5shbZU0WdKkr95r0lQXnqn22UjARMoCP9bTQHUdLQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K+8rO33O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K+8rO33O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F261F000E9;
	Thu, 21 May 2026 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400511;
	bh=rYAto/03WCVRMxWONgrjO5gPd8fu7uXxOETc2MVdSsI=;
	h=Date:To:From:Subject;
	b=K+8rO33OUMTbC0KmWY9pKT/WtMgb4mPtqDIiSy6Ztt1+IXAfOnL/gZdcHEKMbKGOW
	 w++5guNxISnehvbqy4YdhfxkN81fNbJAnx5AegPvlLiSWzQD8813coN08bO9MtOIgZ
	 lHzMrsoTochsD6fwXRc6/omYgIUDnwAHuYkNi0jo=
Date: Thu, 21 May 2026 14:55:10 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch added to mm-new branch
Message-Id: <20260521215511.41F261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh.patch

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
Subject: selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
Date: Thu, 21 May 2026 12:03:28 +0530

The charge_reserved_hugetlb.sh script assumes hugetlb cgroup memory
interface file names use the "<size>MB" format
(e.g. hugetlb.1024MB.current).
This assumption breaks on systems with larger huge pages such as 1GB,
where the kernel exposes normalized units:
    hugetlb.1GB.current
    hugetlb.1GB.max
    hugetlb.1GB.rsvd.max
    ...

As a result, the script attempts to access files like
hugetlb.1024MB.current, which do not exist when the kernel reports the
size in GB.

Normalize the huge page size and construct the pathname using the
appropriate unit (MB or GB), matching the hugetlb controller naming.

Link: https://lore.kernel.org/04b6b49e4a2acf46319f627caf82b09e6dc1ad7f.1779296493.git.sayalip@linux.ibm.com
Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   42 ++++++----
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-fix-hugetlb-pathname-construction-in-charge_reserved_hugetlbsh
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -94,6 +94,15 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+        # For 1GB hugepages
+        UNIT="GB"
+        MB_DISPLAY=$((MB / 1024))
+else
+        # For 2MB hugepages
+        UNIT="MB"
+        MB_DISPLAY=$MB
+fi
 
 function setup_cgroup() {
   local name="$1"
@@ -103,11 +112,12 @@ function setup_cgroup() {
   mkdir $cgroup_path/$name
 
   echo writing cgroup limit: "$cgroup_limit"
-  echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
+  echo "$cgroup_limit" > \
+	  $cgroup_path/$name/hugetlb.${MB_DISPLAY}${UNIT}.$fault_limit_file
 
   echo writing reservation limit: "$reservation_limit"
   echo "$reservation_limit" > \
-    $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
+    $cgroup_path/$name/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_limit_file
 
   if [ -e "$cgroup_path/$name/cpuset.cpus" ]; then
     echo 0 >$cgroup_path/$name/cpuset.cpus
@@ -142,7 +152,7 @@ function wait_for_file_value() {
 
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "0"
 }
@@ -150,7 +160,7 @@ function wait_for_hugetlb_memory_to_get_
 function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -158,7 +168,7 @@ function wait_for_hugetlb_memory_to_get_
 function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
-  local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
+  local path="$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file"
 
   wait_for_file_value "$path" "$size"
 }
@@ -180,8 +190,8 @@ function write_hugetlbfs_and_get_usage()
   hugetlb_difference=0
   reserved_difference=0
 
-  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file
-  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file
+  local hugetlb_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local reserved_usage=$cgroup_path/$cgroup/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
 
   local hugetlb_before=$(cat $hugetlb_usage)
   local reserved_before=$(cat $reserved_usage)
@@ -312,8 +322,10 @@ function run_test() {
 
   cleanup_hugetlb_memory "hugetlb_cgroup_test"
 
-  local final_hugetlb=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$fault_usage_file)
-  local final_reservation=$(cat $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB}MB.$reservation_usage_file)
+  local final_hugetlb=$(cat \
+	 $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file)
+  local final_reservation=$(cat \
+	  $cgroup_path/hugetlb_cgroup_test/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file)
 
   echo $hugetlb_difference
   echo $reserved_difference
@@ -369,10 +381,14 @@ function run_multiple_cgroup_test() {
   reservation_failed1=$reservation_failed
   oom_killed1=$oom_killed
 
-  local cgroup1_hugetlb_usage=$cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB}MB.$fault_usage_file
-  local cgroup1_reservation_usage=$cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB}MB.$reservation_usage_file
-  local cgroup2_hugetlb_usage=$cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB}MB.$fault_usage_file
-  local cgroup2_reservation_usage=$cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB}MB.$reservation_usage_file
+  local cgroup1_hugetlb_usage=\
+	  $cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local cgroup1_reservation_usage=\
+	  $cgroup_path/hugetlb_cgroup_test1/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
+  local cgroup2_hugetlb_usage=\
+	  $cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB_DISPLAY}${UNIT}.$fault_usage_file
+  local cgroup2_reservation_usage=\
+	  $cgroup_path/hugetlb_cgroup_test2/hugetlb.${MB_DISPLAY}${UNIT}.$reservation_usage_file
 
   local usage_before_second_write=$(cat $cgroup1_hugetlb_usage)
   local reservation_usage_before_second_write=$(cat $cgroup1_reservation_usage)
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

