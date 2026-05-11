Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0BF3859C9
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535219; cv=none; b=rYutWZCumypD7sQ1FUbb4+DVU3XQATznfKTkutC6hVhdTlj5K+5JoOY9gp7aJRtotQ5klbS0sRfRt8sC+zBln9HH4voSrllxCqlVNTirsA7aBw5crxvy6gbafa48Y5Kf2qQE5ik7LaJFpW3L+Ekbdavz4S7IB+dG4sukXko4o64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535219; c=relaxed/simple;
	bh=qmr3jT16C8u5FdmX8eeimYVPURIVwbd6WR58iuaPEis=;
	h=Date:To:From:Subject:Message-Id; b=T0S9TKZ+mFHs5RO6uj2oAyA7OuV7y/K9pih75vUmUvfvwcQwolhS0BVXoP9uu6N9kuZXGXb9BhXu52qyXaV1lid26hSFJvbeQPUMiJpwFSuZxHDCuI8vs3G4jHQGcmd0znEQ5IXz8jJhlNwo0d130bXLP00AXxV+6iB4Rrd+z0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=onBHPG0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="onBHPG0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D7BC2BCB0;
	Mon, 11 May 2026 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535219;
	bh=qmr3jT16C8u5FdmX8eeimYVPURIVwbd6WR58iuaPEis=;
	h=Date:To:From:Subject:From;
	b=onBHPG0+33I90owTU/NfdcMr41tfMHZO7jYxFbKoyO159zqVoq6etCjZBbfNeSh3z
	 9YDltqIKP80MNQPqNOWOx06Vb0LlN1AQTm0GAWiwXOyFUHnA6lLudWCTjqVk4g6Reg
	 q73PLhhtGpxF4sBeSBKg+WqGCKYelaN6kBTwQ2yg=
Date: Mon, 11 May 2026 14:33:38 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch added to mm-new branch
Message-Id: <20260511213339.19D7BC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch

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
Subject: selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Mon, 11 May 2026 19:27:45 +0300

Patch series "make MM selftests more CI friendly", v4.

There's a lot of dancing around HugeTLB settings in run_vmtests.sh.  Some
test need just a few default huge pages, some require at least 256 MB, and
some just skip lots of tests if huge pages of all supported sizes are not
available.

The goal of this set is to make tests deal with HugeTLB setup and
teardown.

There are already convenient helpers that allow easy reading and writing
of /proc and /sysfs, so adding a few APIs that will detect and update
HugeTLB settings shouldn't be a big deal.  But these nice helpers use
kselftest framework, and many of HugeTLB (and even THP) test don't, so as
a result this patchset also includes a lot of churn for conversion of
those tests to kselftest framework (patches 7-19).

The series break out:
patches 1-5:   small fixes
patch 6:       merge of hugetlb mmap tests
patch 7:       renaming of hugepage-* to hugetlb-*
patches 8-21:  mechanical conversion to kselftest framework
patches 22-28: extension of thp_settings to hugepage_settings to also include
               HugeTLB helpers
patches 29-30: add helpers for setting up SHM limits in hugetlb-shm and
               thuge-gen tests
patches 31-53: integrate the new APIs in all the tests that use HugeTLB
patches 54-55: drop HugeTLB setup from run_vmtests.sh


This patch (of 55):

Injection of a memory error with madvise() causes SIGBUS, which terminates
the hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Link: https://lore.kernel.org/20260511162840.375890-1-rppt@kernel.org
Link: https://lore.kernel.org/20260511162840.375890-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c~selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,10 @@ close:
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +278,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
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

