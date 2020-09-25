Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3754C4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 706652137B
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601001670;
	bh=3haN7B/AcRR+lBZerZGhBOyEHYaf6qzRUH5WXrWJYc8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1aVQPBNcjqnDWOvE7UJQgVg66pVDEtz7GK5jB6eCqvT8uiXXleETf6+168RRfxYva
	 YRAAt91xCe5fW8r48d655proiWOM16mTAWZWUY+eEBOdZRKDICwSMeZSWS009tfe+A
	 jhDR2lGtWc2/1JuQhgqQuJh12LV70ZDW+jlGHTLE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgIYClK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgIYClJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:41:09 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE2D20809;
        Fri, 25 Sep 2020 02:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601001668;
        bh=3haN7B/AcRR+lBZerZGhBOyEHYaf6qzRUH5WXrWJYc8=;
        h=Date:From:To:Subject:From;
        b=YR8YwlQink9abKKQj5glg2C2PAlu9NlwegBHPK3hLgUckvQT43zivwRUP8viGj7Nr
         0k/mV8uwMI6DRr3XSW511nscEDq+qq0BRcS/zx/01XneySrBXc58b5NYVSq2qfZHuf
         KK2LGmxDAldv9O/43RN3DBrv9Yk4c1yAO8JTBcpY=
Date:   Thu, 24 Sep 2020 19:41:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com
Subject:  +
 mm-mempool-add-else-to-split-mutually-exclusive-case.patch added to -mm tree
Message-ID: <20200925024108.aLvwD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempool: Add 'else' to split mutually exclusive case
has been added to the -mm tree.  Its filename is
     mm-mempool-add-else-to-split-mutually-exclusive-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-add-else-to-split-mutually-exclusive-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempool: Add 'else' to split mutually exclusive case

Add else to split mutually exclusive case and avoid some unnecessary check.
It doesn't seem to change code generation (compiler is smart), but I think
it helps readability.

Link: https://lkml.kernel.org/r/20200924111641.28922-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/mempool.c~mm-mempool-add-else-to-split-mutually-exclusive-case
+++ a/mm/mempool.c
@@ -58,11 +58,10 @@ static void __check_element(mempool_t *p
 static void check_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
 		__check_element(pool, element, ksize(element));
-
 	/* Mempools backed by page allocator */
-	if (pool->free == mempool_free_pages) {
+	} else if (pool->free == mempool_free_pages) {
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -82,11 +81,10 @@ static void __poison_element(void *eleme
 static void poison_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
 		__poison_element(element, ksize(element));
-
 	/* Mempools backed by page allocator */
-	if (pool->alloc == mempool_alloc_pages) {
+	} else if (pool->alloc == mempool_alloc_pages) {
 		int order = (int)(long)pool->pool_data;
 		void *addr = kmap_atomic((struct page *)element);
 
@@ -107,7 +105,7 @@ static __always_inline void kasan_poison
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_poison_kfree(element, _RET_IP_);
-	if (pool->alloc == mempool_alloc_pages)
+	else if (pool->alloc == mempool_alloc_pages)
 		kasan_free_pages(element, (unsigned long)pool->pool_data);
 }
 
@@ -115,7 +113,7 @@ static void kasan_unpoison_element(mempo
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
 		kasan_unpoison_slab(element);
-	if (pool->alloc == mempool_alloc_pages)
+	else if (pool->alloc == mempool_alloc_pages)
 		kasan_alloc_pages(element, (unsigned long)pool->pool_data);
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

