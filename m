Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED24C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E963F208B3
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408155;
	bh=thoHhOnpIuVPdOhRv1iU96OyJ7Bc0btMP5VftjNQ+0Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MzrqiRvJPyrQ48PLSVJR1qMv5dapnq9QcGJvPvqHo0KaZ8nqJkltZlmvSBxWGli7n
	 jaWLAlRLJ0vyNz96f8am7tcCBjzK0GzQ+EKCIio9uhOaATzpNp3Nz8WCBxcV248Yga
	 sp+kK525ZLSxe42F5VEiq+WA+VQGUMyGRthIbciQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373107AbgJVXJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444502AbgJVXJO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AED67207EA;
        Thu, 22 Oct 2020 23:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408153;
        bh=thoHhOnpIuVPdOhRv1iU96OyJ7Bc0btMP5VftjNQ+0Q=;
        h=Date:From:To:Subject:From;
        b=b624lsWBEciwV4w/Lv+6ZaiXWeODeuNBWHmBvjO0b/Z0/gtmduTmdjq6NRZ8wCcfi
         7k2INsRdqv4ILkMAarayrzFrZK4ImfiQRQlf/G+C71XxhURu26MNrTGzPWFojtmJc6
         DuDi7KB/RAJhVc+m9uViIlnCHdjPT29V+fRyvcR0=
Date:   Thu, 22 Oct 2020 16:09:12 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 =?US-ASCII?Q?mm-kmem-move-memcg=5Fkmem=5Fbypass-calls-to-get=5Fmem-o?=
 =?US-ASCII?Q?bj=5Fcgroup=5Ffrom=5Fcurrent.patch?= removed from -mm tree
Message-ID: <20201022230912.VSOVX7QCt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: move memcg_kmem_bypass() calls to get_mem/obj_cgroup_from_current()
has been removed from the -mm tree.  Its filename was
     mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

