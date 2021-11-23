Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D656C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 23 Nov 2021 22:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhKWWsl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhKWWsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 17:48:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AE160E0B;
        Tue, 23 Nov 2021 22:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637707532;
        bh=Xtqn5aAStFNPv21fzmb8aY+CN7kfHkO6Ojradn3LZWY=;
        h=Date:From:To:Subject:From;
        b=LW4KxGwL37MOLrV5z0AbcNgzlOKtIbMTvE02narLYDCOH206cUo4NIk0g9xWhz2/V
         P5ddIrD4B9o/1BDm2ECoZ3u9XUgwenuYsbar7+RNYc/P+06Fb98LL8GfRMiOs42yvW
         M9wl36hPhlsCh2KKdGZsloFT6ZMa9vSHiRgfWWSg=
Date:   Tue, 23 Nov 2021 14:45:31 -0800
From:   akpm@linux-foundation.org
To:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        mm-commits@vger.kernel.org, smfrench@gmail.com,
        stfrench@microsoft.com, willy@infradead.org
Subject:  [merged]
 hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch removed
 from -mm tree
Message-ID: <20211123224531.HY05sDnnz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c:put_pages_list(): reinitialise the page list
has been removed from the -mm tree.  Its filename was
     hitting-bug_on-trap-in-read_pages-mm-optimise-put_pages_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from willy@infradead.org are


