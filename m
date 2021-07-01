Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C12C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E4DF6146B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbhGAAtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238229AbhGAAtO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:49:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341DA61424;
        Thu,  1 Jul 2021 00:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100405;
        bh=1vSmwny9MmQtEnCufg3LIajwvaILc/wHdIgGtpGg3Jw=;
        h=Date:From:To:Subject:From;
        b=I078yaZIb98hMOo6xO34tGiuXsuoLLo80+7vftC05IF3vyKmiqYdw/t44tAvBijeG
         RLmt461FpPKXM8fA8mJeOtXXi8eRaphfEkbkNqyX53KAXW75VXc5A4HjdkyJJMbOmA
         cegffNCZ+ROUUB+Cqlo0L7NfHNaXVJwqJY2eyUYE=
Date:   Wed, 30 Jun 2021 17:46:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        willy@infradead.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hu?=
 =?US-ASCII?Q?getlb-page-fix.patch?= removed from -mm tree
Message-ID: <20210701004644.BDhN4M_iL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap: fix documentation warning
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

This patch was dropped because it was folded into mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/sparse-vmemmap: fix documentation warning

vmemmap_remap_walk is a struct, not a function, and needs to be marked
accordingly.

Link: https://lkml.kernel.org/r/20210615200242.1716568-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix
+++ a/mm/sparse-vmemmap.c
@@ -35,7 +35,7 @@
 #include <asm/tlbflush.h>
 
 /**
- * vmemmap_remap_walk - walk vmemmap page table
+ * struct vmemmap_remap_walk - walk vmemmap page table
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @reuse_page:		the page which is reused for the tail vmemmap pages.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-writeback-move-__set_page_dirty-to-core-mm.patch
mm-writeback-use-__set_page_dirty-in-__set_page_dirty_nobuffers.patch
iomap-use-__set_page_dirty_nobuffers.patch
fs-remove-anon_set_page_dirty.patch
fs-remove-noop_set_page_dirty.patch
mm-move-page-dirtying-prototypes-from-mmh.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page-fix-2.patch
mm-thp-fix-strncpy-warning.patch
mm-mark-idle-page-tracking-as-broken.patch

