Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D0A402B8D
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779817373; cv=none; b=fTxUjZ3BOyIiwK4RvJNl6eI5/Hr0Qhf+02RRzgeRLGyiCtAEgGmbpkHGPuXy+nNwARyyAs9nXbwcfp/LtFx0GuoS3M8xgQaxHzwr5ZdqyI3lYAPSTg3jkybosvqSUgeKJnhDsozgtanWaaKQswUA8aWxC4EvIG7WWe89ywju4ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779817373; c=relaxed/simple;
	bh=6kaz08eDlbv/Gwp1hrh7oKA41c/3L9ii5Et7GlIp/mY=;
	h=Date:To:From:Subject:Message-Id; b=WNdunvTI+jiyTMDUcxSOtqK2PMntTLgxe43hJMPwZ+q8OA+yzVzdPELuqcgCm2bFUF3Rz0LyKM2z4259Pt625MS/3i6QjlE2KH1GwomPzhQqZyLslyMtkPJVTCwZXbvl0rpnFEaVmIQph5ZxdO0sRVF9YPHk5OJGuXWShj9u2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZhM/reD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZhM/reD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65FF1F000E9;
	Tue, 26 May 2026 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779817372;
	bh=SKU/tyrA9DirL4DkYbd0rJmrUrefYKj2brvxUDRADpc=;
	h=Date:To:From:Subject;
	b=BZhM/reDxwqexet7Jmnjx2TupoY8YsJvpjiop6XKXgd/OM1whdvkj8wQi2Y3e8JVG
	 KKbWQ3hLTwU2GV32dezTtPBAlNV/sajtHdyELMYEmvTd/4vREJ2GrvD6DYRrIt50M7
	 UKWfBNhhkBKXjeg5cZl5ivXh0ClKe9ylNYEb+8cc=
Date: Tue, 26 May 2026 10:42:51 -0700
To: mm-commits@vger.kernel.org,yukuai@fnnas.com,xiao@kernel.org,song@kernel.org,linan122@huawei.com,hch@lst.de,david.laight.linux@gmail.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260526174251.E65FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/raid: use kvmalloc() in calibrate_xor_blocks()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: lib/raid: use kvmalloc() in calibrate_xor_blocks()
Date: Tue, 26 May 2026 15:50:38 +0300

Patch series "lib/raid: replace __get_free_pages() call with kvmalloc()",
v2.

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc.


This patch (of 2):

The xor benchmark allocates an order 2 (4 pages) scratch buffer that is
used purely as a CPU-only XOR working area.

This buffer does not need to be physically contiguous and can be allocated
with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/20260526-lib-v2-0-ca3f0fc24b14@kernel.org
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/20260526-lib-v2-1-ca3f0fc24b14@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Li Nan <linan122@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fnnas.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/xor-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/raid/xor/xor-core.c~lib-raid-use-kvmalloc-in-calibrate_xor_blocks
+++ a/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(v
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kvmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(v
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kvfree(b1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-snapshot-vma-state-across-uffdio_copy-retry.patch
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
selftests-mm-khugepaged-use-ksefltest-framework-fix.patch
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
userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch
userfaultfd-merge-fs-userfaultfdc-into-mm-userfaultfdc.patch
userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch
lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch
lib-raid6-use-kvmalloc-in-raid6_select_algo.patch

