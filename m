Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF44C07E95
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AEF613DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Jul 2021 04:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhGPER3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Jul 2021 00:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhGPER3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Jul 2021 00:17:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0E3613D0;
        Fri, 16 Jul 2021 04:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626408874;
        bh=yf9VCwqfaaEaR9b5Y1XJtmgs1ysqs3v+SqR6Gk/3uC4=;
        h=Date:From:To:Subject:From;
        b=zsWYzrFh7o+CFX/4ivvJ244VYOnQ1bPbl636PBTaRn2BUlvH24b8lYWAQX6aEy/u1
         BPOXVxnEaVEFMZblmA2pXZMk3VnAyuZ1a0FbSD0e9JioPypvKyvZvCEHOfAgtyJhWG
         s8dnI1okMcmrFxfrNWtT5JcCJMBOHxXD5IyUwKhE=
Date:   Thu, 15 Jul 2021 21:14:34 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, suhui@zeku.com, vdavydov.dev@gmail.com
Subject:  +
 mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg.patch
 added to -mm tree
Message-ID: <20210716041434.yo3nJCJJN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmpressure: replace vmpressure_to_css() with vmpressure_to_memcg()
has been added to the -mm tree.  Its filename is
     mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from suhui@zeku.com are

mm-vmpressure-replace-vmpressure_to_css-with-vmpressure_to_memcg.patch

