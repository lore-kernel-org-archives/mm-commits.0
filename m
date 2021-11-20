Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87156C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 20 Nov 2021 00:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhKTAqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Nov 2021 19:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235621AbhKTAqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Nov 2021 19:46:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96A061A86;
        Sat, 20 Nov 2021 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637368996;
        bh=2PQW+cdaN3G/EGtGuHO4fMMzrcTBi6OEz3+gQLOt9F0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fEf9uizsMrmiHNmKLET/EihaVTp53d1J5XE74V+C9xjFHLe0da2lv0vWjLQAu295V
         mGDSWg0m/fJQal/RWuqWc0BRZwxJSa/qWJ8QsS8srB9vk1t6ekX5SmpSv1h6llgkOB
         AdYu8TXID5pZGQ7TI3dgNm0vIn2Lu3PB2n3opvts=
Date:   Fri, 19 Nov 2021 16:43:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hyc.lee@gmail.com,
        linkinjeon@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, smfrench@gmail.com,
        stfrench@microsoft.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 01/15] mm/swap.c:put_pages_list(): reinitialise
 the page list
Message-ID: <20211120004315.e4FX_Mwps%akpm@linux-foundation.org>
In-Reply-To: <20211119164248.50feee07c5d2cc6cc4addf97@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Subject: mm/swap.c:put_pages_list(): reinitialise the page list

While free_unref_page_list() puts pages onto the CPU local LRU list, it
does not remove them from the list they were passed in on.  That makes the
list_head appear to be non-empty, and would lead to various corruption
problems if we didn't have an assertion that the list was empty.

Reinitialise the list after calling free_unref_page_list() to avoid this
problem.

Link: https://lkml.kernel.org/r/YYp40A2lNrxaZji8@casper.infradead.org
Fixes: 988c69f1bc23 ("mm: optimise put_pages_list()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Steve French <stfrench@microsoft.com>
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Steve French <stfrench@microsoft.com>
Tested-by: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyeoncheol Lee <hyc.lee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/swap.c~hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list
+++ a/mm/swap.c
@@ -156,6 +156,7 @@ void put_pages_list(struct list_head *pa
 	}
 
 	free_unref_page_list(pages);
+	INIT_LIST_HEAD(pages);
 }
 EXPORT_SYMBOL(put_pages_list);
 
_
