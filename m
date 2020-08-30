Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046F1C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E4220738
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598825730;
	bh=E7cgd63nxArOqWS/CHKhQggUTSaFY+U+0wczapKuZk4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=amiX6RWpeY1clpXcs0NHLrh37ebFrQkrCKct3/Zro/XmYorV+g8Hl2KSmwTBe0+N0
	 xmDBYK4CE6MR9Z7V2xhktWpMgwNwLRBbrirM3bV22blwTkAWijWRZgL5ogfa4fMupw
	 RngWY8bOMhBcmBfCcawlIgLqE4QTtxc+WrjRV5PE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgH3WPa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WPa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:15:30 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F382120BED;
        Sun, 30 Aug 2020 22:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598825729;
        bh=E7cgd63nxArOqWS/CHKhQggUTSaFY+U+0wczapKuZk4=;
        h=Date:From:To:Subject:From;
        b=stxpxqoJ5v1wuE0fd2iUzBOtOd9w764C2mh1YONpl/mohgsrhi4Zff5LoCieQXIYU
         YeAgUyvvsSc7Bae5tbjSHitWwYwKU7CsL8QvCbaTmMZHopAg2O/4tlnh3vMzi0HIOt
         QwA79R6HXKgAQgds3xgAmQgBc/bz0N790cyOJheU=
Date:   Sun, 30 Aug 2020 15:15:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
 added to -mm tree
Message-ID: <20200830221528.RFvHY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: prepare remote memcg charging infra for interrupt contexts
has been added to the -mm tree.  Its filename is
     mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -304,6 +304,7 @@ static inline void memalloc_nocma_restor
 #endif
 
 #ifdef CONFIG_MEMCG
+DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 /**
  * set_active_memcg - Starts the remote memcg charging scope.
  * @memcg: memcg to charge.
@@ -318,8 +319,16 @@ static inline void memalloc_nocma_restor
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
 
@@ -1069,26 +1072,43 @@ struct mem_cgroup *get_mem_cgroup_from_p
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
 
@@ -2920,8 +2940,8 @@ __always_inline struct obj_cgroup *get_o
 		return NULL;
 
 	rcu_read_lock();
-	if (unlikely(current->active_memcg))
-		memcg = rcu_dereference(current->active_memcg);
+	if (unlikely(active_memcg()))
+		memcg = active_memcg();
 	else
 		memcg = mem_cgroup_from_task(current);
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

