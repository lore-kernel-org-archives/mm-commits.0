Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DB5250;
	Mon,  6 May 2024 00:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955329; cv=none; b=NycpWflcHtJlA3Z5bQlWwWFoEH2Kpe1yb8AxJqe99EozYQeqLhRwuOBAJRyrqyrcKdodfhLJt9w+gBXP3P75/NvVNQNPNj9F2AeG3DsCZXl2GuTkyZMtAynU0Y0nm5edx8HyXoIe8rh3qWbriFkV86cFR9EiiRgtiVw2gn3mLEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955329; c=relaxed/simple;
	bh=5+SQhYKyIhgIAxA30XMnihYHumY8kiz4n0RgVuvBw9c=;
	h=Date:To:From:Subject:Message-Id; b=OM3TzfNPv3SEKFwXClUnk5m8anaN4c6AGZ+UNolEAtX+3cVGdKUKPuzPtLVzw+Z6cHE3Qc6B9mSE05iP+KHVcGgK1O46DACwvnL5eaOhKFK3QK3Yq8rVRjaCBvzlIz3BnQ+nxHnjkEbLNM9N9WJiq6uxsMDFlAw1FKV/DPcDc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0+BGCsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0+BGCsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDCBC113CC;
	Mon,  6 May 2024 00:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955329;
	bh=5+SQhYKyIhgIAxA30XMnihYHumY8kiz4n0RgVuvBw9c=;
	h=Date:To:From:Subject:From;
	b=x0+BGCsxLyz9W2uJt/7+H/7nVpqoTceMPf3xwidfKozYl7Kp+69JHS5d7Q7Xozt+q
	 hr8Rqpun5T0VGpAaLti1UJ/bHQ3WoanqkIREg226XfWZAtj5INYl7uuo5nnxOvNO9k
	 DaS6bzMVEP+Z9n6d3HSGny8MEyznLT+Bbo86evfQ=
Date: Sun, 05 May 2024 17:28:48 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,willy@infradead.org,stable@vger.kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-use-memalloc_nofs_save-in-page_cache_ra_order.patch removed from -mm tree
Message-Id: <20240506002849.4BDCBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use memalloc_nofs_save() in page_cache_ra_order()
has been removed from the -mm tree.  Its filename was
     mm-use-memalloc_nofs_save-in-page_cache_ra_order.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use memalloc_nofs_save() in page_cache_ra_order()
Date: Fri, 26 Apr 2024 19:29:38 +0800

See commit f2c817bed58d ("mm: use memalloc_nofs_save in readahead path"),
ensure that page_cache_ra_order() do not attempt to reclaim file-backed
pages too, or it leads to a deadlock, found issue when test ext4 large
folio.

 INFO: task DataXceiver for:7494 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:DataXceiver for state:D stack:0     pid:7494  ppid:1      flags:0x00000200
 Call trace:
  __switch_to+0x14c/0x240
  __schedule+0x82c/0xdd0
  schedule+0x58/0xf0
  io_schedule+0x24/0xa0
  __folio_lock+0x130/0x300
  migrate_pages_batch+0x378/0x918
  migrate_pages+0x350/0x700
  compact_zone+0x63c/0xb38
  compact_zone_order+0xc0/0x118
  try_to_compact_pages+0xb0/0x280
  __alloc_pages_direct_compact+0x98/0x248
  __alloc_pages+0x510/0x1110
  alloc_pages+0x9c/0x130
  folio_alloc+0x20/0x78
  filemap_alloc_folio+0x8c/0x1b0
  page_cache_ra_order+0x174/0x308
  ondemand_readahead+0x1c8/0x2b8
  page_cache_async_ra+0x68/0xb8
  filemap_readahead.isra.0+0x64/0xa8
  filemap_get_pages+0x3fc/0x5b0
  filemap_splice_read+0xf4/0x280
  ext4_file_splice_read+0x2c/0x48 [ext4]
  vfs_splice_read.part.0+0xa8/0x118
  splice_direct_to_actor+0xbc/0x288
  do_splice_direct+0x9c/0x108
  do_sendfile+0x328/0x468
  __arm64_sys_sendfile64+0x8c/0x148
  invoke_syscall+0x4c/0x118
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x4c/0x1f8
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x188/0x190

Link: https://lkml.kernel.org/r/20240426112938.124740-1-wangkefeng.wang@huawei.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/readahead.c~mm-use-memalloc_nofs_save-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -490,6 +490,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t index = readahead_index(ractl);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
+	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
 
@@ -504,6 +505,8 @@ void page_cache_ra_order(struct readahea
 		new_order = min_t(unsigned int, new_order, ilog2(ra->size));
 	}
 
+	/* See comment in page_cache_ra_unbounded() */
+	nofs = memalloc_nofs_save();
 	filemap_invalidate_lock_shared(mapping);
 	while (index <= limit) {
 		unsigned int order = new_order;
@@ -527,6 +530,7 @@ void page_cache_ra_order(struct readahea
 
 	read_pages(ractl);
 	filemap_invalidate_unlock_shared(mapping);
+	memalloc_nofs_restore(nofs);
 
 	/*
 	 * If there were already pages in the page cache, then we may have
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

