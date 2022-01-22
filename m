Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DC9C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiAVBXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiAVBXr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:23:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ECCC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B5E61ABC
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFBEC340E1;
        Sat, 22 Jan 2022 01:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814626;
        bh=0rV+Q+OpLgCd7P/fgTcwyi+je8D5iEJpB1IKosNu2hA=;
        h=Date:From:To:Subject:From;
        b=uzr323se83Q2gLEnHE1ygtUI6fsfRBDBbj0lIPmk5ITkXPGtwFWCgJI32eg657yML
         E/WchEMFiRtzyRFuMqNJHUK9ZOvt25erP6Cf+pURhFwtnOYjSDzploTtxlAH4NheCM
         z76xx2rI6n9unuNLm6UEI5EX7dKe3scxsSma+CJM=
Date:   Fri, 21 Jan 2022 17:23:45 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, oliver.sang@intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  [folded-merged]
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-alloca?=
 =?US-ASCII?Q?tion-by-kvmalloc-fix-2.patch?= removed from -mm tree
Message-ID: <20220122012345.kHfcJJFj4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch

This patch was dropped because it was folded into lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup

On FLATMEM, we call page_ext_init_flatmem_late() just before
kmem_cache_init() which means stack_depot_init() (called by page owner
init) will not recognize properly it should use kvmalloc() and not
memblock_alloc().  memblock_alloc() will also not issue a warning and
return a block memory that can be invalid and cause kernel page fault when
saving stacks, as reported by the kernel test robot [1].

Fix this by moving page_ext_init_flatmem_late() below kmem_cache_init() so
that slab_is_available() is true during stack_depot_init().  SPARSEMEM
doesn't have this issue, as it doesn't do page_ext_init_flatmem_late(),
but a different page_ext_init() even later in the boot process.

Thanks to Mike Rapoport for pointing out the FLATMEM init ordering issue.

While at it, also actually resolve a checkpatch warning in stack_depot_init()
from DRM CI, which was supposed to be in the original patch already.

[1] https://lore.kernel.org/all/20211014085450.GC18719@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/6abd9213-19a9-6d58-cedc-2414386d2d81@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c      |    7 +++++--
 lib/stackdepot.c |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/init/main.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2
+++ a/init/main.c
@@ -840,9 +840,12 @@ static void __init mm_init(void)
 	stack_depot_early_init();
 	mem_init();
 	mem_init_print_info();
-	/* page_owner must be initialized after buddy is ready */
-	page_ext_init_flatmem_late();
 	kmem_cache_init();
+	/*
+	 * page_owner must be initialized after buddy is ready, and also after
+	 * slab is ready so that stack_depot_init() works properly
+	 */
+	page_ext_init_flatmem_late();
 	kmemleak_init();
 	pgtable_init();
 	debug_objects_mem_init();
--- a/lib/stackdepot.c~lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2
+++ a/lib/stackdepot.c
@@ -171,7 +171,7 @@ __ref int stack_depot_init(void)
 	static DEFINE_MUTEX(stack_depot_init_mutex);
 
 	mutex_lock(&stack_depot_init_mutex);
-	if (!stack_depot_disable && stack_table == NULL) {
+	if (!stack_depot_disable && !stack_table) {
 		size_t size = (STACK_HASH_SIZE * sizeof(struct stack_record *));
 		int i;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup4.patch

