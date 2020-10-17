Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1928AC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B56208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976432;
	bh=4O3cY30FaNn8aYMShgTdSRDAm7hy+nEhjTVz8ELFYEg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=h7OBCBuxW3ERFGF/Oy9e2l8Qs/AtnhvHkAOMB47+nXAYpTRBPcYfqkLxIW0gkDzf3
	 FQIUKrm5nz7y0TfNLSWEErMed6VNT8TxBEEbfz/rCyydk8/MDvW6oR3GwOHqa2qcn8
	 4WbXrwYeIbe3AlOd+HXJAL5INZyJdRZAVaSVAPTo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439884AbgJQXNw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD7420878;
        Sat, 17 Oct 2020 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976431;
        bh=4O3cY30FaNn8aYMShgTdSRDAm7hy+nEhjTVz8ELFYEg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wUrC4ZcJnUEbubFJn6ffrJCQO8UwAzWMYTaMk0AHe9wt8hFvwcMXU+G7BDhFbvSq3
         FWFjOFwztbLG6Lit2R6uUi3wPX1NHrvjLwA0W9xNnL5dkjfHPcWVDxx1uT97ogO2ax
         oQwixJ9Sp5UiH4ibJd55ajB0ZTFHZjaooRnCZn/E=
Date:   Sat, 17 Oct 2020 16:13:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 05/40] mm: kmem: prepare remote memcg charging
 infra for interrupt contexts
Message-ID: <20201017231350.KU3k56hf5%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: prepare remote memcg charging infra for interrupt contexts

Remote memcg charging API uses current->active_memcg to store the
currently active memory cgroup, which overwrites the memory cgroup of the
current process.  It works well for normal contexts, but doesn't work for
interrupt contexts: indeed, if an interrupt occurs during the execution of
a section with an active memcg set, all allocations inside the interrupt
will be charged to the active memcg set (given that we'll enable
accounting for allocations from an interrupt context).  But because the
interrupt might have no relation to the active memcg set outside, it's
obviously wrong from the accounting prospective.

To resolve this problem, let's add a global percpu int_active_memcg
variable, which will be used to store an active memory cgroup which will
be used from interrupt contexts.  set_active_memcg() will transparently
use current->active_memcg or int_active_memcg depending on the context.

To make the read part simple and transparent for the caller, let's
introduce two new functions:
  - struct mem_cgroup *active_memcg(void),
  - struct mem_cgroup *get_active_memcg(void).

They are returning the active memcg if it's set, hiding all implementation
details: where to get it depending on the current context.

Link: http://lkml.kernel.org/r/20200827225843.1270629-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |   13 ++++++++--
 mm/memcontrol.c          |   48 ++++++++++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 16 deletions(-)

--- a/include/linux/sched/mm.h~mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts
+++ a/include/linux/sched/mm.h
@@ -279,6 +279,7 @@ static inline void memalloc_nocma_restor
 #endif
 
 #ifdef CONFIG_MEMCG
+DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 /**
  * set_active_memcg - Starts the remote memcg charging scope.
  * @memcg: memcg to charge.
@@ -293,8 +294,16 @@ static inline void memalloc_nocma_restor
 static inline struct mem_cgroup *
 set_active_memcg(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *old = current->active_memcg;
-	current->active_memcg = memcg;
+	struct mem_cgroup *old;
+
+	if (in_interrupt()) {
+		old = this_cpu_read(int_active_memcg);
+		this_cpu_write(int_active_memcg, memcg);
+	} else {
+		old = current->active_memcg;
+		current->active_memcg = memcg;
+	}
+
 	return old;
 }
 #else
--- a/mm/memcontrol.c~mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts
+++ a/mm/memcontrol.c
@@ -73,6 +73,9 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
+/* Active memory cgroup to use from an interrupt context */
+DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
+
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
 
@@ -1061,26 +1064,43 @@ struct mem_cgroup *get_mem_cgroup_from_p
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_page);
 
-/**
- * If current->active_memcg is non-NULL, do not fallback to current->mm->memcg.
- */
-static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
+static __always_inline struct mem_cgroup *active_memcg(void)
 {
-	if (memcg_kmem_bypass())
-		return NULL;
+	if (in_interrupt())
+		return this_cpu_read(int_active_memcg);
+	else
+		return current->active_memcg;
+}
 
-	if (unlikely(current->active_memcg)) {
-		struct mem_cgroup *memcg;
+static __always_inline struct mem_cgroup *get_active_memcg(void)
+{
+	struct mem_cgroup *memcg;
 
-		rcu_read_lock();
+	rcu_read_lock();
+	memcg = active_memcg();
+	if (memcg) {
 		/* current->active_memcg must hold a ref. */
-		if (WARN_ON_ONCE(!css_tryget(&current->active_memcg->css)))
+		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
 			memcg = root_mem_cgroup;
 		else
 			memcg = current->active_memcg;
-		rcu_read_unlock();
-		return memcg;
 	}
+	rcu_read_unlock();
+
+	return memcg;
+}
+
+/**
+ * If active memcg is set, do not fallback to current->mm->memcg.
+ */
+static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
+{
+	if (memcg_kmem_bypass())
+		return NULL;
+
+	if (unlikely(active_memcg()))
+		return get_active_memcg();
+
 	return get_mem_cgroup_from_mm(current->mm);
 }
 
@@ -2940,8 +2960,8 @@ __always_inline struct obj_cgroup *get_o
 		return NULL;
 
 	rcu_read_lock();
-	if (unlikely(current->active_memcg))
-		memcg = rcu_dereference(current->active_memcg);
+	if (unlikely(active_memcg()))
+		memcg = active_memcg();
 	else
 		memcg = mem_cgroup_from_task(current);
 
_
