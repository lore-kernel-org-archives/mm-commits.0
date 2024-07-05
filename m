Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0EBC2E9
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141641; cv=none; b=iGSGto/LcpkHOz2Sit2t0Ikeiy/QFZfjBgY/KH7yFYe3mEPDI3MH8v96d2dTA7N5hZAQUjgPzTtUSBeUEwja9uJga8A/ImXT/0Tdapqh9utj3P7Qh+ECNHzWscYx5Hr7jfEE27rshUt58xD+PvyrcbOrcLguLhG+gNaAKdYd9nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141641; c=relaxed/simple;
	bh=TUytB5m96qvAEF0a8FqkkdBHlISv3zEdZC2U9AOm0LI=;
	h=Date:To:From:Subject:Message-Id; b=fgX3dhIfeisVeLSI7E8yTi2pW0/53gZ3pOsoTDvbXnfn/OZ1IoPhIcH/nlHx9W84nqOP2Sd2vQs7CZBb6OEvaKKmHALPxMiVl78Ia2PN+sQeAPZAQGZSksqSJZJf375kc+NLpqiatNpkhs0Bt87dUGuQ1C5fUa9O9d9KSzvpbUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZXll3wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZXll3wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E23C3277B;
	Fri,  5 Jul 2024 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141641;
	bh=TUytB5m96qvAEF0a8FqkkdBHlISv3zEdZC2U9AOm0LI=;
	h=Date:To:From:Subject:From;
	b=mZXll3wqkwlPwKAfdO62az0YJ0/XshYoXxEOhgL0Y3COYU1fRX4tFlaSc7o0FWWol
	 eAqq81ziQ0F8G6LDWsDQNkfHosOYb4FQzF7NknnyYUSNWqULkQfWEv8qnb7N36bUaw
	 ps0bIWSSeGb1s5msn4rqaUmS6VnE/d1VyfZulWMI=
Date: Thu, 04 Jul 2024 18:07:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-test-enable_soft_offline-behaviors.patch removed from -mm tree
Message-Id: <20240705010721.60E23C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: test enable_soft_offline behaviors
has been removed from the -mm tree.  Its filename was
     selftest-mm-test-enable_soft_offline-behaviors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: selftest/mm: test enable_soft_offline behaviors
Date: Wed, 26 Jun 2024 05:08:17 +0000

Add regression and new tests when hugepage has correctable memory errors,
and how userspace wants to deal with it:

* if enable_soft_offline=1, mapped hugepage is soft offlined
* if enable_soft_offline=0, mapped hugepage is intact

Free hugepages case is not explicitly covered by the tests.

Hugepage having corrected memory errors is emulated with
MADV_SOFT_OFFLINE.

[jiaqiyan@google.com: v7]
  Link: https://lkml.kernel.org/r/20240628205958.2845610-4-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20240626050818.2277273-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore             |    1 
 tools/testing/selftests/mm/Makefile               |    1 
 tools/testing/selftests/mm/hugetlb-soft-offline.c |  228 ++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh         |    6 
 4 files changed, 236 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftest-mm-test-enable_soft_offline-behaviors
+++ a/tools/testing/selftests/mm/.gitignore
@@ -6,6 +6,7 @@ hugepage-shm
 hugepage-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
+hugetlb-soft-offline
 khugepaged
 map_hugetlb
 map_populate
--- /dev/null
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test soft offline behavior for HugeTLB pages:
+ * - if enable_soft_offline = 0, hugepages should stay intact and soft
+ *   offlining failed with EOPNOTSUPP.
+ * - if enable_soft_offline = 1, a hugepage should be dissolved and
+ *   nr_hugepages/free_hugepages should be reduced by 1.
+ *
+ * Before running, make sure more than 2 hugepages of default_hugepagesz
+ * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
+ *   echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <linux/magic.h>
+#include <linux/memfd.h>
+#include <sys/mman.h>
+#include <sys/statfs.h>
+#include <sys/types.h>
+
+#include "../kselftest.h"
+
+#ifndef MADV_SOFT_OFFLINE
+#define MADV_SOFT_OFFLINE 101
+#endif
+
+#define EPREFIX " !!! "
+
+static int do_soft_offline(int fd, size_t len, int expect_errno)
+{
+	char *filemap = NULL;
+	char *hwp_addr = NULL;
+	const unsigned long pagesize = getpagesize();
+	int ret = 0;
+
+	if (ftruncate(fd, len) < 0) {
+		ksft_perror(EPREFIX "ftruncate to len failed");
+		return -1;
+	}
+
+	filemap = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_POPULATE, fd, 0);
+	if (filemap == MAP_FAILED) {
+		ksft_perror(EPREFIX "mmap failed");
+		ret = -1;
+		goto untruncate;
+	}
+
+	memset(filemap, 0xab, len);
+	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
+
+	hwp_addr = filemap + len / 2;
+	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
+	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
+		       hwp_addr, ret, errno);
+	if (ret != 0)
+		ksft_perror(EPREFIX "madvise failed");
+
+	if (errno == expect_errno)
+		ret = 0;
+	else {
+		ksft_print_msg("MADV_SOFT_OFFLINE should ret %d\n",
+			       expect_errno);
+		ret = -1;
+	}
+
+	munmap(filemap, len);
+untruncate:
+	if (ftruncate(fd, 0) < 0)
+		ksft_perror(EPREFIX "ftruncate back to 0 failed");
+
+	return ret;
+}
+
+static int set_enable_soft_offline(int value)
+{
+	char cmd[256] = {0};
+	FILE *cmdfile = NULL;
+
+	if (value != 0 && value != 1)
+		return -EINVAL;
+
+	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
+	cmdfile = popen(cmd, "r");
+
+	if (cmdfile)
+		ksft_print_msg("enable_soft_offline => %d\n", value);
+	else {
+		ksft_perror(EPREFIX "failed to set enable_soft_offline");
+		return errno;
+	}
+
+	pclose(cmdfile);
+	return 0;
+}
+
+static int read_nr_hugepages(unsigned long hugepage_size,
+			     unsigned long *nr_hugepages)
+{
+	char buffer[256] = {0};
+	char cmd[256] = {0};
+
+	sprintf(cmd, "cat /sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages",
+		hugepage_size);
+	FILE *cmdfile = popen(cmd, "r");
+
+	if (cmdfile == NULL) {
+		ksft_perror(EPREFIX "failed to popen nr_hugepages");
+		return -1;
+	}
+
+	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
+		ksft_perror(EPREFIX "failed to read nr_hugepages");
+		pclose(cmdfile);
+		return -1;
+	}
+
+	*nr_hugepages = atoll(buffer);
+	pclose(cmdfile);
+	return 0;
+}
+
+static int create_hugetlbfs_file(struct statfs *file_stat)
+{
+	int fd;
+
+	fd = memfd_create("hugetlb_tmp", MFD_HUGETLB);
+	if (fd < 0) {
+		ksft_perror(EPREFIX "could not open hugetlbfs file");
+		return -1;
+	}
+
+	memset(file_stat, 0, sizeof(*file_stat));
+	if (fstatfs(fd, file_stat)) {
+		ksft_perror(EPREFIX "fstatfs failed");
+		goto close;
+	}
+	if (file_stat->f_type != HUGETLBFS_MAGIC) {
+		ksft_print_msg(EPREFIX "not hugetlbfs file\n");
+		goto close;
+	}
+
+	return fd;
+close:
+	close(fd);
+	return -1;
+}
+
+static void test_soft_offline_common(int enable_soft_offline)
+{
+	int fd;
+	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
+	struct statfs file_stat;
+	unsigned long hugepagesize_kb = 0;
+	unsigned long nr_hugepages_before = 0;
+	unsigned long nr_hugepages_after = 0;
+	int ret;
+
+	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
+		       enable_soft_offline);
+
+	fd = create_hugetlbfs_file(&file_stat);
+	if (fd < 0)
+		ksft_exit_fail_msg("Failed to create hugetlbfs file\n");
+
+	hugepagesize_kb = file_stat.f_bsize / 1024;
+	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
+
+	if (set_enable_soft_offline(enable_soft_offline) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
+	}
+
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+	}
+
+	ksft_print_msg("Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
+		       nr_hugepages_before);
+
+	ret = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_errno);
+
+	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
+		close(fd);
+		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
+	}
+
+	ksft_print_msg("After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
+		nr_hugepages_after);
+
+	// No need for the hugetlbfs file from now on.
+	close(fd);
+
+	if (enable_soft_offline) {
+		if (nr_hugepages_before != nr_hugepages_after + 1) {
+			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
+			return;
+		}
+	} else {
+		if (nr_hugepages_before != nr_hugepages_after) {
+			ksft_test_result_fail("MADV_SOFT_OFFLINE reduced %lu hugepages\n",
+				nr_hugepages_before - nr_hugepages_after);
+			return;
+		}
+	}
+
+	ksft_test_result(ret == 0,
+			 "Test soft-offline when enabled_soft_offline=%d\n",
+			 enable_soft_offline);
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(2);
+
+	test_soft_offline_common(1);
+	test_soft_offline_common(0);
+
+	ksft_finished();
+}
--- a/tools/testing/selftests/mm/Makefile~selftest-mm-test-enable_soft_offline-behaviors
+++ a/tools/testing/selftests/mm/Makefile
@@ -43,6 +43,7 @@ TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-read-hwpoison
+TEST_GEN_FILES += hugetlb-soft-offline
 TEST_GEN_FILES += hugepage-mmap
 TEST_GEN_FILES += hugepage-mremap
 TEST_GEN_FILES += hugepage-shm
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftest-mm-test-enable_soft_offline-behaviors
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -332,6 +332,12 @@ CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
 if $RUN_DESTRUCTIVE; then
+nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
+enable_soft_offline=$(cat /proc/sys/vm/enable_soft_offline)
+echo 8 > /proc/sys/vm/nr_hugepages
+CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
+echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
+echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are


