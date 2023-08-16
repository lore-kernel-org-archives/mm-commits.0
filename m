Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F2BC2FC18
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346984AbjHPWnw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347008AbjHPWnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DA2173F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E91A602F9
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EFBC433C7;
        Wed, 16 Aug 2023 22:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692225820;
        bh=BDn75V2Blrl5lnwxBChCqPx/EeIgGLzM2jYSc8YAX2Q=;
        h=Date:To:From:Subject:From;
        b=cdOQAM9JfYdjgWET+P+f9JEtLbh7ZGluaWrkwMfXjxrYX2tcKW4l6IM0VIcbLDhY2
         slVxKaxOUsZkT+j7g+AOzQ/8NsPovyLeOqE/EKAkYvXAjy+OgnrbD/9NPWpgqoHOay
         cieG+yLLirn2xyarS+gR8LIqspqD2e+26ySmfEMg=
Date:   Wed, 16 Aug 2023 15:43:40 -0700
To:     mm-commits@vger.kernel.org, siyanteng@loongson.cn,
        sidhartha.kumar@oracle.com, david@redhat.com, axboe@kernel.dk,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-tail-private-fields-to-struct-folio.patch added to mm-unstable branch
Message-Id: <20230816224340.D6EFBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add tail private fields to struct folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-tail-private-fields-to-struct-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-tail-private-fields-to-struct-folio.patch

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
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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
mm-allow-fault_dirty_shared_page-to-be-called-under-the-vma-lock.patch
io_uring-stop-calling-free_compound_page.patch
mm-call-free_huge_page-directly.patch
mm-convert-free_huge_page-to-free_huge_folio.patch
mm-convert-free_transhuge_folio-to-folio_undo_large_rmappable.patch
mm-convert-prep_transhuge_page-to-folio_prep_large_rmappable.patch
mm-remove-free_compound_page-and-the-compound_page_dtors-array.patch
mm-remove-hugetlb_page_dtor.patch
mm-add-large_rmappable-page-flag.patch
mm-rearrange-page-flags.patch
mm-free-up-a-word-in-the-first-tail-page.patch
mm-remove-folio_test_transhuge.patch
mm-add-tail-private-fields-to-struct-folio.patch
mm-convert-split_huge_pages_pid-to-use-a-folio.patch

