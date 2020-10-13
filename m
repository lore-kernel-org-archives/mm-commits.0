Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C74C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A7822247
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633210;
	bh=I52/NNGNY+XvM4WUqrUw4nYDjXGMpuh9e/+aZe9hQrk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0huc4AjQPL1ktsjOTsDJAE2uBNiSKZQSL2HYwcxLpXOnMhVfVdxVLvygAmGmLx2je
	 zBXGE38mXw/TKpZmBmOefu1yH5O8HFeoWwMZPSpFkwKJJjpnV1q14YUBMSVab4QFTD
	 DdRnBZqcdP7Q6QvH5hMXpGXKXcyImNMUHbP+kdkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgJMXx3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgJMXx1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0812C22228;
        Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633207;
        bh=I52/NNGNY+XvM4WUqrUw4nYDjXGMpuh9e/+aZe9hQrk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AnQUX1g16vEsjD7PMqUXCO685Ut2rs+KeCdFhWniyyiOagpIAfX1wjv7TSZNBnHpI
         fOU+YtRQvj1HoQggMJgMSuUbOL7L8C4nUarWRkMgSXha5YjwYGL+LhwNqLwALgoGgV
         nh3cJYBqcGKLK+scAfWEO/Om9KbFTDB6FEdmG8/c=
Date:   Tue, 13 Oct 2020 16:53:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yanfei.xu@windriver.com
Subject:  [patch 093/181] mm/memory.c: fix typo in __do_fault()
 comment
Message-ID: <20201013235326.Yo2n4UNxw%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/memory.c: fix typo in __do_fault() comment

It's "pte_alloc_one", not "pte_alloc_pne". Let's fix that.

Link: http://lkml.kernel.org/r/20200818104339.5310-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-typo-in-__do_fault-comment
+++ a/mm/memory.c
@@ -3589,7 +3589,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 *				unlock_page(A)
 	 * lock_page(B)
 	 *				lock_page(B)
-	 * pte_alloc_pne
+	 * pte_alloc_one
 	 *   shrink_page_list
 	 *     wait_on_page_writeback(A)
 	 *				SetPageWriteback(B)
_
