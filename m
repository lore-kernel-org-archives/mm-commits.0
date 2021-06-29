Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A46C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ECCD61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhF2AWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AWd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F1761CED;
        Tue, 29 Jun 2021 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926006;
        bh=YnjRQE51rUi9VylE6g3ojLgQNOc3139RHsIFpvA5Hwc=;
        h=Date:From:To:Subject:From;
        b=oUYarNkgj3jwFj8pwM8p0F+nKJHem+VMh8Rauf0s0xUjLK9zMDeBsHLzvuJQMQ7uU
         gej7NC9jD9H/YLGNWvkPTM993b2wIAAX8wmDKlIwWKfERJcf/TH0McuZY8MwpbzzHd
         y3Yf8JXzgziTqE8uQtRt0TlZ8iiaFm0+jrNej7+w=
Date:   Mon, 28 Jun 2021 17:20:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [folded-merged] fs-remove-noop_set_page_dirty-fix.patch
 removed from -mm tree
Message-ID: <20210629002005.qEhZsQ7tC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-remove-noop_set_page_dirty-fix
has been removed from the -mm tree.  Its filename was
     fs-remove-noop_set_page_dirty-fix.patch

This patch was dropped because it was folded into fs-remove-noop_set_page_dirty.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-remove-noop_set_page_dirty-fix

export __set_page_dirty_no_writeback() to modules

ERROR: modpost: "__set_page_dirty_no_writeback" [drivers/dax/device_dax.ko] undefined!
ERROR: modpost: "__set_page_dirty_no_writeback" [fs/xfs/xfs.ko] undefined!
ERROR: modpost: "__set_page_dirty_no_writeback" [fs/fuse/fuse.ko] undefined!
ERROR: modpost: "__set_page_dirty_no_writeback" [fs/ext2/ext2.ko] undefined!
ERROR: modpost: "__set_page_dirty_no_writeback" [fs/ext4/ext4.ko] undefined!

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~fs-remove-noop_set_page_dirty-fix
+++ a/mm/page-writeback.c
@@ -2417,6 +2417,7 @@ int __set_page_dirty_no_writeback(struct
 		return !TestSetPageDirty(page);
 	return 0;
 }
+EXPORT_SYMBOL(__set_page_dirty_no_writeback);
 
 /*
  * Helper function for set_page_dirty family.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-remove-noop_set_page_dirty.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

