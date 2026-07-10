Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326FD126C03
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 01:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783648408; cv=none; b=tIz/qdfGtm73Bx5w8IrrfgsyHv0YI30R+2uAgNctFn8rqtiUjjs5HoslFSG46I9P2E/r78B/zqhyJNv2UvKjZMN7M1o7hd5CvItC+TkQzHbXH4sWl5rWwvfGR7TfgrRAN9eKb97cPln/2v0llcpCwdnreHft3Xf1gd5o+BSCs/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783648408; c=relaxed/simple;
	bh=kDh53wwFQ/fhwgU0BRsjesWFzZLJQfferi2+S+D8B+U=;
	h=Date:To:From:Subject:Message-Id; b=gWB+UQgEi7YLpFsAqc7o4GeodbS6xSgbrLtSycjQdeDQp9LECMXBwxY0krTreHUqg+tYDQRZwbu/RkLrBjDr4jlRD3Lywk6usyGu0N/Kv+XsMdixOW4oL6nY6J+3shYa2tHql0Qr0crV1Z8tcFmlGSrs5DitUcw3FZBRWJbGvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YjBbzXbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YjBbzXbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55301F000E9;
	Fri, 10 Jul 2026 01:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783648406;
	bh=GJNqxACr8DojoXTu52PDkr7XxaD7FXOOqF8BIKBs9cU=;
	h=Date:To:From:Subject;
	b=YjBbzXbgfxWmJjC4TDcXSjzpxCagiyuqOGXMgfo3jJZiMceoinRjqQfGwfT/NOCfu
	 ZydYwWRNlov3DFEjZviHbKD5kjjTgmd3LSs9uuDEXkyQ2jda2WEquK4fGKFFrXWc7W
	 ZxdSu43Bod2Z3ZgBOUPHOXiHBIGKQxsMGcPxiu1w=
Date: Thu, 09 Jul 2026 18:53:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch added to mm-new branch
Message-Id: <20260710015326.B55301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: handle EINVAL when configuring gigantic hugepages
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch

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
Cc: Liam Howlett <liam.howlett@oracle.com>
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

selftests-mm-handle-einval-when-configuring-gigantic-hugepages.patch
selftests-mm-fix-ksm-numa-merge-test-for-systems-with-memoryless-numa-nodes.patch
selftests-mm-fix-ternary-operator-precedence-in-ksm_tests.patch

