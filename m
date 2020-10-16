Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4050C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B70CF2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817556;
	bh=1UzBdhHCB+IHIQVeS+1osjWoD7zVb24gmfJfTNS6YkM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HtZrOkvi3Sf1pQvv+CpOaBD6rztNFLDI52kjlEyETOCLLXkt9eG9B9wcO81amhjLf
	 GMYm+CX2oAI7mzGgtwDtdm32J7VdgkXNV9yOe+TupXfcR/beLPUlH9ORqVS3N4QOFx
	 trvKSGHmJkZbX4FV0eXTTrWBawCOrq1WBbix6Cjg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393945AbgJPDF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBF2720878;
        Fri, 16 Oct 2020 03:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817554;
        bh=1UzBdhHCB+IHIQVeS+1osjWoD7zVb24gmfJfTNS6YkM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NMwN2lCDaAPUKDyWntcHQAB3yBO1Gw+avc7yF8FpQN0GG/mu+44ONOFdCyN+ALEt1
         r8DlYJHQNOZYkDWVzHlHJ1m2F6Ogs846UT+ueekiX28xRSuThf2rC35Ne0S6K/ZIce
         axb60FXkAV6ff3jXLnSWZy4+coXXv2YRda3hjHH4=
Date:   Thu, 15 Oct 2020 20:05:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 028/156] mm/page-writeback: support tail pages in
 wait_for_stable_page
Message-ID: <20201016030553.9f6uITy6G%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page-writeback: support tail pages in wait_for_stable_page

page->mapping is undefined for tail pages, so operate exclusively on the
head page.

Link: https://lkml.kernel.org/r/20200908195539.25896-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~mm-page-writeback-support-tail-pages-in-wait_for_stable_page
+++ a/mm/page-writeback.c
@@ -2849,6 +2849,7 @@ EXPORT_SYMBOL_GPL(wait_on_page_writeback
  */
 void wait_for_stable_page(struct page *page)
 {
+	page = thp_head(page);
 	if (page->mapping->host->i_sb->s_iflags & SB_I_STABLE_WRITES)
 		wait_on_page_writeback(page);
 }
_
