Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8A2C48BE5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCD661350
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 22:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFOWyn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 18:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhFOWym (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 18:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B309E61040;
        Tue, 15 Jun 2021 22:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623797556;
        bh=3j/g8InfOIrtk2nKEI8YASiMgq2L8bTd3hfIJWpx3Dg=;
        h=Date:From:To:Subject:From;
        b=oV3eFG+Ws6CXlVf7p6sSAMdv98E8JCXQZo8ly8Fu0zkqoM+MVKwxYbDmWffOoHXEJ
         H+YD79P2FOyx4TTziN5CvtXF224VOz57SFuYOO2LttxUFGD0bzUUuOnXDKZEtmM7Ja
         Rt0sLZcn6liux65KJQZNg1E3e4nsdODa30FpmFaU=
Date:   Tue, 15 Jun 2021 15:52:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hu?=
 =?US-ASCII?Q?getlb-page-fix.patch?= added to -mm tree
Message-ID: <20210615225236.fACMVQ7b7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap: fix documentation warning
has been added to the -mm tree.  Its filename is
     mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mark-idle-page-tracking-as-broken.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-3.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page-fix.patch
mm-thp-fix-strncpy-warning.patch

