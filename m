Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7403176F0
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325281; cv=none; b=ZLgc1afKJdnWgUFzxg+1PCe60a5bXEsfmY66sfWAuj7Nwy4yIDoEH5XsFkGO6JyEdDTOsYp5qP/44w8aJyUUD7edyDy0ZhE8MTqWW3OWgSWTKq5mND1HaOTNQhRlno/XJnzWiB0A6QA9oSyoQ573+EEq9BNoqxidOQTwDf8TaWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325281; c=relaxed/simple;
	bh=7x6sDlT745XijaOz29fVoC+65BmCMy91wn8yvrGoMNQ=;
	h=Date:To:From:Subject:Message-Id; b=je2vnMJC+GEIYooqIpOn0B3Qlt9yUBASpl6VKD39C3yTSon9BkY66UFCrN3bAoksorXFFSE94pPyq52qgI80I6FR1oTGDMZaZ6Q9hkep+ow+bhbF/rS7k2/zKVsHmVYHzsUu6h7hOMMiirVqNjxjgO1lKO+q+10Ioz9GCCwAUcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N4yy8vhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N4yy8vhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC9BC4CEEF;
	Sat, 16 Aug 2025 06:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325281;
	bh=7x6sDlT745XijaOz29fVoC+65BmCMy91wn8yvrGoMNQ=;
	h=Date:To:From:Subject:From;
	b=N4yy8vhTwF7aYSg3bt4CVZO8d2lqVukSwlQqPb6g2s30BaV+hisJ3t/xbUEawU+ny
	 AOJNO3KW98MaqvyeK7cUt7Ugmt1TKSdRjTu09zToPy5/9nUkFN9a/unspp+hhCFcpi
	 5COX7KbvpU+GMsq1XsQ9CGi6IPapjru3qIV3uLss=
Date: Fri, 15 Aug 2025 23:21:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-introduce-tests-for-disabling-thps-completely.patch added to mm-new branch
Message-Id: <20250816062121.4EC9BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: prctl: introduce tests for disabling THPs completely
has been added to the -mm mm-new branch.  Its filename is
     selftests-prctl-introduce-tests-for-disabling-thps-completely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-introduce-tests-for-disabling-thps-completely.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Usama Arif <usamaarif642@gmail.com>
Subject: selftests: prctl: introduce tests for disabling THPs completely
Date: Fri, 15 Aug 2025 14:54:58 +0100

The test will set the global system THP setting to never, madvise or
always depending on the fixture variant and the 2M setting to inherit
before it starts (and reset to original at teardown).  The fixture setup
will also test if PR_SET_THP_DISABLE prctl call can be made to disable all
THPs and skip if it fails.

This tests if the process can:
- successfully get the policy to disable THPs completely.
- never get a hugepage when the THPs are completely disabled
  with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- never get a THP with MADV_NOHUGEPAGE.
- repeat the above tests in a forked process to make sure
  the policy is carried across forks.

Link: https://lkml.kernel.org/r/20250815135549.130506-7-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore          |    1 
 tools/testing/selftests/mm/Makefile            |    1 
 tools/testing/selftests/mm/prctl_thp_disable.c |  175 +++++++++++++++
 tools/testing/selftests/mm/thp_settings.c      |    9 
 tools/testing/selftests/mm/thp_settings.h      |    1 
 5 files changed, 186 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-prctl-introduce-tests-for-disabling-thps-completely
+++ a/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+prctl_thp_disable
--- a/tools/testing/selftests/mm/Makefile~selftests-prctl-introduce-tests-for-disabling-thps-completely
+++ a/tools/testing/selftests/mm/Makefile
@@ -87,6 +87,7 @@ TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
 TEST_GEN_FILES += process_madv
+TEST_GEN_FILES += prctl_thp_disable
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c a/tools/testing/selftests/mm/prctl_thp_disable.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Basic tests for PR_GET/SET_THP_DISABLE prctl calls
+ *
+ * Author(s): Usama Arif <usamaarif642@gmail.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#include "../kselftest_harness.h"
+#include "thp_settings.h"
+#include "vm_util.h"
+
+enum thp_collapse_type {
+	THP_COLLAPSE_NONE,
+	THP_COLLAPSE_MADV_NOHUGEPAGE,
+	THP_COLLAPSE_MADV_HUGEPAGE,	/* MADV_HUGEPAGE before access */
+	THP_COLLAPSE_MADV_COLLAPSE,	/* MADV_COLLAPSE after access */
+};
+
+/*
+ * Function to mmap a buffer, fault it in, madvise it appropriately (before
+ * page fault for MADV_HUGE, and after for MADV_COLLAPSE), and check if the
+ * mmap region is huge.
+ * Returns:
+ * 0 if test doesn't give hugepage
+ * 1 if test gives a hugepage
+ * -errno if mmap fails
+ */
+static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
+{
+	char *mem, *mmap_mem;
+	size_t mmap_size;
+	int ret;
+
+	/* For alignment purposes, we need twice the THP size. */
+	mmap_size = 2 * pmdsize;
+	mmap_mem = (char *)mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mmap_mem == MAP_FAILED)
+		return -errno;
+
+	/* We need a THP-aligned memory area. */
+	mem = (char *)(((uintptr_t)mmap_mem + pmdsize) & ~(pmdsize - 1));
+
+	if (madvise_buf == THP_COLLAPSE_MADV_HUGEPAGE)
+		madvise(mem, pmdsize, MADV_HUGEPAGE);
+	else if (madvise_buf == THP_COLLAPSE_MADV_NOHUGEPAGE)
+		madvise(mem, pmdsize, MADV_NOHUGEPAGE);
+
+	/* Ensure memory is allocated */
+	memset(mem, 1, pmdsize);
+
+	if (madvise_buf == THP_COLLAPSE_MADV_COLLAPSE)
+		madvise(mem, pmdsize, MADV_COLLAPSE);
+
+	/* HACK: make sure we have a separate VMA that we can check reliably. */
+	mprotect(mem, pmdsize, PROT_READ);
+
+	ret = check_huge_anon(mem, 1, pmdsize);
+	munmap(mmap_mem, mmap_size);
+	return ret;
+}
+
+static void prctl_thp_disable_completely_test(struct __test_metadata *const _metadata,
+					      size_t pmdsize,
+					      enum thp_enabled thp_policy)
+{
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL), 1);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 0);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  thp_policy == THP_ALWAYS ? 1 : 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
+}
+
+FIXTURE(prctl_thp_disable_completely)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_completely)
+{
+	enum thp_enabled thp_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, never)
+{
+	.thp_policy = THP_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, madvise)
+{
+	.thp_policy = THP_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_completely, always)
+{
+	.thp_policy = THP_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_completely)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	if (prctl(PR_SET_THP_DISABLE, 1, NULL, NULL, NULL))
+		SKIP(return, "Unable to disable THPs completely for the process\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = variant->thp_policy;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_completely)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_completely, nofork)
+{
+	prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_completely, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_completely_test(_metadata, self->pmdsize, variant->thp_policy);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
+TEST_HARNESS_MAIN
--- a/tools/testing/selftests/mm/thp_settings.c~selftests-prctl-introduce-tests-for-disabling-thps-completely
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -382,10 +382,17 @@ unsigned long thp_shmem_supported_orders
 	return __thp_supported_orders(true);
 }
 
-bool thp_is_enabled(void)
+bool thp_available(void)
 {
 	if (access(THP_SYSFS, F_OK) != 0)
 		return false;
+	return true;
+}
+
+bool thp_is_enabled(void)
+{
+	if (!thp_available())
+		return false;
 
 	int mode = thp_read_string("enabled", thp_enabled_strings);
 
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-prctl-introduce-tests-for-disabling-thps-completely
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -84,6 +84,7 @@ void thp_set_read_ahead_path(char *path)
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+bool thp_available(void);
 bool thp_is_enabled(void);
 
 #endif /* __THP_SETTINGS_H__ */
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

