Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4553420E033
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755325286; cv=none; b=sFro2lzpPL/iwOzKo4tNCsMxW+H2HgTFK03qg/U4YAakm4rrjPrIbZ9mGJFyiNE5ccbzm11Rpg+ao5pQsTBsiu6RE9dDmbV0FTgYfC2uTFsc2y7zjXNUj+G70b0DR72CszGji4CMFbupvjr1KABB67Yjv3UpxzzcM/kPrqt+lrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755325286; c=relaxed/simple;
	bh=xPJ0fgXRUlfITxx5WRE0kqCQNvol+19RQzVsu+22Ar8=;
	h=Date:To:From:Subject:Message-Id; b=cLR5bLxPY9jq8JC4tassgH7vKDnlHy/sQiPHRX1uhHcnPrUkFJjG7rln2U5u6QMH1X2fT74eh5so/M8BWy7MAMaSsduF7zBG5lKCRneT5Mk3xLc39nQ+gtzzSEEf9mChXhPS2nkSmYXadcldE4AlcDk7/EwVpFZxtP/SvQCrW6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIJreNWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIJreNWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0D7C4CEEF;
	Sat, 16 Aug 2025 06:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755325285;
	bh=xPJ0fgXRUlfITxx5WRE0kqCQNvol+19RQzVsu+22Ar8=;
	h=Date:To:From:Subject:From;
	b=cIJreNWGrkLV+bdXnK/bVnzi7aEqsFU23JUD1vQXAHgS5SWgq5H1hPafUbkHjQ/Uy
	 tC+YWfx6RxP92+0RmhpqyrXWZBe/mUjvZoFCAwATkKxBO+sspGBSwylq1yaIMhK0Ha
	 IKYQxQs7jCLvZSGX41T+VSiaveMaCUoEPkUXlnfA=
Date: Fri, 15 Aug 2025 23:21:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,laoar.shao@gmail.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch added to mm-new branch
Message-Id: <20250816062125.CB0D7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: prctl: introduce tests for disabling THPs except for madvise
has been added to the -mm mm-new branch.  Its filename is
     selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

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
Subject: selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Fri, 15 Aug 2025 14:54:59 +0100

The test will set the global system THP setting to never, madvise or
always depending on the fixture variant and the 2M setting to inherit
before it starts (and reset to original at teardown).  The fixture setup
will also test if PR_SET_THP_DISABLE prctl call can be made with
PR_THP_DISABLE_EXCEPT_ADVISED and skip if it fails.

This tests if the process can:
- successfully get the policy to disable THPs expect for madvise.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
  is madvise/always and only with MADV_COLLAPSE if the global policy is
  never.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- never get a THP with MADV_NOHUGEPAGE.
- repeat the above tests in a forked process to make sure  the policy is
  carried across forks.

Test results:
./prctl_thp_disable
TAP version 13
1..12
ok 1 prctl_thp_disable_completely.never.nofork
ok 2 prctl_thp_disable_completely.never.fork
ok 3 prctl_thp_disable_completely.madvise.nofork
ok 4 prctl_thp_disable_completely.madvise.fork
ok 5 prctl_thp_disable_completely.always.nofork
ok 6 prctl_thp_disable_completely.always.fork
ok 7 prctl_thp_disable_except_madvise.never.nofork
ok 8 prctl_thp_disable_except_madvise.never.fork
ok 9 prctl_thp_disable_except_madvise.madvise.nofork
ok 10 prctl_thp_disable_except_madvise.madvise.fork
ok 11 prctl_thp_disable_except_madvise.always.nofork
ok 12 prctl_thp_disable_except_madvise.always.fork

Link: https://lkml.kernel.org/r/20250815135549.130506-8-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

 tools/testing/selftests/mm/prctl_thp_disable.c |  111 +++++++++++++++
 1 file changed, 111 insertions(+)

--- a/tools/testing/selftests/mm/prctl_thp_disable.c~selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise
+++ a/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -16,6 +16,10 @@
 #include "thp_settings.h"
 #include "vm_util.h"
 
+#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
+#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
+#endif
+
 enum thp_collapse_type {
 	THP_COLLAPSE_NONE,
 	THP_COLLAPSE_MADV_NOHUGEPAGE,
@@ -166,6 +170,113 @@ TEST_F(prctl_thp_disable_completely, for
 
 	wait(&ret);
 	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
+static void prctl_thp_disable_except_madvise_test(struct __test_metadata *const _metadata,
+						  size_t pmdsize,
+						  enum thp_enabled thp_policy)
+{
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL), 3);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
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
+FIXTURE(prctl_thp_disable_except_madvise)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
+{
+	enum thp_enabled thp_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
+{
+	.thp_policy = THP_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
+{
+	.thp_policy = THP_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
+{
+	.thp_policy = THP_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_except_madvise)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
+		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = variant->thp_policy;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_except_madvise)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_except_madvise, nofork)
+{
+	prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize,
+						      variant->thp_policy);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
 		ret = WEXITSTATUS(ret);
 	else
 		ret = -EINVAL;
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

docs-transhuge-document-process-level-thp-controls.patch
selftest-mm-extract-sz2ord-function-into-vm_utilh.patch
selftests-prctl-introduce-tests-for-disabling-thps-completely.patch
selftests-prctl-introduce-tests-for-disabling-thps-except-for-madvise.patch

