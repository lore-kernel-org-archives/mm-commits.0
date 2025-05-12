Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F351553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011063; cv=none; b=FIXFHDZEto+ePU9BRyhVn2IAzjeDeTA8k0S+frBoK2H1ebcvqmi9eRP1QqjqPr1JFV+7pt7XkbYmMEsE070t7konzgmbTKcmqm/8uAL/P1sZ9o5CEEaXKCMWHFTrEd3k/4jYhSW+ePNQFluOR2uejftJuNrZf8XEVoPh8VMPBK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011063; c=relaxed/simple;
	bh=MmjFLDLtwnP7UUcR16I10EI+av3Uj946+wSgxvFHxcI=;
	h=Date:To:From:Subject:Message-Id; b=aEG5rvhBIX7Y0TPclSbolQoeoLzRR/u/A3JNijT9Kc8ULdKb4xFDcPwXKa33aUZiUQAxqnr8UPCEZFjwDiVLVKH2u0TTA94tLdr0z13WnBBhibGK/FAoQLG95p6ypQOMcN2P1hD3wHsxNZcNJn5dX+8urSttxho+fvwvxwJblr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bdggW7yF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bdggW7yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6AEC4CEE4;
	Mon, 12 May 2025 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011063;
	bh=MmjFLDLtwnP7UUcR16I10EI+av3Uj946+wSgxvFHxcI=;
	h=Date:To:From:Subject:From;
	b=bdggW7yFNyG8ZXRX910tAujxFpwSo61KmzbIJABe9pTUUJAsxBwkhNKQF7XKCSDTG
	 EeW1r3SNYg/OyWvhOw4rXIxUPIbsqcaKAHfdSg3w5aDf7suen4y27RbHDK2jl9g/ty
	 GMr/IisXk15RsjM3bBQZTB009zz3j9vOeNX8F0X4=
Date: Sun, 11 May 2025 17:51:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,kirill.shutemov@linux.intel.com,donettom@linux.ibm.com,dev.jain@arm.com,anshuman.khandual@arm.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-make-hugetlb_reparenting_test-tolerant-to-async-reparenting.patch removed from -mm tree
Message-Id: <20250512005103.2B6AEC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting
has been removed from the -mm tree.  Its filename was
     selftest-mm-make-hugetlb_reparenting_test-tolerant-to-async-reparenting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting
Date: Mon, 7 Apr 2025 16:42:01 +0800

In cgroup v2, memory and hugetlb usage reparenting is asynchronous.  This
can cause test flakiness when immediately asserting usage after deleting a
child cgroup.  To address this, add a helper function
`assert_with_retry()` that checks usage values with a timeout-based retry.
This improves test stability without relying on fixed sleep delays.

Also bump up the tolerance size to 7MB.

To avoid False Positives:
  ...
  # Assert memory charged correctly for child only use.
  # actual a = 11 MB
  # expected a = 0 MB
  # fail
  # cleanup
  # [FAIL]
  not ok 11 hugetlb_reparenting_test.sh -cgroup-v2 # exit=1
  # 0
  # SUMMARY: PASS=10 SKIP=0 FAIL=1

Link: https://lkml.kernel.org/r/20250407084201.74492-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   96 ++++------
 1 file changed, 41 insertions(+), 55 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftest-mm-make-hugetlb_reparenting_test-tolerant-to-async-reparenting
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -36,7 +36,7 @@ else
     do_umount=1
   fi
 fi
-MNT='/mnt/huge/'
+MNT='/mnt/huge'
 
 function get_machine_hugepage_size() {
   hpz=$(grep -i hugepagesize /proc/meminfo)
@@ -60,6 +60,41 @@ function cleanup() {
   set -e
 }
 
+function assert_with_retry() {
+  local actual_path="$1"
+  local expected="$2"
+  local tolerance=$((7 * 1024 * 1024))
+  local timeout=20
+  local interval=1
+  local start_time
+  local now
+  local elapsed
+  local actual
+
+  start_time=$(date +%s)
+
+  while true; do
+    actual="$(cat "$actual_path")"
+
+    if [[ $actual -ge $(($expected - $tolerance)) ]] &&
+        [[ $actual -le $(($expected + $tolerance)) ]]; then
+      return 0
+    fi
+
+    now=$(date +%s)
+    elapsed=$((now - start_time))
+
+    if [[ $elapsed -ge $timeout ]]; then
+      echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
+      echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      cleanup
+      exit 1
+    fi
+
+    sleep $interval
+  done
+}
+
 function assert_state() {
   local expected_a="$1"
   local expected_a_hugetlb="$2"
@@ -70,58 +105,13 @@ function assert_state() {
     expected_b="$3"
     expected_b_hugetlb="$4"
   fi
-  local tolerance=$((5 * 1024 * 1024))
 
-  local actual_a
-  actual_a="$(cat "$CGROUP_ROOT"/a/memory.$usage_file)"
-  if [[ $actual_a -lt $(($expected_a - $tolerance)) ]] ||
-    [[ $actual_a -gt $(($expected_a + $tolerance)) ]]; then
-    echo actual a = $((${actual_a%% *} / 1024 / 1024)) MB
-    echo expected a = $((${expected_a%% *} / 1024 / 1024)) MB
-    echo fail
-
-    cleanup
-    exit 1
-  fi
-
-  local actual_a_hugetlb
-  actual_a_hugetlb="$(cat "$CGROUP_ROOT"/a/hugetlb.${MB}MB.$usage_file)"
-  if [[ $actual_a_hugetlb -lt $(($expected_a_hugetlb - $tolerance)) ]] ||
-    [[ $actual_a_hugetlb -gt $(($expected_a_hugetlb + $tolerance)) ]]; then
-    echo actual a hugetlb = $((${actual_a_hugetlb%% *} / 1024 / 1024)) MB
-    echo expected a hugetlb = $((${expected_a_hugetlb%% *} / 1024 / 1024)) MB
-    echo fail
-
-    cleanup
-    exit 1
-  fi
-
-  if [[ -z "$expected_b" || -z "$expected_b_hugetlb" ]]; then
-    return
-  fi
-
-  local actual_b
-  actual_b="$(cat "$CGROUP_ROOT"/a/b/memory.$usage_file)"
-  if [[ $actual_b -lt $(($expected_b - $tolerance)) ]] ||
-    [[ $actual_b -gt $(($expected_b + $tolerance)) ]]; then
-    echo actual b = $((${actual_b%% *} / 1024 / 1024)) MB
-    echo expected b = $((${expected_b%% *} / 1024 / 1024)) MB
-    echo fail
-
-    cleanup
-    exit 1
-  fi
-
-  local actual_b_hugetlb
-  actual_b_hugetlb="$(cat "$CGROUP_ROOT"/a/b/hugetlb.${MB}MB.$usage_file)"
-  if [[ $actual_b_hugetlb -lt $(($expected_b_hugetlb - $tolerance)) ]] ||
-    [[ $actual_b_hugetlb -gt $(($expected_b_hugetlb + $tolerance)) ]]; then
-    echo actual b hugetlb = $((${actual_b_hugetlb%% *} / 1024 / 1024)) MB
-    echo expected b hugetlb = $((${expected_b_hugetlb%% *} / 1024 / 1024)) MB
-    echo fail
+  assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
+  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
 
-    cleanup
-    exit 1
+  if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
+    assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
+    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
@@ -175,7 +165,6 @@ size=$((${MB} * 1024 * 1024 * 25)) # 50M
 cleanup
 
 echo
-echo
 echo Test charge, rmdir, uncharge
 setup
 echo mkdir
@@ -195,7 +184,6 @@ cleanup
 
 echo done
 echo
-echo
 if [[ ! $cgroup2 ]]; then
   echo "Test parent and child hugetlb usage"
   setup
@@ -212,7 +200,6 @@ if [[ ! $cgroup2 ]]; then
   assert_state 0 $(($size * 2)) 0 $size
 
   rmdir "$CGROUP_ROOT"/a/b
-  sleep 5
   echo Assert memory reparent correctly.
   assert_state 0 $(($size * 2))
 
@@ -225,7 +212,6 @@ if [[ ! $cgroup2 ]]; then
 fi
 
 echo
-echo
 echo "Test child only hugetlb usage"
 echo setup
 setup
_

Patches currently in -mm which might be from liwang@redhat.com are


