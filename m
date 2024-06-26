Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1562819
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719433992; cv=none; b=DdFVdZVIxMTjxk470jRVe68AikhPTcbi1OTnRg4qhh0+Jyvtfm/kfp0gA/JuNQ4ncqhzRkQd7mDYYdxuTx+Td/sMD6n0x0pvyy7RH2EQ3FBnOWd3c7aSRJEqXlhUGPFu832cJSxiMm6iAaWs1RgEigxDWKQE6jEspmzm9pz72U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719433992; c=relaxed/simple;
	bh=K9WPiRAsbx/W3vkgRAkFJD9zmqyC17n2cFmywV+EaH0=;
	h=Date:To:From:Subject:Message-Id; b=SuG7PD0soG87cRHF41tSzpnCU5ByKCR2eL4wEmfl/Vf/gR9B42asu7pQn0hIURaDGsPR60gzGcHi+Ym9DHsNNNrS8ZiDAoiU1ukz6Lerpqqw+xt3FpymYnpqA1/RlC2fNx7fG1P8cTfCFOqaF1jeFGS+QmuAQmxIRWkIxcBiwpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aGK1ZTd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aGK1ZTd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AA7C116B1;
	Wed, 26 Jun 2024 20:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719433992;
	bh=K9WPiRAsbx/W3vkgRAkFJD9zmqyC17n2cFmywV+EaH0=;
	h=Date:To:From:Subject:From;
	b=aGK1ZTd+34YKNOuVglfv0aQM65vgs6g21GURDUesTPIRddMYt/Ztd7KPfect30/V8
	 NY2666qiiXIs7Z+v14jRc83TvKZcwZcmkCHldhRrA9xwtbf0Pt5gd4T2ISb+RzMfDG
	 X50MA+CIRGGKEqIAlEqh9yN1UQngioaB2txp6BJ0=
Date: Wed, 26 Jun 2024 13:33:11 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,rdunlap@infradead.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,fvdl@google.com,corbet@lwn.net,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-test-enable_soft_offline-behaviors.patch added to mm-unstable branch
Message-Id: <20240626203312.79AA7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: test enable_soft_offline behaviors
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-test-enable_soft_offline-behaviors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-test-enable_soft_offline-behaviors.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: selftest/mm: test enable_soft_offline behaviors
Date: Wed, 26 Jun 2024 05:08:17 +0000

Add regression and new tests when hugepage has correctable memory
errors, and how userspace wants to deal with it:
* if enable_soft_offline=1, mapped hugepage is soft offlined
* if enable_soft_offline=0, mapped hugepage is intact

Free hugepages case is not explicitly covered by the tests.

Hugepage having corrected memory errors is emulated with
MADV_SOFT_OFFLINE.

Link: https://lkml.kernel.org/r/20240626050818.2277273-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
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
 tools/testing/selftests/mm/run_vmtests.sh         |    4 
 4 files changed, 234 insertions(+)

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
+	if (set_enable_soft_offline(enable_soft_offline)) {
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
@@ -332,6 +332,10 @@ CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
 if $RUN_DESTRUCTIVE; then
+nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
+echo 8 > /proc/sys/vm/nr_hugepages
+CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
+echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-refactor-log-format-in-unpoison_memory.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code.patch
mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch

