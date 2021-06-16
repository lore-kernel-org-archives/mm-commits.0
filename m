Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827DAC48BDF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 03:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA8660FE6
	for <mm-commits@archiver.kernel.org>; Wed, 16 Jun 2021 03:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhFPDYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFPDYc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 23:24:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43CA961246;
        Wed, 16 Jun 2021 03:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623813747;
        bh=XQKdbbJzyDK1C5c3utfipM1s/EBfbLqMq8v0AkSaH68=;
        h=Date:From:To:Subject:From;
        b=gL0IgIs0/ITr8ApVV+a54Z8aERiAj4IAX/N+wreaTBWBiiVGD2Hn2TTQRL4y66o4s
         QJgA3rlClP8k55Pp1Gj/j2HR898qsthUR3pEB318cv4VmWO4DR6ltHvY7GyJXx6tNX
         4hYTVOOBwd/iDV+O4FSiaY8lDXQA9XQJs5T58hYg=
Date:   Tue, 15 Jun 2021 20:22:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, hch@lst.de, jack@suse.cz,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  + fs-remove-noop_set_page_dirty-fix.patch added to -mm
 tree
Message-ID: <20210616032226.c9sZYgMRX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs-remove-noop_set_page_dirty-fix
has been added to the -mm tree.  Its filename is
     fs-remove-noop_set_page_dirty-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-remove-noop_set_page_dirty-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-remove-noop_set_page_dirty-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slubc-include-swabh.patch
mm-vmalloc-add-vmalloc_no_huge-fix.patch
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
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
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

