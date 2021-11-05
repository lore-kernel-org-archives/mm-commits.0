Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85F3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DD561212
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKEUoq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233691AbhKEUoo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AFD60C51;
        Fri,  5 Nov 2021 20:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144924;
        bh=8ufgrQ8+aTEw9uSx7Wtbtnkk0TlAQG3cvFwm+N7yYww=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cH/82wZt0IT1E2p55BmpvE25b0Cu3JGsbZFmq7CpsnwIzrO3xCvh/1cBvBmMZUDBm
         7FwiSFRfs15VMI/6iJqxQxEKeVlMc3VLelqpD8WCxq8+68tq5igqmve34KIPRisn6y
         D9A+uoxCa2Yf8+L8/9ttuxdoLFWZrplJAJeMEAyE=
Date:   Fri, 05 Nov 2021 13:42:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 142/262] hugetlb: remove unnecessary
 set_page_count in prep_compound_gigantic_page
Message-ID: <20211105204204.OdjvHE3wI%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page

In commit 7118fc2906e29 ("hugetlb: address ref count racing in
prep_compound_gigantic_page"), page_ref_freeze is used to atomically zero
the ref count of tail pages iff they are 1.  The unconditional call to
set_page_count(0) was left in the code.  This call is after
page_ref_freeze so it is really a noop.

Remove redundant and unnecessary set_page_count call.

Link: https://lkml.kernel.org/r/20211026220635.35187-1-mike.kravetz@oracle.com
Fixes: 7118fc2906e29 ("hugetlb: address ref count racing in prep_compound_gigantic_page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page
+++ a/mm/hugetlb.c
@@ -1792,7 +1792,6 @@ static bool __prep_compound_gigantic_pag
 		} else {
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
-		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
_
