Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E3B36F908
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067198; cv=none; b=jw3yaegT8Y38APWCc7KtHGh3OyzAext0SmCP9eV3fGNfMOjDNm1981By8JXTkkfXAGHMAsRi63tF612Yi49tELzb4GIpqY1nS19SyZNQBs+33vExjZSnC09Ebo1AZZyrYhxYF3Yg2S+L+X8cydC1k0mv/ZHolZTpjZi9q8IQcWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067198; c=relaxed/simple;
	bh=hvaGiMwN2BtdtDwSR/OLbIHizKX8v24wT1ajSyA+QSY=;
	h=Date:To:From:Subject:Message-Id; b=kPkU9gZtTF5I3r+C/uspbFeeKLqJ84XaDBE0/JAmX2GZY53YXfFa+JbvJz45KrtXn+ACH/3dA8mto4RJCnM9zb8QoWWk2W7AmtraOm/X1hrkMnkeIIHyOYGxiyon6msY7b5td7jkOFOcOUIH2rKegORFpoj5KICu3co4Hy6Vs9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KV3+FqkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KV3+FqkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31711F00A3A;
	Sun, 21 Jun 2026 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067196;
	bh=7qzrd0I6x/rA90w21ReTBnA8ZwUgBgt5djUDK6FKK8g=;
	h=Date:To:From:Subject;
	b=KV3+FqkNWbKE9Z0qnyF2fqZbb1xgVl9C/uKRM2yf5Tgw3ub2AjI1sorBVfALilary
	 +DoGUNGmhlpGVt1DoT0QC7JgxHwRZKOm3Ddu65T/t8UQDalViLTuRcZqVSrIKis1h2
	 De11ImmiTxcFbvKiyhoiftD1DgXXKg+Tzb0pWCws=
Date: Sun, 21 Jun 2026 11:39:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch removed from -mm tree
Message-Id: <20260621183956.B31711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Thu, 21 May 2026 12:17:44 +0530

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

Link: https://lore.kernel.org/837ce751965c93f74c95d89587debf1e93281364.1779296493.git.sayalip@linux.ibm.com
Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
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

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |   14 ++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-fix-hugetlb-pathname-construction-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -48,6 +48,13 @@ function get_machine_hugepage_size() {
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
@@ -88,6 +95,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -108,11 +116,13 @@ function assert_state() {
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


