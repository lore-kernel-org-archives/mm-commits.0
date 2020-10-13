Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736DBC3279D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D4422203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633203;
	bh=YPR16uMrRd+g/eHxWoXbl0AyJ5tJ8WuZ7d5eTeZFxmA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gKkznT9ajDS35P2A6SL80kMf0IrMBZpduETHcf46UO+pjVDJ+Fn/x+kINVF7DBPny
	 PJhyhTXJFWaGJvWSP+TPonZMrj7J2P6YVaILCOqfLlWcooQP0vNZ3Hy3701OE3kwrw
	 YD4gZu+h2JTsgT1IYCCbtDjbf7TvkKDFM6rCu9yI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgJMXxW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbgJMXwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6CC221FF;
        Tue, 13 Oct 2020 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633166;
        bh=YPR16uMrRd+g/eHxWoXbl0AyJ5tJ8WuZ7d5eTeZFxmA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b9jBcR829eRFn/gDqzwc62suRS0GtDgFrPKpIXuHqhKoVrO4OulvPS1vqtCd+aBut
         SCgCjqnPb9+t/jk+5j5emgDIl1BvdZ79N5U2qoSo++sv1LpNWFoo7OiUpPN79lRYLB
         STGu7m9qdTiowo3sm7xJ4GZREVvHnl3B2k/ip+Iw=
Date:   Tue, 13 Oct 2020 16:52:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 081/181] mm: memcontrol: correct the comment of
 mem_cgroup_iter()
Message-ID: <20201013235245.shj9YrOau%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: correct the comment of mem_cgroup_iter()

Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
usage/max"), the arg @reclaim has no priority field anymore.

Link: https://lkml.kernel.org/r/20200913094129.44558-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-comment-of-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1102,9 +1102,9 @@ static __always_inline struct mem_cgroup
  * invocations for reference counting, or use mem_cgroup_iter_break()
  * to cancel a hierarchy walk before the round-trip is complete.
  *
- * Reclaimers can specify a node and a priority level in @reclaim to
- * divide up the memcgs in the hierarchy among all concurrent
- * reclaimers operating on the same node and priority.
+ * Reclaimers can specify a node in @reclaim to divide up the memcgs
+ * in the hierarchy among all concurrent reclaimers operating on the
+ * same node.
  */
 struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 				   struct mem_cgroup *prev,
_
