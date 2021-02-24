Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7D9C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EC2864F23
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhBXUFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhBXUE5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:04:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD4464F2C;
        Wed, 24 Feb 2021 20:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197028;
        bh=JFEu0I+ART4jv4GXhslXzIUBsR5SPSsSdsZ4TblWBIQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fiF8C6S8GwYhwaz3YONmtICNcvF/g2lyeqjFsYMnMlX6MjxmaKaZqteMKLgt4k36D
         9j1v3weph1FV7utPwMER650ZDTQgFfcC1RBqV5jr8tHGtGpWJuJBvNhQtLRe03Tgv/
         F21COc250RAUb6LLZinsva47CQ/9JjEGRWIcxmJU=
Date:   Wed, 24 Feb 2021 12:03:47 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 064/173] mm/memcg: revise the using condition of
 lock_page_lruvec function series
Message-ID: <20210224200347.wvBiCvR8A%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: revise the using condition of lock_page_lruvec function series

lock_page_lruvec() and its variants are safe to use under the same
conditions as commit_charge(): add lock_page_memcg() to the comment.

Polished with Hugh Dickins' suggestions, thanks!

Link: https://lkml.kernel.org/r/1608614453-10739-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series
+++ a/mm/memcontrol.c
@@ -1346,10 +1346,11 @@ void lruvec_memcg_debug(struct lruvec *l
  * lock_page_lruvec - lock and return lruvec for a given page.
  * @page: the page
  *
- * This series functions should be used in either conditions:
- * PageLRU is cleared or unset
- * or page->_refcount is zero
- * or page is locked.
+ * These functions are safe to use under any of the following conditions:
+ * - page locked
+ * - PageLRU cleared
+ * - lock_page_memcg()
+ * - page->_refcount is zero
  */
 struct lruvec *lock_page_lruvec(struct page *page)
 {
_
