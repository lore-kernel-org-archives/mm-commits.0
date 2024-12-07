Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF834A24
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 06:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733551489; cv=none; b=sKMT2jHIzCVvz/O5Dbln7/TJRY4hHSayhqbgqLYe62DbIUKbZ/bU8DxcHgmaJ5nO7cyUZq0a7lSaXrSQejcrFYBAqvLQa/7i75uCblVMNi40g0tgUSsSU88sk1BviVROre9xTohOeG/5i6gM/xKWJreg3NhmnveJsgiZWSYLctI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733551489; c=relaxed/simple;
	bh=x0nBxGF02ZvRcgfRv+Uay6qWMQA9kB6NQxzAzS+LRlA=;
	h=Date:To:From:Subject:Message-Id; b=NF9rXzyqRJmA4U4gRZVHdbohFpAR9u+zKcGgMxl4Wk7euxT1uwVMSN75ZoblpePR5TXRc3I6lMcvwLi0oBjzaXnf7nmJShpVROZ47W3mmdjLSzxnoE3D8FCARcCDrnu5Hcbe0yAWSiRciZcIPusOT+SX9lAj7dOxNbcR4TUU14k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exPR1wRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exPR1wRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC0BC4CECD;
	Sat,  7 Dec 2024 06:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733551488;
	bh=x0nBxGF02ZvRcgfRv+Uay6qWMQA9kB6NQxzAzS+LRlA=;
	h=Date:To:From:Subject:From;
	b=exPR1wReqb7CxOC79hbh+XARhd7s4rs95ucbCGPP6qnzL73V8is2QIBiff++1HkTy
	 bBsNgH/GY7dgcaCkZba/KhYugJ2YO3VVHayHEUhYcZDXTNvNetjDTh6QVfMPxgIXMS
	 3XxsuRA5kkEPMxLcpfPmr1TWnmGet5hhKGRbrCqo=
Date: Fri, 06 Dec 2024 22:04:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch added to mm-unstable branch
Message-Id: <20241207060448.9DC0BC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: fixup isolate_single_pageblock() comment regarding splitting free pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: fixup isolate_single_pageblock() comment regarding splitting free pages
Date: Fri, 6 Dec 2024 10:59:51 +0100

Let's fixup the comment, documenting how free_one_page_maybe_split()
comes into play.

Link: https://lkml.kernel.org/r/20241206095951.98007-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages
+++ a/mm/page_isolation.c
@@ -298,11 +298,10 @@ __first_valid_page(unsigned long pfn, un
  * pagelbocks.
  * [      MAX_PAGE_ORDER         ]
  * [  pageblock0  |  pageblock1  ]
- * When either pageblock is isolated, if it is a free page, the page is not
- * split into separate migratetype lists, which is supposed to; if it is an
- * in-use page and freed later, __free_one_page() does not split the free page
- * either. The function handles this by splitting the free page or migrating
- * the in-use page then splitting the free page.
+ * When either pageblock is isolated, if it is an in-use page and freed later,
+ * __free_one_page_maybe_split() will split the free page if required. If the
+ * page is already free, this function handles this by splitting the free page
+ * through move_freepages_block_isolate()->__free_one_page_maybe_split().
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
 		bool isolate_before, bool skip_isolation, int migratetype)
_

Patches currently in -mm which might be from david@redhat.com are

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch
mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch
mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch

