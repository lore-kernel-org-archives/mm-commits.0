Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECE2C43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE12F221E3
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600052645;
	bh=EhVxNpPib20vaFRzMsG4i8bqALH704rco1PgERicojU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=b5V0L+fi+K76P0HuHHh8BL6iUUbfmKm2ceOPkeJMM9TAIGhQwoudvWeiUId6wap5n
	 dCh70WwRiN1OIN6JqXSINCsITJvTTesf9q6bn+d8Ucxdjs1LSgsy3YWtBUe/IVZOSr
	 O4fTYHoXlftYTGcsguKpQ/Ub0scnQEY9/fF/GBXg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgINDEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgINDD7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:03:59 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA30F221E7;
        Mon, 14 Sep 2020 03:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600052639;
        bh=EhVxNpPib20vaFRzMsG4i8bqALH704rco1PgERicojU=;
        h=Date:From:To:Subject:From;
        b=sESlmbgog8TWUL8Z4GHD4GeaZKOmuc/TMvF5Q0T/77Oe9Rcc0MP9lxlpZRVdkDzZJ
         mFbbfWSW46yHDSPq6P+3cajhBbiubBe3B2bYexD3cmaJeFy4NJuHhOF2augw+PT8+y
         lQi3DTob1UTwAHjz+FZg+mvf8ba2F9HokqqYhEuo=
Date:   Sun, 13 Sep 2020 20:03:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name,
        longman@redhat.com
Subject:  + mm-memcg-unify-swap-and-memsw-page-counters.patch added
 to -mm tree
Message-ID: <20200914030358.o1j37%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: unify swap and memsw page counters
has been added to the -mm tree.  Its filename is
     mm-memcg-unify-swap-and-memsw-page-counters.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-unify-swap-and-memsw-page-counters.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-unify-swap-and-memsw-page-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
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
@@ -5293,13 +5293,11 @@ mem_cgroup_css_alloc(struct cgroup_subsy
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
@@ -5428,7 +5426,6 @@ static void mem_cgroup_css_reset(struct
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
-	page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
 	page_counter_set_min(&memcg->memory, 0);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-clean-up-obsolete-enum-charge_type.patch
mm-memcg-simplify-mem_cgroup_get_max.patch
mm-memcg-unify-swap-and-memsw-page-counters.patch

