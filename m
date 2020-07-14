Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3C7C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E044921883
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594686247;
	bh=GP8Bw1UugpYVhlN8HeHVsurVA65SyC7kNKoM/SSNjAA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XjXPhjotK3mOqV5ujTFnT76XdoWE6FoUyB3DBYiIX3yM2xioc7olQty2hTuwxzTZ5
	 kyN1AFgltJ+nCj6VEo7HjErKf+RCepR2pzax3ETTE7Oyu6m/eiMwPdzSD3Adgjawev
	 q5PK6PIAHRmxC9mOIQyx0SlpAcXpqHS3PTG3y1SQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGNAYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 20:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbgGNAYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 20:24:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDEE92186A;
        Tue, 14 Jul 2020 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594686246;
        bh=GP8Bw1UugpYVhlN8HeHVsurVA65SyC7kNKoM/SSNjAA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qum4/1YtmgH1AzLgV3AkNWiTDGqmECbif03xtXyXmKSAgrKmJTTPf/eWPg7+tpGqg
         4Xkm8cr27EVr6lZjZKq89/AIk7rto/nAR5iNvL0CyQULuPei4v1weikW0jkJvcoEo8
         erVjdoUrNspiIuLv7AwmQY7GUMVe8NArOOsZC30s=
Date:   Mon, 13 Jul 2020 17:24:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  + mm-handle-page-mapping-better-in-dump_page-fix.patch
 added to -mm tree
Message-ID: <20200714002405.MedMjztc1%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-handle-page-mapping-better-in-dump_page-fix
has been added to the -mm tree.  Its filename is
     mm-handle-page-mapping-better-in-dump_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-handle-page-mapping-better-in-dump_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-handle-page-mapping-better-in-dump_page-fix.patch

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
Subject: mm-handle-page-mapping-better-in-dump_page-fix

augmented code comment from John

Link: http://lkml.kernel.org/r/15cff11a-6762-8a6a-3f0e-dd227280cd6f@nvidia.com
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/debug.c~mm-handle-page-mapping-better-in-dump_page-fix
+++ a/mm/debug.c
@@ -69,7 +69,13 @@ void __dump_page(struct page *page, cons
 	}
 
 	if (page < head || (page >= head + MAX_ORDER_NR_PAGES)) {
-		/* Corrupt page, cannot call page_mapping */
+		/*
+		 * Corrupt page, so we cannot call page_mapping. Instead, do a
+		 * safe subset of the steps that page_mapping() does. Caution:
+		 * this will be misleading for tail pages, PageSwapCache pages,
+		 * and potentially other situations. (See the page_mapping()
+		 * implementation for what's missing here.)
+		 */
 		unsigned long tmp = (unsigned long)page->mapping;
 
 		if (tmp & PAGE_MAPPING_ANON)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

