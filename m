Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52107C433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33326613E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEJFAe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 01:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhEJFAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 01:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B9061430;
        Mon, 10 May 2021 04:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620622767;
        bh=t1u4aHrjJnef62o5TXYW1OB/eLx52CiJYyS27i1ExJY=;
        h=Date:From:To:Subject:From;
        b=oHv4SdZA0ME0UfVYoxSQrDYR46IrlJMIWow1hU1FDDKPQzekXmVcrjRQJIGpaqPEy
         ChiUrqu3HaML0SKLpPYWSW3Qn+JBLKGSzXzPdUhb3ozTZP1sVRCZ1ZBvTL803tMPcK
         qejr/snogbi0witoz5bZFT8vg6fBsnyEnfp3RtT4=
Date:   Sun, 09 May 2021 21:59:26 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, david@redhat.com, dougg@torque.net,
        fujita.tomonori@lab.ntt.co.jp, hch@lst.de,
        mm-commits@vger.kernel.org, tj@kernel.org, willy@infradead.org,
        ziy@nvidia.com
Subject:  + mm-optimise-nth_page-for-contiguous-memmap.patch added
 to -mm tree
Message-ID: <20210510045926.UP_oeh4JS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimise nth_page for contiguous memmap
has been added to the -mm tree.  Its filename is
     mm-optimise-nth_page-for-contiguous-memmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimise-nth_page-for-contiguous-memmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimise-nth_page-for-contiguous-memmap.patch

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
Subject: mm: optimise nth_page for contiguous memmap

If the memmap is virtually contiguous (either because we're using a
virtually mapped memmap or because we don't support a discontig memmap at
all), then we can implement nth_page() by simple addition.  Contrary to
popular belief, the compiler is not able to optimise this itself for a
vmemmap configuration.  This reduces one example user (sg.c) by four
instructions:

        struct page *page = nth_page(rsv_schp->pages[k], offset >> PAGE_SHIFT);

before:
   49 8b 45 70             mov    0x70(%r13),%rax
   48 63 c9                movslq %ecx,%rcx
   48 c1 eb 0c             shr    $0xc,%rbx
   48 8b 04 c8             mov    (%rax,%rcx,8),%rax
   48 2b 05 00 00 00 00    sub    0x0(%rip),%rax
           R_X86_64_PC32      vmemmap_base-0x4
   48 c1 f8 06             sar    $0x6,%rax
   48 01 d8                add    %rbx,%rax
   48 c1 e0 06             shl    $0x6,%rax
   48 03 05 00 00 00 00    add    0x0(%rip),%rax
           R_X86_64_PC32      vmemmap_base-0x4

after:
   49 8b 45 70             mov    0x70(%r13),%rax
   48 63 c9                movslq %ecx,%rcx
   48 c1 eb 0c             shr    $0xc,%rbx
   48 c1 e3 06             shl    $0x6,%rbx
   48 03 1c c8             add    (%rax,%rcx,8),%rbx

Link: https://lkml.kernel.org/r/20210413194625.1472345-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/mm.h~mm-optimise-nth_page-for-contiguous-memmap
+++ a/include/linux/mm.h
@@ -234,7 +234,11 @@ int overcommit_policy_handler(struct ctl
 int __add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t index, gfp_t gfp, void **shadowp);
 
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
+#else
+#define nth_page(page,n) ((page) + (n))
+#endif
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch

