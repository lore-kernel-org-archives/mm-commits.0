Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111BBC43603
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76816529C
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCHXI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231292AbhCHXIW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB7E65295;
        Mon,  8 Mar 2021 23:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244902;
        bh=C8pYAM55xu4UOevBfgML37umqEhVA61dbU2MM6e1lsw=;
        h=Date:From:To:Subject:From;
        b=tlmuOI0GrSl8RvV4vnhMq8ulNoSTfYWpkjVezvk1KP/YDEnOdklKILSz3Go1EhiOK
         nm91xT8hMyhlwWwyazDX1HkCRtnfY8Yq1YMowKQpRozDXhOzDU+9+GhWyC0eFtp6Ls
         8AKFOYOJfS8xcw6h7wBLR2Hxzt+ttXa2qcvsTArU=
Date:   Mon, 08 Mar 2021 15:08:21 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  +
 mm-memcontrol-privatize-memcg_page_state-query-functions.patch added to -mm
 tree
Message-ID: <20210308230821.4F4-1XohZ%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     mm-memcontrol-privatize-memcg_page_state-query-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-privatize-memcg=
_page_state-query-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-privatize-memcg=
_page_state-query-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -867,39 +867,6 @@ extern bool cgroup_memory_noswap;
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
@@ -1335,17 +1302,6 @@ static inline void mem_cgroup_print_oom_
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

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

