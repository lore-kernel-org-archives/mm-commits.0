Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E258EC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B78D22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709221;
	bh=jITrgXrMyYA1zWEO/4d61Bn4dfSNgFun2MwxZjMG0LA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kOj5BP6owJrbfqohDESkkfz07hZLEOUcY84cDZdUTTQ8BkfyVuX/MC+JoLY8EHDMv
	 F7QFpJRQB4Qjq6fntF6/KP5q3qDmeHXLdI2SiMrIySR0KVBDo2DplpgZ/iyYa3V4n2
	 X9KOdwq/i2Pb40ujygX4YtUso4/OcQisXeVC/K4A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgJNVAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9422068E;
        Wed, 14 Oct 2020 21:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709220;
        bh=jITrgXrMyYA1zWEO/4d61Bn4dfSNgFun2MwxZjMG0LA=;
        h=Date:From:To:Subject:From;
        b=DyQcsFP4DgrdEZN4YTddfXXaWgXbbWQaopJueG59Ykgn3stJfeSZuvXrrdvOigZeZ
         OEvi838O/HAtcD/g8TfLe75spGZrWUfvg8391PQOhLrUmS5SzEXZPq4ePbWQw59yc6
         YKsQdI2CtJr/3bNcEtZoLfJu3L+9Vd4HcAs8yx2k=
Date:   Wed, 14 Oct 2020 14:00:19 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-unify-swap-and-memsw-page-counters.patch removed from -mm tree
Message-ID: <20201014210019.9x73nJr_0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: unify swap and memsw page counters
has been removed from the -mm tree.  Its filename was
     mm-memcg-unify-swap-and-memsw-page-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: unify swap and memsw page counters

The swap page counter is v2 only while memsw is v1 only.  As v1 and v2
controllers cannot be active at the same time, there is no point to keep
both swap and memsw page counters in mem_cgroup.  The previous patch has
made sure that memsw page counter is updated and accessed only when in v1
code paths.  So it is now safe to alias the v1 memsw page counter to v2
swap page counter.  This saves 14 long's in the size of mem_cgroup.  This
is a saving of 112 bytes for 64-bit archs.

While at it, also document which page counters are used in v1 and/or v2.

Link: https://lkml.kernel.org/r/20200914024452.19167-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 ++++++++-----
 mm/memcontrol.c            |    3 ---
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-unify-swap-and-memsw-page-counters
+++ a/include/linux/memcontrol.h
@@ -215,13 +215,16 @@ struct mem_cgroup {
 	struct mem_cgroup_id id;
 
 	/* Accounted resources */
-	struct page_counter memory;
-	struct page_counter swap;
+	struct page_counter memory;		/* Both v1 & v2 */
+
+	union {
+		struct page_counter swap;	/* v2 only */
+		struct page_counter memsw;	/* v1 only */
+	};
 
 	/* Legacy consumer-oriented counters */
-	struct page_counter memsw;
-	struct page_counter kmem;
-	struct page_counter tcpmem;
+	struct page_counter kmem;		/* v1 only */
+	struct page_counter tcpmem;		/* v1 only */
 
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
--- a/mm/memcontrol.c~mm-memcg-unify-swap-and-memsw-page-counters
+++ a/mm/memcontrol.c
@@ -5295,13 +5295,11 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		memcg->use_hierarchy = true;
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
-		page_counter_init(&memcg->memsw, &parent->memsw);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
-		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		page_counter_init(&memcg->tcpmem, NULL);
 		/*
@@ -5430,7 +5428,6 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
-	page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
_

Patches currently in -mm which might be from longman@redhat.com are


