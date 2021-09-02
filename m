Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF85C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A9360F21
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347796AbhIBWAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347934AbhIBWAg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCEF603E9;
        Thu,  2 Sep 2021 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619977;
        bh=EB2upp/iydNFAXKEXUogtKyW+o9VS7pGox0Af3s+Vho=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Mp8KKudAJiualkRYmTqhzBNPk+p5p7piXpWQszB7UHYxcDmQgT93HjXHYdb3y+MbK
         oPq9qRfKFe3giSuRpNFX9xOZCK6JotZ59EKPu36veckRJBtMNhOSp3vm8ABSviQxx6
         AzX/Y8Y6aNbUsWyOzzSsnWtOfQoRBChUY9cWrFGw=
Date:   Thu, 02 Sep 2021 14:59:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, suhui@zeku.com,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 182/212] mm/vmpressure: replace
 vmpressure_to_css() with vmpressure_to_memcg()
Message-ID: <20210902215936.FyZZvBWhV%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <suhui@zeku.com>
Subject: mm/vmpressure: replace vmpressure_to_css() with vmpressure_to_memcg()

We can get memcg directly form vmpr instead of vmpr->memcg->css->memcg, so
add a new func helper vmpressure_to_memcg().  And no code will use
vmpressure_to_css(), so delete it.

Link: https://lkml.kernel.org/r/20210630112146.455103-1-suhui@zeku.com
Signed-off-by: Hui Su <suhui@zeku.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    2 +-
 mm/memcontrol.c            |    4 ++--
 mm/vmpressure.c            |    3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/vmpressure.h~mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg
+++ a/include/linux/vmpressure.h
@@ -37,7 +37,7 @@ extern void vmpressure_prio(gfp_t gfp, s
 extern void vmpressure_init(struct vmpressure *vmpr);
 extern void vmpressure_cleanup(struct vmpressure *vmpr);
 extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
-extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr);
+extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
 extern int vmpressure_register_event(struct mem_cgroup *memcg,
 				     struct eventfd_ctx *eventfd,
 				     const char *args);
--- a/mm/memcontrol.c~mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg
+++ a/mm/memcontrol.c
@@ -256,9 +256,9 @@ struct vmpressure *memcg_to_vmpressure(s
 	return &memcg->vmpressure;
 }
 
-struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
+struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr)
 {
-	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
+	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
 #ifdef CONFIG_MEMCG_KMEM
--- a/mm/vmpressure.c~mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg
+++ a/mm/vmpressure.c
@@ -74,8 +74,7 @@ static struct vmpressure *work_to_vmpres
 
 static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
 {
-	struct cgroup_subsys_state *css = vmpressure_to_css(vmpr);
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = vmpressure_to_memcg(vmpr);
 
 	memcg = parent_mem_cgroup(memcg);
 	if (!memcg)
_
