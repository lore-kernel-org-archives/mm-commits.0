Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF41C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0635B61151
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 19:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238220AbhJOTk2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 15:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235167AbhJOTk1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 15:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B79A060FE3;
        Fri, 15 Oct 2021 19:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634326700;
        bh=MLXTGkG42o4dGk2RGBEnuoIeA0VY3yYyEDcW6EWiwpU=;
        h=Date:From:To:Subject:From;
        b=peGflnwpGYH4KbPfjYaYkSczUXD+6ICq75t1FhWZRqQvRCWpWKuUgcwq+rwbFfW0G
         Xn2danKOyZvwNFeorl7cX2M/VBebWMx93u4c26w8aw2Mhk6AL/DgIv7E3vSUb6BghO
         iDhrGc1XInJaBp1mmSDlvTpxKKBB0Twxglhi7xsk=
Date:   Fri, 15 Oct 2021 12:38:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, oliver.sang@intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?lib-stackdepot-allow-optional-init-and-stack=5Ftable-alloca?=
 =?US-ASCII?Q?tion-by-kvmalloc-fix-2.patch?= added to -mm tree
Message-ID: <20211015193820.30ckKZwGM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: allow optional init and stack_table allocation by kvmalloc() - fixup
has been added to the -mm tree.  Its filename is
     lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -845,9 +845,12 @@ static void __init mm_init(void)
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
lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix-2.patch

