Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB72C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEFE2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195829;
	bh=5HN5BDIfgJJOkdwJWKoPB5TOOOYbd9Fs/SEmXyT7cP4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=p5o3rvLCoGsTHMv6Fv/IDSvEXxt75/P4T9sMpiNujQeARhLLC7rw3DZu/e10c6BCH
	 E9JAPB6QidQWts7Q+bqeUybJqU1pwrn6PFF1xB+kXj58MWiNt+vE5SlgCVqgRaupbV
	 EMr9DHqyZEp6ISAMt9H59vLuSf3pDJvFpOv9fnC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHLBa2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBa2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:30:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C265C206B2;
        Wed, 12 Aug 2020 01:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195826;
        bh=5HN5BDIfgJJOkdwJWKoPB5TOOOYbd9Fs/SEmXyT7cP4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rTsLs4fwcl2pfDcDbNSMQ9xyRhzRHkzb2afQKy0F7/1oeoFbbCz15f+cBat8Tjfrz
         E4FjLEu/2Pv4vlwcLj/hHIDTyQuCvoJSCuwmXCoQ6hQ5G5AGw7Bcn7pqaCPEuV/rfl
         xW1+rNkHkd9nCqnZKJMBsmzLqN7ZXeW42qyRhlIM=
Date:   Tue, 11 Aug 2020 18:30:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, cuibixuan@huawei.com,
        dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 004/165] mm: memcg: charge memcg percpu memory to
 the parent cgroup
Message-ID: <20200812013025.zIUSgFVUO%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: charge memcg percpu memory to the parent cgroup

Memory cgroups are using large chunks of percpu memory to store vmstat
data.  Yet this memory is not accounted at all, so in the case when there
are many (dying) cgroups, it's not exactly clear where all the memory is.

Because the size of memory cgroup internal structures can dramatically
exceed the size of object or page which is pinning it in the memory, it's
not a good idea to simply ignore it.  It actually breaks the isolation
between cgroups.

Let's account the consumed percpu memory to the parent cgroup.

[guro@fb.com: add WARN_ON_ONCE()s, per Johannes]
  Link: http://lkml.kernel.org/r/20200811170611.GB1507044@carbon.DHCP.thefa=
cebook.com
Link: http://lkml.kernel.org/r/20200623184515.4132564-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgr=
oup
+++ a/mm/memcontrol.c
@@ -5131,13 +5131,18 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
=20
-	pn->lruvec_stat_local =3D alloc_percpu(struct lruvec_stat);
+	/* We charge the parent cgroup, never the current task */
+	WARN_ON_ONCE(!current->active_memcg);
+
+	pn->lruvec_stat_local =3D alloc_percpu_gfp(struct lruvec_stat,
+						 GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_local) {
 		kfree(pn);
 		return 1;
 	}
=20
-	pn->lruvec_stat_cpu =3D alloc_percpu(struct lruvec_stat);
+	pn->lruvec_stat_cpu =3D alloc_percpu_gfp(struct lruvec_stat,
+					       GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_cpu) {
 		free_percpu(pn->lruvec_stat_local);
 		kfree(pn);
@@ -5211,11 +5216,16 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
=20
-	memcg->vmstats_local =3D alloc_percpu(struct memcg_vmstats_percpu);
+	/* We charge the parent cgroup, never the current task */
+	WARN_ON_ONCE(!current->active_memcg);
+
+	memcg->vmstats_local =3D alloc_percpu_gfp(struct memcg_vmstats_percpu,
+						GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_local)
 		goto fail;
=20
-	memcg->vmstats_percpu =3D alloc_percpu(struct memcg_vmstats_percpu);
+	memcg->vmstats_percpu =3D alloc_percpu_gfp(struct memcg_vmstats_percpu,
+						 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_percpu)
 		goto fail;
=20
@@ -5264,7 +5274,9 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	struct mem_cgroup *memcg;
 	long error =3D -ENOMEM;
=20
+	memalloc_use_memcg(parent);
 	memcg =3D mem_cgroup_alloc();
+	memalloc_unuse_memcg();
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
=20
_
