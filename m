Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A571D3BF68D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896696; cv=none; b=LXZq9nzLHuFO4m9k1tE4AwF+7gWMvRG4n3KSDI2dW6SR0aaICHc/FLYjHSkc15oTw2SyltMB/P9InVkh4w466h0U7Bt+skTbxQzPEwCyrUlp4+5ga9yR9AmdJeUAr2d1dX7agc1NHiQOsq5psOQ6Ddj5ClKkRn8A8PaGJTNiBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896696; c=relaxed/simple;
	bh=lLlU1gfsoijszN5OEhnVcEGPXzTz5tTQPm+ltDk1lVE=;
	h=Date:To:From:Subject:Message-Id; b=c90QInvdgQzTDJQkxjwVd3Pf4vAPmgXzTOW5k7DV0DKV5v/Wy3QLpYOCq410VenUu2y5/43iL9NiCReybn+/OYdrS6tbWUrabEsJPLm4DpXlZM0pHMQN2dFWvY98nVSMravXz4Jj+Twvxn0camtsnwLROu4BC2LF2yW7fvP/K3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YvHjuDVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YvHjuDVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95811F00A3A;
	Wed,  5 Aug 2026 02:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896693;
	bh=ihmm3RkETfIcOouz4QLuMb9vbpTAg6Jd6Dlpse5nDrs=;
	h=Date:To:From:Subject;
	b=YvHjuDVlMRLj1ulVhNJgQn70pHxx4VfR7sr1eLE4ZR9U+Sq/o6HzU/q0cC6amJB+F
	 z1wLi/AeZ8NEcnFdT8zGZrzdUSWVBF2S4QhRCrSLWqduJfL4l8mXz99N0EfnkJnn9z
	 hLSOLwCjakzRPj4369Uiue6TR+55JvAJu4B/tYbI=
Date: Tue, 04 Aug 2026 19:24:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam@infradead.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch removed from -mm tree
Message-Id: <20260805022453.C95811F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: handle EINVAL when configuring gigantic hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Wed, 8 Jul 2026 12:29:05 +0530

Patch series "selftests/mm: avoid false failures in hugetlb and KSM
tests", v3.

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
spurious failures.  Use the existing helpers to identify NUMA nodes that
contain memory and skip the test when fewer than two such nodes are
available.

Patch 3 fixes a pre-existing operator precedence issue in ksm_tests, where
a ternary expression combined with logical OR operators could be evaluated
differently than intended.  Added parentheses to ensure the correct
evaluation order.

These changes improve handling of unsupported test configurations and
unmet test prerequisites, avoiding spurious failures.


This patch (of 3):

Some MM selftests attempt to configure the amount of HugeTLB pages of
different sizes by writing to nr_hugepages.

PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes but do
not support runtime allocation of such pages, writes to the corresponding
nr_hugepages file fail with -EINVAL.  This causes the test to bail out
even though the failure is due to a platform limitation rather than the
functionality being tested.

Ignore -EINVAL when configuring nr_hugepages so that tests continue to run
on systems where gigantic hugepage allocation is unsupported.

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
   [PASS]

Link: https://lore.kernel.org/cover.1783446924.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com
Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugepage_settings.c |    2 -
 tools/testing/selftests/mm/vm_util.c           |   26 ++++++++++++---
 tools/testing/selftests/mm/vm_util.h           |    1 
 3 files changed, 24 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/hugepage_settings.c~selftests-mm-handle-einval-when-configuring-gigantic-hugepages
+++ a/tools/testing/selftests/mm/hugepage_settings.c
@@ -437,7 +437,7 @@ void hugetlb_set_nr_pages(unsigned long
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	write_num(path, nr);
+	write_num_ignore_einval(path, nr);
 }
 
 unsigned long hugetlb_free_pages(unsigned long size)
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-handle-einval-when-configuring-gigantic-hugepages
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -719,7 +719,7 @@ int read_file(const char *path, char *bu
 	return (unsigned int) numread;
 }
 
-void write_file(const char *path, const char *buf, size_t buflen)
+static void __write_file(const char *path, const char *buf, size_t buflen, bool ignore_einval)
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
@@ -735,14 +735,22 @@ void write_file(const char *path, const
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
-	if (numwritten < 0)
+	if (numwritten < 0) {
+		if (ignore_einval && errno == EINVAL)
+			return;
 		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
 				buf, strerror(errno));
+	}
 	if (numwritten != buflen - 1)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
 
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	__write_file(path, buf, buflen, /* ignore_einval = */ false);
+}
+
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -753,12 +761,22 @@ unsigned long read_num(const char *path)
 	return strtoul(buf, NULL, 10);
 }
 
-void write_num(const char *path, unsigned long num)
+static void __write_num(const char *path, unsigned long num, bool ignore_einval)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
+	__write_file(path, buf, strlen(buf) + 1, ignore_einval);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ false);
+}
+
+void write_num_ignore_einval(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ true);
 }
 
 static unsigned long shmall, shmmax;
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-handle-einval-when-configuring-gigantic-hugepages
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -168,6 +168,7 @@ void write_file(const char *path, const
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+void write_num_ignore_einval(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


