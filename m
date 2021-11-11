Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22928C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0358A61284
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhKKCop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCon (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81DC661872;
        Thu, 11 Nov 2021 02:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598515;
        bh=POQUvIkYfh87c28utdxjm6dNMIWPtvqu6ysis9LvpQY=;
        h=Date:From:To:Subject:From;
        b=COyQiqTHsS5L1X0pWSSLAogI1s+jEtj8LbgyOixt82scVN7llTCYMCtKJYwRy88Kf
         UieqT4UwpEdmAcUHeJZ8tze3p9I0AH7WnGoDKeK62RU84QyCeLstl4EOHDTn+Zlwh6
         KXNRFYAEzjIAWrnnjt19Qp/IevLLBJdOY79L/ZnI=
Date:   Wed, 10 Nov 2021 18:41:55 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] memcg-unify-memcg-stat-flushing.patch removed
 from -mm tree
Message-ID: <20211111024155.Z2Jn7Ix7N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: unify memcg stat flushing
has been removed from the -mm tree.  Its filename was
     memcg-unify-memcg-stat-flushing.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: unify memcg stat flushing

The memcg stats can be flushed in multiple context and potentially in
parallel too.  For example multiple parallel user space readers for memcg
stats will contend on the rstat locks with each other.  There is no need
for that.  We just need one flusher and everyone else can benefit.  In
addition after aa48e47e3906 ("memcg: infrastructure to flush memcg stats")
the kernel periodically flush the memcg stats from the root, so, the other
flushers will potentially have much less work to do.

Link: https://lkml.kernel.org/r/20211001190040.48086-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-unify-memcg-stat-flushing
+++ a/mm/memcontrol.c
@@ -660,12 +660,14 @@ static inline void memcg_rstat_updated(s
=20
 static void __mem_cgroup_flush_stats(void)
 {
-	if (!spin_trylock(&stats_flush_lock))
+	unsigned long flag;
+
+	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
=20
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
-	spin_unlock(&stats_flush_lock);
+	spin_unlock_irqrestore(&stats_flush_lock, flag);
 }
=20
 void mem_cgroup_flush_stats(void)
@@ -1461,7 +1463,7 @@ static char *memory_stat_format(struct m
 	 *
 	 * Current memory state:
 	 */
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (i =3D 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3565,8 +3567,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
=20
 	if (mem_cgroup_is_root(memcg)) {
-		/* mem_cgroup_threshold() calls here from irqsafe context */
-		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+		mem_cgroup_flush_stats();
 		val =3D memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3947,7 +3948,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
=20
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=3D%lu", stat->name,
@@ -4019,7 +4020,7 @@ static int memcg_stat_show(struct seq_fi
=20
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) !=3D ARRAY_SIZE(memcg1_stats));
=20
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4522,7 +4523,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
=20
-	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	*pdirty =3D memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback =3D memcg_page_state(memcg, NR_WRITEBACK);
@@ -6405,7 +6406,7 @@ static int memory_numa_stat_show(struct
 	int i;
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
=20
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (i =3D 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
_

Patches currently in -mm which might be from shakeelb@google.com are


