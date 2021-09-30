Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAF5C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2670B61A40
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 21:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244917AbhI3Vas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229682AbhI3Vas (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 17:30:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB2A961A02;
        Thu, 30 Sep 2021 21:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633037345;
        bh=ggIXb6zJocPN3pcjnHzqR5kf7pB1wP8FCW8UDPgaRmg=;
        h=Date:From:To:Subject:From;
        b=O03WHk+ivYcUY+iWPvLjYBmZIoe3WGPNI1KljRnM/Cvikfdl1dYrlMtLeB/N9e4Ja
         z5NnSZI/p0NXtc4V0NsHS+ZFrkI53hjJhXhGV38ylVYJjFmjT8wo2T4uMTJzW88w6g
         kaBucA7cuywUGRnMDH7rxQK4NZXDJIgKGKviAMZM=
Date:   Thu, 30 Sep 2021 14:29:04 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + memcg-unify-memcg-stat-flushing.patch added to -mm tree
Message-ID: <20210930212904.ElgfC9RYp%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     memcg-unify-memcg-stat-flushing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-unify-memcg-stat-flushi=
ng.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-unify-memcg-stat-flushi=
ng.patch

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
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: unify memcg stat flushing

The memcg stats can be flushed in multiple context and potentially in
parallel too.  For example multiple parallel user space readers for memcg
stats will contend on the rstat locks with each other.  There is no need
for that.  We just need one flusher and everyone else can benefit.  In
addition after aa48e47e3906 ("memcg: infrastructure to flush memcg stats")
the kernel periodically flush the memcg stats from the root, so, the other
flushers will potentially have much less work to do.

Link: https://lkml.kernel.org/r/20210930044711.2892660-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutn=C3=BD" <mkoutny@suse.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-unify-memcg-stat-flushing
+++ a/mm/memcontrol.c
@@ -1425,7 +1425,7 @@ static char *memory_stat_format(struct m
 	 *
 	 * Current memory state:
 	 */
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (i =3D 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3529,8 +3529,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
=20
 	if (mem_cgroup_is_root(memcg)) {
-		/* mem_cgroup_threshold() calls here from irqsafe context */
-		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+		mem_cgroup_flush_stats();
 		val =3D memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3911,7 +3910,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
=20
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=3D%lu", stat->name,
@@ -3983,7 +3982,7 @@ static int memcg_stat_show(struct seq_fi
=20
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) !=3D ARRAY_SIZE(memcg1_stats));
=20
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4486,7 +4485,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
=20
-	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
=20
 	*pdirty =3D memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback =3D memcg_page_state(memcg, NR_WRITEBACK);
@@ -5354,12 +5353,14 @@ static void mem_cgroup_css_reset(struct
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
@@ -6391,7 +6392,7 @@ static int memory_numa_stat_show(struct
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

memcg-flush-stats-only-if-updated.patch
memcg-unify-memcg-stat-flushing.patch

