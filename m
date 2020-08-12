Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383CCC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 087ED20866
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193859;
	bh=pNHup6W1OlE4rZNwrw0AwlsmILgnKceHIPYeKfgtG0w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zG8exiRt+lIEzfOqFdYKR+7vWVS7B40IAZuVRSJ4QE3qjo3rVpMNDRjfT8U4Hm8Mx
	 NKjEQ/yKVpDbfOo+j83F3gyzAwok0K+OVXnxhfclpmT2rQ8SYfV3WVKF00Ki4r1gfg
	 c+BJkS0tB1oCGfm4NVHuyqbEOkbRBWIhHjuxfU4g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHLA5i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgHLA5i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:57:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEFED207DA;
        Wed, 12 Aug 2020 00:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193858;
        bh=pNHup6W1OlE4rZNwrw0AwlsmILgnKceHIPYeKfgtG0w=;
        h=Date:From:To:Subject:From;
        b=a7dVXs8jVWwJpoOQ6s/dVX7EVbchu4wrkCfebwqbOR/zFTi1e9ZDaQS7C8R5CTPpK
         MhMQmKnYM4LJUpeNLHbb3IQvDTolw1naPzoMq+J3md0a4cps2dja9CJlxmo0ZQk6JE
         C2JJU3QwCBrRGaTRTljVZOfr4ism2d6I9DgL4E50=
Date:   Tue, 11 Aug 2020 17:57:37 -0700
From:   akpm@linux-foundation.org
To:     dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [folded-merged]
 mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch removed
 from -mm tree
Message-ID: <20200812005737.3g4IPUtWQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch

This patch was dropped because it was folded into mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix

add WARN_ON_ONCE()s, per Johannes

Link: http://lkml.kernel.org/r/20200811170611.GB1507044@carbon.DHCP.thefacebook.com
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix
+++ a/mm/memcontrol.c
@@ -5131,6 +5131,9 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
+	/* We charge the parent cgroup, never the current task */
+	WARN_ON_ONCE(!current->active_memcg);
+
 	pn->lruvec_stat_local = alloc_percpu_gfp(struct lruvec_stat,
 						 GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_local) {
@@ -5213,6 +5216,9 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
 
+	/* We charge the parent cgroup, never the current task */
+	WARN_ON_ONCE(!current->active_memcg);
+
 	memcg->vmstats_local = alloc_percpu_gfp(struct memcg_vmstats_percpu,
 						GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_local)
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

