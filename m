Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3A9C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4103E6100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhEHWmc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A0576141D;
        Sat,  8 May 2021 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513690;
        bh=JLkIp7tWRAaGI2ewFMoEZfha4ZB3NxQIJ1KmxwIfoHg=;
        h=Date:From:To:Subject:From;
        b=RpPH3oXOy+3cSAd9yDHPbOkAyDgsydgPjxTplq89tEY+mKCswEjdgFOHs/dMIvxRa
         QJu47UW92IJ3fviz4+Z+Gmx++WzIoMKokksIZ1KmF1633xHUet6i0D9WoqTi/z1YhN
         lxMvyub96EWczjhvUAjSjXbIHYMN348j4SbR69Ww=
Date:   Sat, 08 May 2021 15:41:30 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch removed from
 -mm tree
Message-ID: <20210508224130.eRC8B138B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: change ug->dummy_page only if memcg changed
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: change ug->dummy_page only if memcg changed

Just like assignment to ug->memcg, we only need to update ug->dummy_page
if memcg changed.  So move it to there.  This is a very small
optimization.

Link: https://lkml.kernel.org/r/20210319163821.20704-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed
+++ a/mm/memcontrol.c
@@ -6843,6 +6843,7 @@ static void uncharge_page(struct page *p
 			uncharge_gather_clear(ug);
 		}
 		ug->memcg = page_memcg(page);
+		ug->dummy_page = page;
 
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6856,7 +6857,6 @@ static void uncharge_page(struct page *p
 	else
 		ug->pgpgout++;
 
-	ug->dummy_page = page;
 	page->memcg_data = 0;
 	css_put(&ug->memcg->css);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


