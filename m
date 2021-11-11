Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5173FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39CB761052
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhKKEfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhKKEff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:35:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6557610FC;
        Thu, 11 Nov 2021 04:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605166;
        bh=Nez74/N9XVbgj/4g0JWaUzuHXBuPHyFHRLfY4QWVMKs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=noOYBsQWwwRrp85A/bAHKgHXryAVQbix3y2mIfiOXVvcrXjojgyZl7rUXZGlneL1T
         gahQrTFxCSSCyIBrq7/+D0LK1nV6r/GcygHawSArFEhrQIDAAqwYrBD5G+TraWx46J
         Wt/d8dVPGkwpjd90T0UstUBcU2Q0VzZleRCXPFhs=
Date:   Wed, 10 Nov 2021 20:32:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, hch@lst.de,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 6/7] mm: unexport {,un}lock_page_memcg
Message-ID: <20211111043246.xcLg4uTsX%akpm@linux-foundation.org>
In-Reply-To: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
