Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C7CC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC252087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817529;
	bh=WsZ/Pvy+vzQ8OUmiTbnTEFLx2Jt1xYUpKp1KXGw8OGw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=13YGImEylQCvREBwQd+pQXW9FIw7L9Bh2Cm92YtoAvdtqs99CsUKE1CfhUj8fu9Dh
	 xEPJS86SdfIVsWUiEiCH4fTFLUO6sq2JTiTp1N1T0//HI/xMjmQQ+trYPjtJhebo2p
	 nCvsNs9jYQNJn/Au8jZa6kXhMk9/fmXofKmW5uqs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393937AbgJPDF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299EC20789;
        Fri, 16 Oct 2020 03:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817527;
        bh=WsZ/Pvy+vzQ8OUmiTbnTEFLx2Jt1xYUpKp1KXGw8OGw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j6iBgcVSdyIXqiGcv/1HgDRlH5ro4ihiyGyS4l78BM8494RrfGAkMoTF67x7yAWbT
         Ae/v5aahLd0LnIQdtVfuUfaV70mj5EgAufWNXK4POiMizaDwiBcL/iDUs6E7A2uEBE
         9UYzzuzxlOlPPHgBsFFopZ4DlsHrqx2dWnJ+f1EY=
Date:   Thu, 15 Oct 2020 20:05:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 020/156] mm/memory: remove page fault assumption
 of compound page size
Message-ID: <20201016030526.XF5qtL8K0%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory: remove page fault assumption of compound page size

A compound page in the page cache will not necessarily be of PMD size,
so check explicitly.

[willy@infradead.org: fix remove page fault assumption of compound page size]
  Link: https://lkml.kernel.org/r/20201001152259.14932-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200908195539.25896-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memory-remove-page-fault-assumption-of-compound-page-size
+++ a/mm/memory.c
@@ -3709,13 +3709,14 @@ static vm_fault_t do_set_pmd(struct vm_f
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	pmd_t entry;
 	int i;
-	vm_fault_t ret;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
 
 	if (!transhuge_vma_suitable(vma, haddr))
-		return VM_FAULT_FALLBACK;
+		return ret;
 
-	ret = VM_FAULT_FALLBACK;
 	page = compound_head(page);
+	if (compound_order(page) != HPAGE_PMD_ORDER)
+		return ret;
 
 	/*
 	 * Archs like ppc64 need additonal space to store information
_
