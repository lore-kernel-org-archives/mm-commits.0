Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1F3296BC8
	for <mm-commits@vger.kernel.org>; Fri, 26 Jun 2026 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492029; cv=none; b=PRPYQkt7PPJUc6Sjfem5xN0CoYiDWe/M6HiitZB78IKV8XnltdLA402hTpSmf7/0z3pQnMnb1rV13jqgrXpjyg8TsKOHGm1MlXQrqlD3KRht08nhm7+VZFSeJ9b1FDZhJRMO8zOPnyBeSGRuJF0ISyzDTHCpnLrsAscbIY43KLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492029; c=relaxed/simple;
	bh=zSidRh4LfJaKze4l9l78z4pkpiDH8ad+3rSwlWoxkdU=;
	h=Date:To:From:Subject:Message-Id; b=HHvTdsOTlfG8/HuiptMwPdGX376y4Glru9RhtxiyWRCCpIqitppbPba19t4eQNkjIYaTfKp9PaqNykuBdDc+HhkxsyE+dqiFZ3LOZ1rkW23bexS5js5kkFVFkXoL+o9kX250uMER5VcCHiKYajQVCW0lZn0/kyVJa1TelHQi39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P8H3o9J2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P8H3o9J2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009B01F000E9;
	Fri, 26 Jun 2026 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782492028;
	bh=hbc9xgR6bwRYAFKcKnXODEdLd+2wXFvH+1jpWgGWe1w=;
	h=Date:To:From:Subject;
	b=P8H3o9J2k5OyfRV97koHDyITrG4cUHtjfFEW0VgPBdHi4MnAvpfNBt3/qqj/DVDfO
	 m7fR9znYnjEtv5w7GJ6mHRNuO30yhVY61QCVX6Nwn4Fw95500g14+pa5a6aP7qmvKw
	 hqATTEVAllODaWOx9Dp3uXxob2DeK3se3zG8oc0o=
Date: Fri, 26 Jun 2026 09:40:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch removed from -mm tree
Message-Id: <20260626164028.009B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: handle EINVAL when configuring gigantic hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Thu, 25 Jun 2026 18:10:16 +0530

Patch series "selftests/mm: avoid false failures in hugetlb and KSM tests".

This series fixes issues in the hugetlb and KSM MM selftest categories
that can report failures when the prerequisites for the tests are not
satisfied.

Patch 1 updates the hugetlb selftest helpers to handle -EINVAL when
attempting to configure gigantic HugeTLB pages via nr_hugepages.  PowerPC
hash MMU pSeries systems expose gigantic hugepage sizes but do not allow
runtime allocation of such pages, causing the sysfs write to fail.  Handle
this case gracefully and continue running the test instead of aborting.

Patch 2 fixes the KSM NUMA merge test on systems with memoryless NUMA
nodes.  The test currently relies on the number of configured NUMA nodes
and may attempt allocations on nodes that have no memory, resulting in
spurious failures.  Count only NUMA nodes that contain memory and skip the
test when fewer than two such nodes are available.

These changes improve handling of unsupported test configurations and
unmet test prerequisites, avoiding spurious failures.


This patch (of 2):

Some MM selftests attempt to configure the amount of HugeTLB pages of
different sizes by writing to nr_hugepages.

PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes but do
not support runtime allocation of such pages, writes to the corresponding
nr_hugepages file fail with -EINVAL.  This causes the test to bail out
even though the failure is due to a platform limitation rather than the
functionality being tested.

Treat -EINVAL from the sysfs write as a skipped configuration request and
continue running the test instead of failing.

Before patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
     [INFO] detected hugetlb page size: 16777216 KiB
     [INFO] detected hugetlb page size: 16384 KiB
    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
    write(0) failed: Invalid argument
    Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
    [FAIL]

After patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
    [INFO] detected hugetlb page size: 16777216 KiB
    [INFO] detected hugetlb page size: 16384 KiB
   ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
   /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
   write(0) failed: Invalid argument
   [PASS]

Link: https://lore.kernel.org/cover.1782365671.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/8bfa921e30eb94072685103f6496784aa23bb166.1782365671.git.sayalip@linux.ibm.com
Fixes: 9d07250ea1eb ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-handle-einval-when-configuring-gigantic-hugepages
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -735,6 +735,13 @@ void write_file(const char *path, const
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
+
+	if (numwritten < 0 && errno == EINVAL) {
+		ksft_print_msg("%s write(%.*s) failed: %s\n", path,
+			       (int)(buflen - 1), buf, strerror(errno));
+		return;
+	}
+
 	if (numwritten < 0)
 		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
 				buf, strerror(errno));
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch

