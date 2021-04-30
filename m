Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BBCC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839F1613F8
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhD3GDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhD3GDD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A443613F8;
        Fri, 30 Apr 2021 06:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762534;
        bh=/ASLQ5Mi6F+ipN31nEE0akgO6M16SpN51Yx7LI1RBAY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qKJbPzfRfDxoYaHf9nP45si8HXsyGmAxq8xaJ/kEg5yyYXuV/ss9asRxUAM48xA4M
         BKqVz7/Zxq7R+RyodVdHCHvrRznc3ZAyHnNKiCnnJbQCN44yVqa2Co8bXFWXz+zxpe
         64xoAvgHugp//wUjeOivB+5Yo8upGaeaKRUNIBFo=
Date:   Thu, 29 Apr 2021 23:02:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, huxiang@uniontech.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 176/178] mm/page_alloc: redundant definition
 variables of pfn in for loop
Message-ID: <20210430060213.LF6PpC21W%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: huxiang <huxiang@uniontech.com>
Subject: mm/page_alloc: redundant definition variables of pfn in for loop

This variable pfn is defined repeatedly, so it can be deleted.

Link: https://lkml.kernel.org/r/20210401022802.10358-1-huxiang@uniontech.com
Signed-off-by: huxiang <huxiang@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-redundant-definition-variables-of-pfn-in-for-loop
+++ a/mm/page_alloc.c
@@ -3322,7 +3322,7 @@ void free_unref_page_list(struct list_he
 
 	local_irq_save(flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page_private(page);
+		pfn = page_private(page);
 
 		set_page_private(page, 0);
 		trace_mm_page_free_batched(page);
_
