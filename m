Return-Path: <SRS0=UcEf=EJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3390DC388F7
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB2C82080D
	for <mm-commits@archiver.kernel.org>; Tue,  3 Nov 2020 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604427413;
	bh=UJW0uWbOq4XKwSXx2kO35o814eZXV58Ooa+ey9wxjuk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fQ3p524FA1gvLJYWV3Rb1o+5KNzaKApMeChpRKYkA7Ta6Cntrr9Fb+5dEhEmftfZd
	 Bz6vCD0TkM7umX9+jcoPPcP+ae2FBnaVUk0Uz15pC6P+3GAsRNcWPK7HJMnj/aM8Fv
	 /undlhrWOIRAaMc71C5JEFhOPlbCorPCfvMpDzdo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKCSQx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgKCSQx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 13:16:53 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C07420786;
        Tue,  3 Nov 2020 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604427412;
        bh=UJW0uWbOq4XKwSXx2kO35o814eZXV58Ooa+ey9wxjuk=;
        h=Date:From:To:Subject:From;
        b=uTW2ABBGtxzcvXN/INHJuNSKmEviJBTO4kFYBOuvhPLz+nW/a/bZMl24PMLhVPnKl
         4KrsEPuNB8QvaebIg7ijuYchPGcGmActM5JLzepvLTmDSJ5KR8NQfxBaIkpZ2veZuk
         pBKM6K3QQff744GUM/u7RXPyIVrAGug/kewqttzM=
Date:   Tue, 03 Nov 2020 10:16:52 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        zhongjiang-ali@linux.alibaba.com
Subject:  [merged]
 mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch
 removed from -mm tree
Message-ID: <20201103181652.dD-AnTdmu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Subject: mm: memcontrol: correct the NR_ANON_THPS counter of hierarchical memcg

memcg_page_state will get the specified number in hierarchical memcg,
It should multiply by HPAGE_PMD_NR rather than an page if the item is
NR_ANON_THPS.

[akpm@linux-foundation.org: fix printk warning]
[akpm@linux-foundation.org: use u64 cast, per Michal]
Link: https://lkml.kernel.org/r/1603722395-72443-1-git-send-email-zhongjiang-ali@linux.alibaba.com
Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg
+++ a/mm/memcontrol.c
@@ -4110,11 +4110,17 @@ static int memcg_stat_show(struct seq_fi
 			   (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
+		unsigned long nr;
+
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
+		nr = memcg_page_state(memcg, memcg1_stats[i]);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (memcg1_stats[i] == NR_ANON_THPS)
+			nr *= HPAGE_PMD_NR;
+#endif
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)memcg_page_state(memcg, memcg1_stats[i]) *
-			   PAGE_SIZE);
+						(u64)nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
_

Patches currently in -mm which might be from zhongjiang-ali@linux.alibaba.com are


