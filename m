Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C4BC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314C76329D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhKORtV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238675AbhKORrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9036363295;
        Mon, 15 Nov 2021 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997380;
        bh=4mCBJiPyIOhqWp4schEd1AJVjDboffrLf21EWGHn3gQ=;
        h=Date:From:To:Subject:From;
        b=b41kovxdjz9A7j6J5clQV0Fg0kcK9vBgX/3ebEcVhIaJzcVP/eUVsQHCG4DV64/OW
         rImqdmr7+2iA9RsDoJXSCCfdwSZKxGo7LIP09hWnobYaO+wEe9Gk+ogn/+n3Lh5jTd
         /GDL+rsDxP03AdGTWaR2g6JfY5zFtDNLbNCtMVSw=
Date:   Mon, 15 Nov 2021 09:29:40 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hch@lst.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged] mm-unexport-unlock_page_memcg.patch removed from
 -mm tree
Message-ID: <20211115172940.ZhndcrEBG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unexport {,un}lock_page_memcg
has been removed from the -mm tree.  Its filename was
     mm-unexport-unlock_page_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport {,un}lock_page_memcg

These are only used in built-in core mm code.

Link: https://lkml.kernel.org/r/20210820095815.445392-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memcontrol.c~mm-unexport-unlock_page_memcg
+++ a/mm/memcontrol.c
@@ -2063,7 +2063,6 @@ void lock_page_memcg(struct page *page)
 {
 	folio_memcg_lock(page_folio(page));
 }
-EXPORT_SYMBOL(lock_page_memcg);
 
 static void __folio_memcg_unlock(struct mem_cgroup *memcg)
 {
@@ -2096,7 +2095,6 @@ void unlock_page_memcg(struct page *page
 {
 	folio_memcg_unlock(page_folio(page));
 }
-EXPORT_SYMBOL(unlock_page_memcg);
 
 struct obj_stock {
 #ifdef CONFIG_MEMCG_KMEM
_

Patches currently in -mm which might be from hch@lst.de are


