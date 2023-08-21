Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB06EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjHUV36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjHUV3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D691B0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA7306460D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA67C433C7;
        Mon, 21 Aug 2023 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653380;
        bh=qTaTf4JvboP7mlWybYaZ2F7dbHByx0AI4W9l9esYLOI=;
        h=Date:To:From:Subject:From;
        b=rIswKxUmFvxu/atYxtob2KvKdfmPQu5w9rAdKNFYv0dSWtTgQ3KfDyXKzkEN7GjeU
         v/wtgzz5/hDReG8oPwAfFOwPH68a5pNhVlJou/Y0gnG/hInpOReklCziq0uW1pGplT
         PBGVuNTW6VYDNKvz+GPaYI3v+9OSdXT/3QbsY9jc=
Date:   Mon, 21 Aug 2023 14:29:39 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-tail-private-fields-to-struct-folio.patch removed from -mm tree
Message-Id: <20230821212940.0AA67C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add tail private fields to struct folio
has been removed from the -mm tree.  Its filename was
     mm-add-tail-private-fields-to-struct-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add tail private fields to struct folio
Date: Wed, 16 Aug 2023 16:12:00 +0100

Because THP_SWAP uses page->private for each page, we must not use the
space which overlaps that field for anything which would conflict with
that.  We avoid the conflict on 32-bit systems by disallowing THP_SWAP on
32-bit.

Link: https://lkml.kernel.org/r/20230816151201.3655946-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-add-tail-private-fields-to-struct-folio
+++ a/include/linux/mm_types.h
@@ -322,8 +322,11 @@ struct folio {
 			atomic_t _pincount;
 #ifdef CONFIG_64BIT
 			unsigned int _folio_nr_pages;
-#endif
+			/* 4 byte gap here */
 	/* private: the union with struct page is transitional */
+			/* Fix THP_SWAP to not use tail->private */
+			unsigned long _private_1;
+#endif
 		};
 		struct page __page_1;
 	};
@@ -344,6 +347,9 @@ struct folio {
 	/* public: */
 			struct list_head _deferred_list;
 	/* private: the union with struct page is transitional */
+			unsigned long _avail_2a;
+			/* Fix THP_SWAP to not use tail->private */
+			unsigned long _private_2a;
 		};
 		struct page __page_2;
 	};
@@ -368,12 +374,18 @@ FOLIO_MATCH(memcg_data, memcg_data);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
+#ifdef CONFIG_64BIT
+FOLIO_MATCH(private, _private_1);
+#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
 			offsetof(struct page, pg) + 2 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_2);
 FOLIO_MATCH(compound_head, _head_2);
+FOLIO_MATCH(flags, _flags_2a);
+FOLIO_MATCH(compound_head, _head_2a);
+FOLIO_MATCH(private, _private_2a);
 #undef FOLIO_MATCH
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-memoryc-fix-mismerge.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch
mm-swap-use-dedicated-entry-for-swap-in-folio.patch
mm-remove-checks-for-pte_index.patch
mm-move-pmd_order-to-pgtableh.patch
mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch
mm-remove-enum-page_entry_size.patch
mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch
mm-fix-get_mctgt_type-kernel-doc.patch
mm-fix-clean_record_shared_mapping_range-kernel-doc.patch
mm-add-orphaned-kernel-doc-to-the-rst-files.patch

