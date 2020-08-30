Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7852CC433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D972098B
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598825725;
	bh=hjos1aXay0CniFh9ZAtsioi2uGOpBprljGZ1Wxqi3Ok=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=f5rR2wDeLSyYLQB8tavyQcVsVlsJDHbpMcbjGTi0jkEVft8vZ3ZTnySkHuJQq1ROo
	 R2TUgvEnu8adTnuMuaDYI3IMYo7m/8xrpiL7uZ5zaaM52iaA5Z91sOMAteWzOcjnqy
	 F6uWxg3Fp5M76TOwVaxqA6/Sgitc8fgp24PjrrXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgH3WPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WPX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:15:23 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 151DA20738;
        Sun, 30 Aug 2020 22:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598825722;
        bh=hjos1aXay0CniFh9ZAtsioi2uGOpBprljGZ1Wxqi3Ok=;
        h=Date:From:To:Subject:From;
        b=b68JSTr651AnaEL0dEXkQxFbCgSthQdXvAnf8FBZAs+zoZYFhuNargk8eDwvHAIzj
         bD0CFDFbuhmmUNQSn3ftIUmBW1+V+h+P0CP56OQtqqCkhCqXPbKw7pfI/n/L3nV9R/
         KvYAWzzhG1FMQ4rOFbBp0k2W/3TGLXDc3CCTRArE=
Date:   Sun, 30 Aug 2020 15:15:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
 added to -mm tree
Message-ID: <20200830221521.J9UHx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: move memcg_kmem_bypass() calls to get_mem/obj_cgroup_from_current()
has been added to the -mm tree.  Its filename is
     mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch

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
Subject: mm: kmem: move memcg_kmem_bypass() calls to get_mem/obj_cgroup_from_current()

Patch series "mm: kmem: kernel memory accounting in an interrupt context".

This patchset implements memcg-based memory accounting of allocations made
from an interrupt context.

Historically, such allocations were passed unaccounted mostly because
charging the memory cgroup of the current process wasn't an option.  Also
performance reasons were likely a reason too.

The remote charging API allows to temporarily overwrite the currently
active memory cgroup, so that all memory allocations are accounted towards
some specified memory cgroup instead of the memory cgroup of the current
process.

This patchset extends the remote charging API so that it can be used from
an interrupt context.  Then it removes the fence that prevented the
accounting of allocations made from an interrupt context.  It also
contains a couple of optimizations/code refactorings.

This patchset doesn't directly enable accounting for any specific
allocations, but prepares the code base for it.  The bpf memory accounting
will likely be the first user of it: a typical example is a bpf program
parsing an incoming network packet, which allocates an entry in hashmap
map to store some information.


This patch (of 4):

Currently memcg_kmem_bypass() is called before obtaining the current
memory/obj cgroup using get_mem/obj_cgroup_from_current().  Moving
memcg_kmem_bypass() into get_mem/obj_cgroup_from_current() reduces the
number of call sites and allows further code simplifications.

Link: http://lkml.kernel.org/r/20200827225843.1270629-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200827225843.1270629-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 ++++++++-----
 mm/percpu.c     |    3 +--
 mm/slab.h       |    3 ---
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -1074,6 +1074,9 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
  */
 static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 {
+	if (memcg_kmem_bypass())
+		return NULL;
+
 	if (unlikely(current->active_memcg)) {
 		struct mem_cgroup *memcg;
 
@@ -2913,6 +2916,9 @@ __always_inline struct obj_cgroup *get_o
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg;
 
+	if (memcg_kmem_bypass())
+		return NULL;
+
 	if (unlikely(!current->mm && !current->active_memcg))
 		return NULL;
 
@@ -3039,19 +3045,16 @@ int __memcg_kmem_charge_page(struct page
 	struct mem_cgroup *memcg;
 	int ret = 0;
 
-	if (memcg_kmem_bypass())
-		return 0;
-
 	memcg = get_mem_cgroup_from_current();
-	if (!mem_cgroup_is_root(memcg)) {
+	if (memcg && !mem_cgroup_is_root(memcg)) {
 		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
 			return 0;
 		}
+		css_put(&memcg->css);
 	}
-	css_put(&memcg->css);
 	return ret;
 }
 
--- a/mm/percpu.c~mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current
+++ a/mm/percpu.c
@@ -1584,8 +1584,7 @@ static enum pcpu_chunk_type pcpu_memcg_p
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT) ||
-	    memcg_kmem_bypass())
+	if (!memcg_kmem_enabled() || !(gfp & __GFP_ACCOUNT))
 		return PCPU_CHUNK_ROOT;
 
 	objcg = get_obj_cgroup_from_current();
--- a/mm/slab.h~mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current
+++ a/mm/slab.h
@@ -281,9 +281,6 @@ static inline struct obj_cgroup *memcg_s
 {
 	struct obj_cgroup *objcg;
 
-	if (memcg_kmem_bypass())
-		return NULL;
-
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
 		return NULL;
_

Patches currently in -mm which might be from guro@fb.com are

mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

