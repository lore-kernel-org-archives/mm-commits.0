Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8139BC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46221221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633233;
	bh=7z5RTuF6n2bqCTQ9mBG0OJMrs40XgLbxWHeH4B+Ttwg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ixH/JhITsDUWlDSoKNswcepVSLWnR893mGMLM33X1Dksxu+pKy7advPYk8si9Ru8A
	 NaxlG0oBGyMswrr7Xtg85ghYEWYKeg0iBggZWVCZAtlTfB8pTMM20BLEJF6WuIPRtw
	 nSp79ZZg9W+a938nacxlVW7n8JiyYmeHE+Aq7kk8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgJMXxx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgJMXxw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0ED208B3;
        Tue, 13 Oct 2020 23:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633232;
        bh=7z5RTuF6n2bqCTQ9mBG0OJMrs40XgLbxWHeH4B+Ttwg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iBg5b81nKJ9fCPZ37qSbW+0zkXK6gNHpbpXBm5pFfbkVz1sevoBJSVSH860nq6G5H
         gGQl3+yydciqDAOCHj+W8G4sJecuT3pm5IcE3A4lhXPtMeFgPWHslG1sIaakrZr2Uv
         Je2kpioaH/uyP7QYaV6oUxVib/JqD+1Xrxpd+8YM=
Date:   Tue, 13 Oct 2020 16:53:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 100/181] mm: move PageDoubleMap bit
Message-ID: <20201013235350.KlkfTUJYD%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move PageDoubleMap bit

Patch series "Fix PageDoubleMap".

This is a purely theoretical problem for now as none of the filesystems
which use PG_private_2 (ie PG_fscache) are being converted at this time,
but it's confusing to leave it like this.


This patch (of 2):

PG_private_2 is defined as being PF_ANY (applicable to tail pages as well
as regular & head pages).  That means that the first tail page of a
double-map page will appear to have Private2 set.  Use the Workingset bit
instead which is defined as PF_HEAD so any attempt to access the
Workingset bit on a tail page will redirect to the head page's Workingset
bit.

Link: https://lkml.kernel.org/r/20200629151933.15671-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200629151933.15671-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-move-pagedoublemap-bit
+++ a/include/linux/page-flags.h
@@ -167,7 +167,7 @@ enum pageflags {
 	PG_slob_free = PG_private,
 
 	/* Compound pages. Stored in first tail page's flags */
-	PG_double_map = PG_private_2,
+	PG_double_map = PG_workingset,
 
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
_
