Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D164C43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 322CF20878
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976429;
	bh=Oas1oCgjpRfVaJzPK1h8+/05dKzRzYPON4YtCKvjbDk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vPv9m6I9F7x1c5IyHh4rUSbldYMiWIQACry6kgfUHEIkZ0FSJnB3Fo+LXWINwt4KR
	 ZMfO5RQMOsEqp6bXrUiLKzhfdh5Bb/PZI3tO4+rolkr3LkKHUkTIkRGOaSCbnTKyT7
	 Sy4hdWiUfgXNpwjkrKbZZpr4BcPxlH4T+UwU2CRU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439883AbgJQXNs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D937208B6;
        Sat, 17 Oct 2020 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976428;
        bh=Oas1oCgjpRfVaJzPK1h8+/05dKzRzYPON4YtCKvjbDk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RK1FgBx65clXcg3ng30bXJ+s6+EzApHPRobGHILF0d+xkd7RHMCebGgqybonmiIAw
         kluzfl7xQ0WVHsEu6wci77MnyVhQr/D1wlVVYmesKOCfovEjkdxllLmSt6Tji7S8BV
         bZP9XIYsRGgx076pWZ6F/5b4CVtIN+Y3GNVZc198=
Date:   Sat, 17 Oct 2020 16:13:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 04/40] mm: kmem: remove redundant checks from
 get_obj_cgroup_from_current()
Message-ID: <20201017231347.o9xpcQkwN%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: remove redundant checks from get_obj_cgroup_from_current()

There are checks for current->mm and current->active_memcg in
get_obj_cgroup_from_current(), but these checks are redundant:
memcg_kmem_bypass() called just above performs same checks.

Link: http://lkml.kernel.org/r/20200827225843.1270629-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -2939,9 +2939,6 @@ __always_inline struct obj_cgroup *get_o
 	if (memcg_kmem_bypass())
 		return NULL;
 
-	if (unlikely(!current->mm && !current->active_memcg))
-		return NULL;
-
 	rcu_read_lock();
 	if (unlikely(current->active_memcg))
 		memcg = rcu_dereference(current->active_memcg);
_
