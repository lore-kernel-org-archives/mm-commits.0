Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB274221FC6
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 20:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913863; cv=none; b=Q6b1e4Y1l8f20Q9+g4ULtxtbbBdksA1577UGwzTP/nKX3ZRtX3ECyF1nCAuTQdjfWSGS+/262YSgXRUDV0PNekNeoRRfTOek/TlAImqrDLoRWIQ4/pqCYy6b4hg6u9BC/sG1pQVX7J7YCiGDtqt8gyLyiOTSWJReAp4i5dVxVNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913863; c=relaxed/simple;
	bh=cHke6vUup1T7VlhMVlGGNrUIoERrFtkybWLt4WTIbJ0=;
	h=Date:To:From:Subject:Message-Id; b=WbZ23/dAAIqzlPTo4tAJ4gMspJKoKnCZ0Brp+bL7P+aIQzMGwxH5pCqvlB0Nc9TiFNcR6dF4cOCh34nfQOuoAKN4j8YrSHIg1ypAmIBYpPZcrbfBktU8P82Mxj+529CjpFDK29tkRsnwQJeTo3GCWI4TLCxpwXLU5JB4kQK61Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xt+mBWiV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xt+mBWiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EE91F000E9;
	Wed, 27 May 2026 20:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779913861;
	bh=nfRlD95/2Vs++IGfAQ4P52Qp5XgQxH/B0PPV8Q+rNsw=;
	h=Date:To:From:Subject;
	b=xt+mBWiVfMkkf4pgPpbLiMg/8WfFQNBjGXFJxOi6i+p11hkeSsiSr6igPPy/W8aPJ
	 BfmRqonuhy4rhjv0m1MDfoszW5c42Aw8kHTRrc72DP9qN2TSX3qt9Eai0d1lwE6sUP
	 RjjLC+djB+lKaLolIAgb2hy/g2qz+ohwiEIp21lQ=
Date: Wed, 27 May 2026 13:31:00 -0700
To: mm-commits@vger.kernel.org,yukuai@fnnas.com,xiao@kernel.org,song@kernel.org,linan122@huawei.com,hch@lst.de,david.laight.linux@gmail.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] lib-raid6-use-kvmalloc-in-raid6_select_algo.patch removed from -mm tree
Message-Id: <20260527203101.61EE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/raid6: use kvmalloc() in raid6_select_algo()
has been removed from the -mm tree.  Its filename was
     lib-raid6-use-kvmalloc-in-raid6_select_algo.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/raid6: use kvmalloc() in raid6_select_algo()
Date: Tue, 26 May 2026 15:50:39 +0300

raid6_select_algo() allocates an order 3 (8 pages) buffer that is used as
a scratch area for selection of the best algorithm.

This buffer does not need to be physically contiguous and can be allocated
with kvmalloc().

Replace __get_free_pages() call with kvmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/20260526-lib-v2-2-ca3f0fc24b14@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Li Nan <linan122@huawei.com>
Cc: Song Liu <song@kernel.org>
Cc: Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/raid/raid6/algos.c~lib-raid6-use-kvmalloc-in-raid6_select_algo
+++ a/lib/raid/raid6/algos.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/pq.h>
 #include <linux/static_call.h>
 #include <kunit/visibility.h>
@@ -153,7 +154,6 @@ EXPORT_SYMBOL_GPL(raid6_recov_datap);
 
 #define RAID6_TIME_JIFFIES_LG2	4
 #define RAID6_TEST_DISKS	8
-#define RAID6_TEST_DISKS_ORDER	3
 
 static int raid6_choose_gen(void *(*const dptrs)[RAID6_TEST_DISKS],
 		const int disks)
@@ -247,7 +247,7 @@ static int __init raid6_select_algo(void
 	}
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -269,7 +269,7 @@ static int __init raid6_select_algo(void
 	/* select raid gen_syndrome function */
 	error = raid6_choose_gen(&dptrs, disks);
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	kvfree(disk_ptr);
 
 	return error;
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
lib-raid-use-kvmalloc-in-calibrate_xor_blocks.patch

