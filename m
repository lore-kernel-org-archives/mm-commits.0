Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C3AC43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76DE610E7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347810AbhIBVyq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347873AbhIBVyf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B19461102;
        Thu,  2 Sep 2021 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619616;
        bh=Zrfe9BEnUtfD1tCYm4+VMWdmRe29NQe6uCc8RaC4wDw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bsKSnL9w3sv3lRJFVgNWYFp9BkYJM8XgMSpjaCJW4RS4Bzy38OuQruFeX1Vt+oQ0M
         q40zEEoWx74NuKfgcMA38J32HSEjEFB+YTEEAhvERZ3HiuqQa4fwKLmEBAD1QU322z
         hUWMhcEN9W8rHDjJazX13TQGpJk/J1LjcXNScmTw=
Date:   Thu, 02 Sep 2021 14:53:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        imbrenda@linux.ibm.com, jack@suse.cz, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 069/212] mm: gup: remove unneed local variable
 orig_refs
Message-ID: <20210902215336.jqMySlPeg%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: gup: remove unneed local variable orig_refs

Remove unneed local variable orig_refs since refs is unchanged now.

Link: https://lkml.kernel.org/r/20210807093620.21347-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-remove-unneed-local-variable-orig_refs
+++ a/mm/gup.c
@@ -117,8 +117,6 @@ __maybe_unused struct page *try_grab_com
 	if (flags & FOLL_GET)
 		return try_get_compound_head(page, refs);
 	else if (flags & FOLL_PIN) {
-		int orig_refs = refs;
-
 		/*
 		 * Can't do FOLL_LONGTERM + FOLL_PIN gup fast path if not in a
 		 * right zone, so fail and let the caller fall back to the slow
@@ -150,7 +148,7 @@ __maybe_unused struct page *try_grab_com
 			page_ref_add(page, refs * (GUP_PIN_COUNTING_BIAS - 1));
 
 		mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_ACQUIRED,
-				    orig_refs);
+				    refs);
 
 		return page;
 	}
_
