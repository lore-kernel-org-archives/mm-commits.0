Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD341332612
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 22:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780005817; cv=none; b=ZTfv4p33IdfVXovAzSjFgoHzAtGunJFZ9TFCWgOrm5ov6TXGnITNSvoUt9m7hqpccy82x1YqFjTcP4+8hB3P84pRlN/pgAyhwMmHEA8FUFUsWPACpZco0r+YyU9wzAaNw1fSegCf2wJclOpyM1ufkJ/OXuwvSpi5JSpHqc5D4KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780005817; c=relaxed/simple;
	bh=kwaRy8cppR4Oh/yZMf9gxdvWIVn68v58bpF1oFhTyuY=;
	h=Date:To:From:Subject:Message-Id; b=uDEppcGi5UdDYdX76Jd0zjMyxk0/q7lzz2cF24+8GvbR937MSOO0f68X257a8d0CFFUZcVxUAqXtg7gPfIyxMStXem4csfUmq+rD/C0+1fTCw270KSZNmqviIESxg8tMskDKbLTSHLoWYXx32fJGnu3MuPTLwcPoMcgbMzjj7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eTeTTJut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTeTTJut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EBF1F000E9;
	Thu, 28 May 2026 22:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780005816;
	bh=A8K0onxbMO8lRSIbAo1G1Phur0ooHcOhWkJJ+AysEQ0=;
	h=Date:To:From:Subject;
	b=eTeTTJutE14IGPMpOfP/ts0DqkeVqgnd06gnOP02qMOgJllUoaWTR2TF6jHvRR6g9
	 KrHlWJfJts/KGiA5DKUHs8xxBI1Dx1T9kAnrnjRAFa5mTijxLB9oarnEOP3vSUx3lL
	 abcTJL1lSFfMSfaIghg9ihldhGWdpK5dKZD05GNI=
Date: Thu, 28 May 2026 15:03:35 -0700
To: mm-commits@vger.kernel.org,song@kernel.org,linan122@huawei.com,hch@lst.de,hch@infradead.org,hare@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xor-use-kmalloc-in-calibrate_xor_blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260528220336.44EBF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xor: use kmalloc() in calibrate_xor_blocks()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xor-use-kmalloc-in-calibrate_xor_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xor-use-kmalloc-in-calibrate_xor_blocks.patch

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
Subject: xor: use kmalloc() in calibrate_xor_blocks()
Date: Thu, 28 May 2026 12:53:00 +0300

Patch series "lib/raid: replace __get_free_pages() call with kmalloc()", v4.

The xor benchmark allocates 4 pages for a scratch buffer that is used
purely as a CPU-only XOR working area.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages(). 
kmalloc() does not require ugly casts and kfree() does not need to know
the size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().


This patch (of 2):

The xor benchmark allocates 4 pages for a scratch buffer that is used
purely as a CPU-only XOR working area.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/20260528-lib-v4-0-4e3ad1277279@kernel.org
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Link: https://lore.kernel.org/20260528-lib-v4-1-4e3ad1277279@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Li Nan <linan122@huawei.com>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/xor/xor-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/raid/xor/xor-core.c~xor-use-kmalloc-in-calibrate_xor_blocks
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
+	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(v
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kfree(b1);
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

