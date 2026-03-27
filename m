Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92623FEB27
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634346; cv=none; b=bEjj7kC+3pb6RVZbmF6929bbMQlLb5nGTPlDzNVJ51cnh5Cei+8LgeVoFuNw1pNzkgTGI1Wv9/0r3sMudTUqRoBY0UawPpp+22OzWODsDxZSMASL2dysqRqcKKtOhm+BugeOONaKKESn+AUKMs4+twU2KiZka9+WI/0eezFSaQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634346; c=relaxed/simple;
	bh=KOkMqghKy5GB18a2IKIfJpqNA22p/WCnaCx7zGKi3aE=;
	h=Date:To:From:Subject:Message-Id; b=rdWf/A33mVQPcpeO9OJotPgdWV06v0Iq05NHPaKzk7KbABIopbtmPmi1UcnAX7AaKlfWdoZXozgjaMcQqQ86PLlK8VzBVQIUH07rxPf7pvtjEA4HvHbLs8H8vetFYB0JA1uz02/h08DCIt1XLSvz5c8+oP4G5Gs1If1H6UqN1J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GdxEbG3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GdxEbG3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722EEC19423;
	Fri, 27 Mar 2026 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634345;
	bh=KOkMqghKy5GB18a2IKIfJpqNA22p/WCnaCx7zGKi3aE=;
	h=Date:To:From:Subject:From;
	b=GdxEbG3ZGqb18rQ/AveBFd8I7ZGNcWxlpE5n8my+WsKjI6UL0VW1LcJhVRteqW62I
	 L5UZY4UPfmlLfMjHiWArNaNuQgYOBFRb7h9TW+5ZiPhL1G8OoHC82qy/GxyfWxMmBY
	 Hc/nhBEzbfKky5gb62rq7qn5qX/W0YpKakBVwv/o=
Date: Fri, 27 Mar 2026 10:59:04 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch removed from -mm tree
Message-Id: <20260327175905.722EEC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Thu, 12 Mar 2026 17:55:30 +0530

The hugetlb_reparenting_test.sh script constructs hugetlb cgroup memory
interface file names based on the configured huge page size.  The script
formats the size only in MB units, which causes mismatches on systems
using larger huge pages where the kernel exposes normalized units (e.g. 
"1GB" instead of "1024MB").

As a result, the test fails to locate the corresponding cgroup files when
1GB huge pages are configured.

Update the script to detect the huge page size and select the appropriate
unit (MB or GB) so that the constructed paths match the kernel's hugetlb
controller naming.

Also print an explicit "Fail" message when a test failure occurs to
improve result visibility.

Link: https://lkml.kernel.org/r/3ab5781190ea0a6bffda2683b2ca221e0c7f6280.1773305677.git.sayalip@linux.ibm.com
Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   14 ++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -46,6 +46,13 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+  UNIT="GB"
+  MB_DISPLAY=$((MB / 1024))
+else
+  UNIT="MB"
+  MB_DISPLAY=$MB
+fi
 
 function cleanup() {
   echo cleanup
@@ -87,6 +94,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -107,11 +115,13 @@ function assert_state() {
   fi
 
   assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
-  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
+  assert_with_retry \
+	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
   if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
     assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
-    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
+    assert_with_retry \
+	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
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

