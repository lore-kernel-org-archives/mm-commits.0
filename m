Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572F8C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF8161462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhD3Fzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3Fzy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37AE361459;
        Fri, 30 Apr 2021 05:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762106;
        bh=CbcmmSmdqwz82w0ROnKz4vnrSCAaNvDqRX5UPbO9Tsk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xEMjPiDfCYW7eCYKztEYdA3xzhq/fYIt5TYJdNMhKdTXmEnsYI5cCr51i5dhDuF/9
         DCfGvmiJ3qxP2K46uX5nDJ4sSlEt1VMWIpgycutw/4HnAHCCRsBI8h9M1/zW9mtwLq
         Xj7o8qKFgQmMbNqmAR/bXdcX6G1+XbFwhYnH6WS4=
Date:   Thu, 29 Apr 2021 22:55:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 037/178] mm: page_owner: use kstrtobool() to parse
 bool option
Message-ID: <20210430055505.q4cU9KC8y%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: use kstrtobool() to parse bool option

I tried to use page_owner=1 for a while noticed too late it had no effect
as opposed to similar init_on_alloc=1 (these work).

Let's make them consistent.

The change decreses binary size slightly:
   text    data     bss     dec     hex filename
  12408     321      17   12746    31ca mm/page_owner.o.before
  12320     321      17   12658    3172 mm/page_owner.o.after

Link: https://lkml.kernel.org/r/20210401210909.3532086-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-kstrtobool-to-parse-bool-option
+++ a/mm/page_owner.c
@@ -42,13 +42,7 @@ static void init_early_allocated_pages(v
 
 static int __init early_page_owner_param(char *buf)
 {
-	if (!buf)
-		return -EINVAL;
-
-	if (strcmp(buf, "on") == 0)
-		page_owner_enabled = true;
-
-	return 0;
+	return kstrtobool(buf, &page_owner_enabled);
 }
 early_param("page_owner", early_page_owner_param);
 
_
