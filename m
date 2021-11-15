Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D916C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85536633AE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhKORtX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238685AbhKORrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E8263294;
        Mon, 15 Nov 2021 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997378;
        bh=v+vnEhVl9v7NZL4OllkfYfo+muMKhOE3stEFsDCT/wQ=;
        h=Date:From:To:Subject:From;
        b=FTtJWOCfhY2O2kR6HginWjWBxDQ3tjywoyeRrTRpCV6wqh8xk1dfFZmlbKCDgI6ZJ
         lVLP7obIRpA1vJUReKLZmyktd1fBL8GX5KfvCZVvAtbup9XgqUErmHKfeGP3yeuM+S
         17dF/TrP8yqKpWFn8KUMl/rnvWmkMsJM9DvjSZic=
Date:   Mon, 15 Nov 2021 09:29:38 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hch@lst.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged] mm-unexport-folio_memcg_unlock.patch removed
 from -mm tree
Message-ID: <20211115172938.NoKUABl1S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport folio_memcg_{,un}lock
has been removed from the -mm tree.  Its filename was
     mm-unexport-folio_memcg_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are


