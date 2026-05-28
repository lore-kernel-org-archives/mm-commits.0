Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16913655DA
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 21:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780005533; cv=none; b=osNQsWYhrHjsySI/EiOBOqv7U7IS058pQttntzMpChheMP3KnwI5fxtCtg2sT2E9OD2CJ4Sh1PofKZQEw4TIQyKgFXwqAPetFOt2sqjX/Sxhc4yHl2MHHECpfFP77d/qxvV7iJoU74DNOFEpxCtHvwbdttHQZ2kxqeooQTYRs2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780005533; c=relaxed/simple;
	bh=gyseLgRkfcI9H65JPTpGg03IG9Ihxen89+wzFHW02bE=;
	h=Date:To:From:Subject:Message-Id; b=nLN++M3CpYc8PdoZ8m8q/FCqXxNmIS08cOoGxl7PTeOZk8/xSIwUaOx7XHsZdhYKYZ0G4C5yGVLXC80GGu9GDe76b33D+sqats5ozvEd036h5WTbQ2cFQbRICjXK+Sla1QEeR63sDZplr+h/eJy893xu8ycdaLZOawppX/vWuSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6IK278N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6IK278N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4771F000E9;
	Thu, 28 May 2026 21:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780005532;
	bh=xmXLg4xeHrGi7CvvMR886LAOSK7AC1z26PfX/i32NZA=;
	h=Date:To:From:Subject;
	b=R6IK278NCwe9FaDb7rZN7WyqagVZAC09RC/PI/usBQJUGTzbrjfie6YcX8NG0ZfNR
	 bcmVXOZrFZ9i1xumprM8+AKZJCn01aZxoT7bwrfNp6f4y8il4Mz+hXDvVi1VWf6fPZ
	 oxole0hHo4qRNYsi9vcp9lE7BmN07Uoz0C1Dp3zs=
Date: Thu, 28 May 2026 14:58:51 -0700
To: mm-commits@vger.kernel.org,yukuai@fnnas.com,xiao@kernel.org,song@kernel.org,linan122@huawei.com,hch@lst.de,david.laight.linux@gmail.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch removed from -mm tree
Message-Id: <20260528215852.2A4771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/raid: use kvmalloc() in calibrate_xor_blocks()
has been removed from the -mm tree.  Its filename was
     lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/raid: use kvmalloc() in calibrate_xor_blocks()
Date: Tue, 26 May 2026 15:50:38 +0300

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

userfaultfd-verify-vma-state-across-uffdio_copy-retry.patch
userfaultfd-refuse-to-__mfill_atomic_pte-for-unsupported-vmas.patch
userfaultfd-remove-redundant-check-in-vm_uffd_ops.patch
userfaultfd-ensure-mremap_userfaultfd_fail-releases-mmap_changing.patch
userfaultfd-merge-fs-userfaultfdc-into-mm-userfaultfdc.patch
userfaultfd-make-functions-that-are-not-used-outside-uffd-static.patch
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
xor-use-kmalloc-in-calibrate_xor_blocks.patch
raid6-use-kmalloc-in-raid6_select_algo.patch

