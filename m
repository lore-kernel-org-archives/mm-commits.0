Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15A33CEA2
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400510; cv=none; b=OEJ5lF8raQtFDzP56A2uHtsZ5Ttb+4Wlsivdh7bybTtM2Ki0KhFXHr/z+lkA9GDCv7sTS8MPiD3fWbqdLUtM0uJ1hyxVxnXFAgbjdfI32WzMvkRPMERrmXtWCMRRCYmtqTLmiYlssU128IwFcA4/eTQdugcEGqbZ1zC5XM1SqQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400510; c=relaxed/simple;
	bh=ehxgPBA8XSlvcy4DNh1TN+3kO0tJo9waAFkfIg4euTo=;
	h=Date:To:From:Subject:Message-Id; b=ckv5B39NHTUPieP/2S/LlZuZC2layJMCORCiVrO4J6w8uS1vM8c8LX32QlAObiT9miPsX8ijiX5mewIryUzB742GRDRPMbSsL71V3kV8K+yWG5UaJsLTI4vxeNReRYMf7AyHXn1J+bI/NChhwClZFgz4/pjw97U91H3Hd4oCJls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e2PmMWCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e2PmMWCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396A01F000E9;
	Thu, 21 May 2026 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400509;
	bh=1VAOwimn7wa04PvcPzf2xcA899gtDbLs2Oqr2TkjOFc=;
	h=Date:To:From:Subject;
	b=e2PmMWCytYi3PwRlagxeYVE81DQbNPbjaSOujOiLcN6bTWx+Zj7PfqIaZOCo+5YcY
	 WNR9jrFl6AJP1eQpWEmOMFBSwYeRBNP+2Mrv3LdCu1pbOk4mH1zE4i0XP6koyC7mxA
	 PN031OOvc2n6XdZOeivphzHbXzVL9D6VRyQ39DBo=
Date: Thu, 21 May 2026 14:55:08 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch added to mm-new branch
Message-Id: <20260521215509.396A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch

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
Subject: selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
Date: Thu, 21 May 2026 12:03:27 +0530

Patch series "selftests/mm: fix failures and robustness improvements", v7.

Powerpc systems with a 64K base page size exposed several issues while
running mm selftests. Some tests assume specific hugetlb configurations,
use incorrect interfaces, or fail instead of skipping when the required
kernel features are not available.

This series fixes these issues and improves test robustness.


This patch (of 13):

cleanup() resets nr_hugepages to 0 on every invocation, while the test
reconfigures it again in the next iteration.  This leads to repeated
allocation and freeing of large numbers of hugepages, especially when the
original value is high.

Additionally, with set -e, failures in earlier cleanup steps (e.g., rmdir
or umount returning EBUSY while background activity is still ongoing) can
cause the script to exit before restoring the original value, leaving the
system in a modified state.

Introduce a trap on EXIT, INT, and TERM to restore the original
nr_hugepages value once at script termination.  This avoids unnecessary
allocation churn and ensures the original value is reliably restored on
all exit paths.

Link: https://lore.kernel.org/cover.1779296493.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/5b8fbb29cd6ceffe6752e0af104f60cec072aa10.1779296493.git.sayalip@linux.ibm.com
Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -17,6 +17,7 @@ if ! command -v killall >/dev/null 2>&1;
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -70,7 +71,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -599,4 +599,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
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

