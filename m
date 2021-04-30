Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973E9C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E5561476
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhD3F5G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhD3F5F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E199D61477;
        Fri, 30 Apr 2021 05:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762178;
        bh=VvEbwxi1iVJFn5Ikdraf3qOuiYdUjxzJyfKCJGu00hI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o2BlNfBtw79SzUB6oFId/eNVUalwdMKpMuzqWeLyiWRlQtQF+2ruFZ9OURkWxLmXe
         mEwQmSYTqJYkbydGFGp6OC/oxDDhqlhXYja5istuUBkn5818SDBKk2TRaSkQuCr0uW
         +QDSVxzAYjIHhEBBXMLFPcE43xLy+iSXn7ofyqZA=
Date:   Thu, 29 Apr 2021 22:56:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 061/178] mm: memcontrol: privatize
 memcg_page_state query functions
Message-ID: <20210430055617.cN9hFWgY6%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: privatize memcg_page_state query functions

There are no users outside of the memory controller itself. The rest
of the kernel cares either about node or lruvec stats.

Link: https://lkml.kernel.org/r/20210209163304.77088-4-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   44 -----------------------------------
 mm/memcontrol.c            |   32 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 44 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-privatize-memcg_page_state-q=
uery-functions
+++ a/include/linux/memcontrol.h
@@ -864,39 +864,6 @@ extern bool cgroup_memory_noswap;
 void lock_page_memcg(struct page *page);
 void unlock_page_memcg(struct page *page);
=20
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int=
 idx)
-{
-	long x =3D atomic_long_read(&memcg->vmstats[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x =3D 0;
-#endif
-	return x;
-}
-
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
-static inline unsigned long memcg_page_state_local(struct mem_cgroup *memc=
g,
-						   int idx)
-{
-	long x =3D 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		x +=3D per_cpu(memcg->vmstats_local->stat[idx], cpu);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x =3D 0;
-#endif
-	return x;
-}
-
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item */
@@ -1322,17 +1289,6 @@ static inline void mem_cgroup_print_oom_
 {
 }
=20
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int=
 idx)
-{
-	return 0;
-}
-
-static inline unsigned long memcg_page_state_local(struct mem_cgroup *memc=
g,
-						   int idx)
-{
-	return 0;
-}
-
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
 				     int idx,
 				     int nr)
--- a/mm/memcontrol.c~mm-memcontrol-privatize-memcg_page_state-query-functi=
ons
+++ a/mm/memcontrol.c
@@ -789,6 +789,38 @@ void __mod_memcg_state(struct mem_cgroup
 	__this_cpu_write(memcg->vmstats_percpu->stat[idx], x);
 }
=20
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page_state().
+ */
+static unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x =3D atomic_long_read(&memcg->vmstats[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x =3D 0;
+#endif
+	return x;
+}
+
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page_state().
+ */
+static unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int =
idx)
+{
+	long x =3D 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		x +=3D per_cpu(memcg->vmstats_local->stat[idx], cpu);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x =3D 0;
+#endif
+	return x;
+}
+
 static struct mem_cgroup_per_node *
 parent_nodeinfo(struct mem_cgroup_per_node *pn, int nid)
 {
_
