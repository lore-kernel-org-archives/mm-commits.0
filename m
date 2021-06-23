Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BF5C48BC2
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A672361002
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 21:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhFWV6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWV6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 17:58:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9588E60FE9;
        Wed, 23 Jun 2021 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624485392;
        bh=L61h3Uij46ht7UiMKu9drliB72OeOmVDEf9oGsU92x0=;
        h=Date:From:To:Subject:From;
        b=Dj3DgXE24I6th64q2VVw8Q2vArQhd30BCNghWWZhNA0BMQKxcJPzfPxcni0dVoJxK
         exd6L9pe+VVYqsb71HVYbOuv7rNcW8Cg/KvpoPuCByvKQGknq7UP0BW+F/wGPMt42s
         j5z9k6vvj1ju2RWjF5+LUj7xoosx7C88obwIYCSM=
Date:   Wed, 23 Jun 2021 14:56:32 -0700
From:   akpm@linux-foundation.org
To:     ddstreet@ieee.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, nathan@kernel.org, sjenning@redhat.com
Subject:  + mm-zbud-dont-export-any-zbud-api-fix.patch added to -mm
 tree
Message-ID: <20210623215632.Chjjchl3-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: fix unused function warnings when CONFIG_ZPOOL is disabled
has been added to the -mm tree.  Its filename is
     mm-zbud-dont-export-any-zbud-api-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-dont-export-any-zbud-api-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-dont-export-any-zbud-api-fix.patch

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
Subject: mm/zbud: fix unused function warnings when CONFIG_ZPOOL is disabled

There are several -Wunused-function warnings when CONFIG_ZPOOL is
disabled.  As zbud won't do anything when CONFIG_ZPOOL is disabled, we can
make zbud depends on ZPOOL and eliminate the CONFIG_ZPOOL macro in zbud.c
to fix these warnings.

Link: https://lkml.kernel.org/r/20210619025508.1239386-1-linmiaohe@huawei.com
Fixes: 962b7e9ad124 ("mm/zbud: don't export any zbud API")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 mm/zbud.c  |   10 ----------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/mm/Kconfig~mm-zbud-dont-export-any-zbud-api-fix
+++ a/mm/Kconfig
@@ -674,6 +674,7 @@ config ZPOOL
 
 config ZBUD
 	tristate "Low (Up to 2x) density storage for compressed pages"
+	depends on ZPOOL
 	help
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to two compressed pages per physical
--- a/mm/zbud.c~mm-zbud-dont-export-any-zbud-api-fix
+++ a/mm/zbud.c
@@ -109,10 +109,8 @@ struct zbud_pool {
 	struct list_head lru;
 	u64 pages_nr;
 	const struct zbud_ops *ops;
-#ifdef CONFIG_ZPOOL
 	struct zpool *zpool;
 	const struct zpool_ops *zpool_ops;
-#endif
 };
 
 /*
@@ -524,8 +522,6 @@ static u64 zbud_get_pool_size(struct zbu
  * zpool
  ****************/
 
-#ifdef CONFIG_ZPOOL
-
 static int zbud_zpool_evict(struct zbud_pool *pool, unsigned long handle)
 {
 	if (pool->zpool && pool->zpool_ops && pool->zpool_ops->evict)
@@ -616,7 +612,6 @@ static struct zpool_driver zbud_zpool_dr
 };
 
 MODULE_ALIAS("zpool-zbud");
-#endif /* CONFIG_ZPOOL */
 
 static int __init init_zbud(void)
 {
@@ -624,19 +619,14 @@ static int __init init_zbud(void)
 	BUILD_BUG_ON(sizeof(struct zbud_header) > ZHDR_SIZE_ALIGNED);
 	pr_info("loaded\n");
 
-#ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zbud_zpool_driver);
-#endif
 
 	return 0;
 }
 
 static void __exit exit_zbud(void)
 {
-#ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zbud_zpool_driver);
-#endif
-
 	pr_info("unloaded\n");
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix-2.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch
mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch
mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zbud-dont-export-any-zbud-api-fix.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

