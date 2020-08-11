Return-Path: <SRS0=Ir1+=BV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD62C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 20:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E3B20781
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597178013;
	bh=zni6mIlUWvOukC9xjyy4evW7LY8sfZG8p7Dhr5k1AiA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=l3RzZ5i+XWa2htJlTGM78JLVsZ/GzTNOzd0L6UKw1AGxXckFjWkXRR4+Rn/pTJRr6
	 OL7Gj0O0qIYXTgL1fZZqDt3MXcF3F/zjBMyaPZ3Si9iK3NuS2zMe1GtaMRRNux5Vgl
	 rzQeE+X8yqFvvclOBe96TducLirdP56CV07LeshI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKUdd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 16:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgHKUdc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 16:33:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0ACA2076C;
        Tue, 11 Aug 2020 20:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597178012;
        bh=zni6mIlUWvOukC9xjyy4evW7LY8sfZG8p7Dhr5k1AiA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MuS1OgWaqrwSY8vgIHqRO3B587l76K1WhVgpUVS4wK2H9w84/hKAIyXxtVP8NRn5Y
         ZYJUnkU2v1D375d4KCyrBM0OyaTJysfLL1EV2AWjhAgzr/ukBlmQd84vAXmlohbBWi
         1Y1ZV7lE2lHZbNiNUlrbtabcJAKrwmwL6tWP1oLM=
Date:   Tue, 11 Aug 2020 13:33:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dennis@kernel.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  +
 mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch added to
 -mm tree
Message-ID: <20200811203331.B_jewCnTP%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch

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
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup-fix.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

