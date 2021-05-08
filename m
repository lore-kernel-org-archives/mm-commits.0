Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0B6C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC246141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHWmJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHWmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF916140E;
        Sat,  8 May 2021 22:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513666;
        bh=w8E2QGkjcoy/vBwdir2DFTupcmXr8UugHI+caNq/VKI=;
        h=Date:From:To:Subject:From;
        b=DwPuuvlFkq3rFeNSq2kIPGzJ9+b01010as/3vAx+dT1/0YO3fwwBixXnWQrbkWTQN
         ZIs6FOJZkkr8RQVjSPaDOFm5H6mCzFWKg/fX4bERnN1wfLA4FHMp1/BcitY2ynuIeW
         bPwL2uXO4XUOEPA3OHN4PpSOR7bfaJsJ4EBkGRs4=
Date:   Sat, 08 May 2021 15:41:06 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  [merged]
 mm-memcontrol-privatize-memcg_page_state-query-functions.patch removed from
 -mm tree
Message-ID: <20210508224106.2fv9rI8hL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: privatize memcg_page_state query functions
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-privatize-memcg_page_state-query-functions.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are


