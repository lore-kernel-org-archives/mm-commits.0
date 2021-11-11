Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7DDC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA7561052
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhKKEfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhKKEfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60E2610A5;
        Thu, 11 Nov 2021 04:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605163;
        bh=pg5CEAc/J9/oIfod/8XblZVSsLYxGDSczi2tEfWuwEI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sIH78E7HRS2g33kp7HqTq7q1spyw3TR2rZyZZDGe3cUNsGhqsX7ubzYuiFvOqHmDY
         LatahZMiAQUkJ6JR7y6DfApd/H/ochwuItD21AJTGkYZ6ET/CjZlxSvN3fvDZG4i77
         OwdqxfdXDRTz+D75XOO3YmLUbpEKhozLuU+JQrts=
Date:   Wed, 10 Nov 2021 20:32:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, hch@lst.de,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 5/7] mm: unexport folio_memcg_{,un}lock
Message-ID: <20211111043243.8JTPHeFwZ%akpm@linux-foundation.org>
In-Reply-To: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport folio_memcg_{,un}lock

Patch series "unexport memcg locking helpers".

Neither the old page-based nor the new folio-based memcg locking helpers
are used in modular code at all, so drop the exports.


This patch (of 2):

folio_memcg_{,un}lock are only used in built-in core mm code.

Link: https://lkml.kernel.org/r/20210820095815.445392-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210820095815.445392-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-unexport-folio_memcg_unlock
+++ a/mm/memcontrol.c
@@ -2058,7 +2058,6 @@ again:
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 }
-EXPORT_SYMBOL(folio_memcg_lock);
 
 void lock_page_memcg(struct page *page)
 {
@@ -2092,7 +2091,6 @@ void folio_memcg_unlock(struct folio *fo
 {
 	__folio_memcg_unlock(folio_memcg(folio));
 }
-EXPORT_SYMBOL(folio_memcg_unlock);
 
 void unlock_page_memcg(struct page *page)
 {
_
