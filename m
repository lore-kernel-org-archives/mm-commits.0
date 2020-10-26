Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2D5C4363A
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 21:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14E52076B
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 21:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603746485;
	bh=fTegXONylkYC/+fJhZ/Xw2HaJ3xpMp36wav0FYNctOI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PBJ/dt+SQR5Q17V6Y44LTPo8HGBrjNJFkKsXq9jsFQsgmz9CcXvIGi0lwtgvQ6gc0
	 RGa3/4Bl6vHhYD0m/VjPvbWRkdeNTXWg+thohs7hiI7gLIZbQaN3BSOmyF/7hYquvC
	 Od2iVOZGQZAzcHtaN8avnrQRa77bjsq49sa9eY7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgJZVIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgJZVIE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 17:08:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2702C20732;
        Mon, 26 Oct 2020 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603746482;
        bh=fTegXONylkYC/+fJhZ/Xw2HaJ3xpMp36wav0FYNctOI=;
        h=Date:From:To:Subject:From;
        b=tPqmd/2XJx76qOpR4M3JJHXvY3fkA876G12ASUkgWvqwNFcjbjtPOt3jP6aRscVs+
         GR/+0BJuZ9OFBasWQqpDdQHn7cth+4PdDqwpsUmh5gRXlfluoKgRl8HSz9mUD//esX
         2pFa4TwLYzb0DDKU+JOZhRdbP3NBNTAbsipSA1l8=
Date:   Mon, 26 Oct 2020 14:08:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  +
 =?US-ASCII?Q?mm-memcontrol-correct-the-nr=5Fanon=5Fthps-counter-of-hier?=
 =?US-ASCII?Q?archical-memcg-fix.patch?= added to -mm tree
Message-ID: <20201026210801.n9JtTzchy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch

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
Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix

fix printk warning

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: zhongjiang-ali <zhongjiang-ali@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
+++ a/mm/memcontrol.c
@@ -4107,7 +4107,7 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == NR_ANON_THPS)
 			nr *= HPAGE_PMD_NR;
 #endif
-		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
+		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
 						nr * PAGE_SIZE);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch

