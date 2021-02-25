Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7DBC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8E8164EFA
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhBYTZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234368AbhBYTW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B513464F67;
        Thu, 25 Feb 2021 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280452;
        bh=yyqiJ52SYliQonaXo8BLNm2MbqrUDLy7GuqNSF/pD8g=;
        h=Date:From:To:Subject:From;
        b=rA12ZOc/yKZ1heeykCRFouN271xGd4pOfZbkOEQTAxgd4Rvj0xvOkuh5VNSNP8Vrg
         voa27gYQTBDkPvpEpsr+hrEOwgQ0fqm0FJBzlOqhI2T8e+ur/eMxH1J/wgV2UvqZ1n
         wcZsE7PPnZVyKHyrj4UzKtR2QFy4/6GjWYz+/shk=
Date:   Thu, 25 Feb 2021 11:14:11 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-memcg-revise-the-using-condition-of-lock=5Fpage=5Flruv?=
 =?US-ASCII?Q?ec-function-series.patch?= removed from -mm tree
Message-ID: <20210225191411.Rt3VOS6Bw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: revise the using condition of lock_page_lruvec function series
has been removed from the -mm tree.  Its filename was
     mm-memcg-revise-the-using-condition-of-lock_page_lruvec-function-series.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are


