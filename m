Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E4BC433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF66208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262578;
	bh=U2lx8UBwqh7SqVtsUm7OV0OV+q1ehQlnwi9xpgYCnCE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dS9OH5UoC3mAIEAajXjvLGfpTzoKmYs0gVnrf4naCOXkd+818pAzRbc895Qf6aahL
	 NNqWHQYRR6C249lK7KwPlriCcOxHvPrqGWQUpA4UfSgY+b55O7tOk9kfxUp+pJHeEY
	 MCm9XP+dIMWEX9RjMVkO1rY1VY2IypcnzfMEsM98=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgIDXgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 720242084D;
        Fri,  4 Sep 2020 23:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262576;
        bh=U2lx8UBwqh7SqVtsUm7OV0OV+q1ehQlnwi9xpgYCnCE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JCSA4QMuz2ptlihdA0m3i13Vpav1JEGG73RpzGD4wxOcVtGqIFe830EYZ1UG8YVia
         4TIZDcWYtHClyDfy77yhgwuNGOUA3Ok5rFDB54RaCWnGl7+0gurt90KnWkiuzA7gkF
         xri84Q93boSPHb7SNXXE0/Qs9c1j/Y/cYf1TzDNs=
Date:   Fri, 04 Sep 2020 16:36:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        ebiggers@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 18/19] mm/khugepaged.c: fix khugepaged's request
 size in collapse_file
Message-ID: <20200904233616.8nQR2-R8H%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Subject: mm/khugepaged.c: fix khugepaged's request size in collapse_file

collapse_file() in khugepaged passes PAGE_SIZE as the number of pages to
be read to page_cache_sync_readahead().  The intent was probably to read a
single page.  Fix it to use the number of pages to the end of the window
instead.

Link: https://lkml.kernel.org/r/20200903140844.14194-2-willy@infradead.org
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Yang Shi <shy828301@gmail.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~fix-khugepageds-request-size-in-collapse_file
+++ a/mm/khugepaged.c
@@ -1709,7 +1709,7 @@ static void collapse_file(struct mm_stru
 				xas_unlock_irq(&xas);
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
-							  PAGE_SIZE);
+							  end - index);
 				/* drain pagevecs to help isolate_lru_page() */
 				lru_add_drain();
 				page = find_lock_page(mapping, index);
_
