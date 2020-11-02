Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3582CC2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C32206D4
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279253;
	bh=To7ZvNAuCGZT/TSIVyu/E6kAkRytiKqL7yKnTDVXX1c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EWiq3LnCHHUFCw+bM3Smpnx2vvlMTosnxKxWv91Cuk/4D9XdWKEw0Thp5kjB04vVK
	 EGm8sfmkErHNkRTW99wiNLCJ5i1b2IJFPBxosCQ0FugLeoPdwUi97gm9CR3c8dEFgx
	 BonS7J5iFbJu1zytA/NjdMjPl6LrXxq8Akdjfho0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgKBBHc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:32 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BECDC206B7;
        Mon,  2 Nov 2020 01:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279252;
        bh=To7ZvNAuCGZT/TSIVyu/E6kAkRytiKqL7yKnTDVXX1c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g2/ieIUSd37s6ip/zTscDxG9HjI7A9xk39u6Ne9RFsde9o/2cW1L7TU2a1T+h4QmN
         Y2licusF6AV+4x83g2kVnguKGh+/fBlR94mYxSAcvB6s0SdwfXzkdbwGqHEFoIRX5Q
         z89WBgHv8rXjXxjuNiq6usG07TVFHmf3U/8mDk8c=
Date:   Sun, 01 Nov 2020 17:07:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zhongjiang-ali@linux.alibaba.com
Subject:  [patch 03/15] mm: memcontrol: correct the NR_ANON_THPS
 counter of hierarchical memcg
Message-ID: <20201102010730.wIga-XDXR%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
