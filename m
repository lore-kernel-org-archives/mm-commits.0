Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AEE4D8D91
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535226; cv=none; b=mkYr1RQvZKMnYRna4MWnooZAS69ZKsns7wPXBX6kbPal+ABbUX+oATOt6Ra6RLED/pAHgP/SrEfMO6xh6chGyYvx2eRjN6Tgm+sKtu3gYGaeCu5YDhAHQWcEHJFLes8IC3KaTIwSl2Rye75fvBU6x1hvpKFHhTP0MatlATc5aCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535226; c=relaxed/simple;
	bh=Z7AcSr2mrixkAS/r6Jqwxh+r5PqkMfi/VgHQFnrsVRE=;
	h=Date:To:From:Subject:Message-Id; b=pFjxRP/y7ubArE1GeKR17fpBwIzHotYPGaq4xsPGldB25O8gzd90kogxJa30qdEnztm9sgQNqf/kBbdlrLr2enHfBk6RU/bxrRGRJ30u+ZWxi0KZi3reuc9YzkHFBihBEdu1NVCGblISPab1JVKXtDTxyjIL3Ka9N0ONdaexySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USqYBn+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USqYBn+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0699FC2BCB0;
	Mon, 11 May 2026 21:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535226;
	bh=Z7AcSr2mrixkAS/r6Jqwxh+r5PqkMfi/VgHQFnrsVRE=;
	h=Date:To:From:Subject:From;
	b=USqYBn+S/fMnH3sVpTeBopIO3Z64gEVILvDY46iR0hHV46F+IDAbG5BruvzcRLaSI
	 sSQDDYVitPRRD1hP1UH/KxplnFr3Imk0PPtWOQgjBdLV5uqgRLZu3V4Uun+hFmR9Go
	 AR2VRPYzdGorhGRLm9ptw8/Bx9hht/Metwa6iFbw=
Date: Mon, 11 May 2026 14:33:45 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-migration-properly-cleanup-forked-processes.patch added to mm-new branch
Message-Id: <20260511213346.0699FC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: migration: properly cleanup fork()ed processes
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-migration-properly-cleanup-forked-processes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-migration-properly-cleanup-forked-processes.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: migration: properly cleanup fork()ed processes
Date: Mon, 11 May 2026 19:27:48 +0300

Several migration test use fork() to create worker processes.  These
processes are later killed, but nothing collects their exit status and
they remain as zombies in the system.

Add a helper function that kills the worker processes, waitpid()s for them
and verifies the exit status.

Replace the loops that call kill() for each process with a call to that
helper.

Link: https://lore.kernel.org/20260511162840.375890-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/migration.c |   47 +++++++++++++++++------
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/migration.c~selftests-mm-migration-properly-cleanup-forked-processes
+++ a/tools/testing/selftests/mm/migration.c
@@ -67,6 +67,29 @@ FIXTURE_TEARDOWN(migration)
 	free(self->pids);
 }
 
+static bool kill_children(FIXTURE_DATA(migration) * self)
+{
+	bool err = false;
+	pid_t pid;
+	int i;
+
+	for (i = 0; i < self->nthreads; i++) {
+		int status = 0;
+
+		pid = self->pids[i];
+		if (pid < 0)
+			continue;
+		if (kill(pid, SIGTERM))
+			err = true;
+		if (pid != waitpid(pid, &status, 0))
+			err = true;
+		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
+			err = true;
+	}
+
+	return !err;
+}
+
 int migrate(uint64_t *ptr, int n1, int n2)
 {
 	int ret, tmp;
@@ -151,7 +174,7 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 {
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	ptr = mmap(NULL, TWOMEG, PROT_READ | PROT_WRITE,
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
@@ -171,9 +194,9 @@ TEST_F_TIMEOUT(migration, shared_anon, 2
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -217,7 +240,7 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 	uint64_t pmdsize;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	if (!thp_is_enabled())
 		SKIP(return, "Transparent Hugepages not available");
@@ -247,9 +270,9 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 /*
@@ -287,7 +310,7 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 	unsigned long hugepage_size;
 	pid_t pid;
 	uint64_t *ptr;
-	int i;
+	int i, err;
 
 	hugepage_size = default_huge_page_size();
 	if (!hugepage_size)
@@ -311,9 +334,9 @@ TEST_F_TIMEOUT(migration, shared_anon_ht
 		}
 	}
 
-	ASSERT_EQ(migrate(ptr, self->n1, self->n2), 0);
-	for (i = 0; i < self->nthreads; i++)
-		ASSERT_EQ(kill(self->pids[i], SIGTERM), 0);
+	err = migrate(ptr, self->n1, self->n2);
+	ASSERT_EQ(kill_children(self), true);
+	ASSERT_EQ(err, 0);
 }
 
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

