Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF45C43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854F5208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976426;
	bh=AqPbhk1/9EDvvsGkmL2/V/8ERjOJSl9illXilsGwdq0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2ut9nFsuseeyGngnFwqrrA9b7IlaS5CI3fhYl94Yc8xpkuVu5jtz5jrsHtst+Z6/0
	 xDEy4TCLQnn7JtaQJjeg9SQRFtJ/BsHOeSuXDf/yaGHMOqc6hicg8xpw+4FS0ZSNzr
	 fx2yzzutQpO4dq5DZjCeC3qQDNML1pkt6rDXECao=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439882AbgJQXNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:13:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0095520E65;
        Sat, 17 Oct 2020 23:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976425;
        bh=AqPbhk1/9EDvvsGkmL2/V/8ERjOJSl9illXilsGwdq0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SyrELc9zsGzqET708GEV4125mPEg2WUvdKHQYg2rEt8bRNv4lVDYpMqJgitt66r/7
         jyUqxnSpiwt06odojxIyXeUHhRACnu9miIOwikwxaoiaU/VRlnyTn1Vp+XUi+ppwFB
         xO+Kk5u+VJj5PGcCMZCRSWl6yWr4A5tDo/tvXbcY=
Date:   Sat, 17 Oct 2020 16:13:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 03/40] mm: kmem: move memcg_kmem_bypass() calls to
 get_mem/obj_cgroup_from_current()
Message-ID: <20201017231344.gdtuTtYpQ%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1066,6 +1066,9 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
  */
 static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 {
+	if (memcg_kmem_bypass())
+		return NULL;
+
 	if (unlikely(current->active_memcg)) {
 		struct mem_cgroup *memcg;
 
@@ -2933,6 +2936,9 @@ __always_inline struct obj_cgroup *get_o
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg;
 
+	if (memcg_kmem_bypass())
+		return NULL;
+
 	if (unlikely(!current->mm && !current->active_memcg))
 		return NULL;
 
@@ -3059,19 +3065,16 @@ int __memcg_kmem_charge_page(struct page
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
@@ -280,9 +280,6 @@ static inline struct obj_cgroup *memcg_s
 {
 	struct obj_cgroup *objcg;
 
-	if (memcg_kmem_bypass())
-		return NULL;
-
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
 		return NULL;
_
