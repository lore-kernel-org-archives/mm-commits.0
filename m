Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F915C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0DF20796
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 23:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603927596;
	bh=wc0mM7yjwKS4PnPu9EqTTl+0ZPwqdYtkdK5VKg0Mw08=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Oyo0dHfJQC8MoVeNamnq9y10XbchNr6VRselJWrdGFuzEt6X3kdBPoSB6CGD+6YM3
	 3s1LiDjDJuj560RZoKhdvJeV4qHXWOi1SKsTEtl7Hf6FdXXnvHpEKOUX9y1AtlZTiw
	 RDsGKW5GEawBB7ntKuRBVcnWs8qoNXSK+s1b1C7M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390386AbgJ1X0e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 19:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390349AbgJ1XYj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 19:24:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E54CE20796;
        Wed, 28 Oct 2020 23:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603927478;
        bh=wc0mM7yjwKS4PnPu9EqTTl+0ZPwqdYtkdK5VKg0Mw08=;
        h=Date:From:To:Subject:From;
        b=Il1NX5sa3DspJFk6nHrxMUl5z9ajEuAXB6Oe01vG+JUneDQNLjj6UZQrAuDpmGoC7
         eF6WmAvEJwE13hC1Ywqx3BAIcwczLKDkOXQrVz+MzV4cx+NAjMcmYkOwYl5OxLvAi5
         +ifwf4xUMejTR/oZDfb1tLQrVaW556UtXc0Z+kZ8=
Date:   Wed, 28 Oct 2020 16:24:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-correct-the-nr=5Fanon=5Fthps-counter-of-hier?=
 =?US-ASCII?Q?archical-memcg-fix-fix.patch?= added to -mm tree
Message-ID: <20201028232435.2GwynNjYD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix

use u64 cast, per Michal

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix
+++ a/mm/memcontrol.c
@@ -4119,8 +4119,8 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == NR_ANON_THPS)
 			nr *= HPAGE_PMD_NR;
 #endif
-		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
-						nr * PAGE_SIZE);
+		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
+						(u64)nr * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

