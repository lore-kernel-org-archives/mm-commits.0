Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F847C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D6922267
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604278841;
	bh=36s1uTcM4/jBPjaR64Wsue6dZgT0ON2ZkPVbLKc2MIQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PMoKwbNIbR0w5qeTZp8+nuo/jEUegDAzr4LeI+wKFyYb7wq+hVNrHUL8zIT4e7lgY
	 gp9vA7etbyi4LKbvhuC2b9jZJzML7z5YT2aB1Jn7imYWfdXI0SJgtTwx1l2yEO9RNt
	 iC6+/eglDvNpxrIPmCebLuZawRT2iZMsmy9hQCA4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKBBAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:00:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:00:40 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E3E2225E;
        Mon,  2 Nov 2020 01:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604278839;
        bh=36s1uTcM4/jBPjaR64Wsue6dZgT0ON2ZkPVbLKc2MIQ=;
        h=Date:From:To:Subject:From;
        b=wKb2e/uEriwVyOQGPDTuVBfO6esaPUT0KM0spYVnzB6S7G8VH2h5zmRAwZDMyk8oI
         cbnZ57o3L2DpyNxuwo0E5QWrWOSKrD7AMQftcbIw41Pj5RPFFp13iVFk3GGSq8+W/c
         0qnibh8f2ZA1FoBCqdo3J/QO4eLdZh/unPKyka0Y=
Date:   Sun, 01 Nov 2020 17:00:39 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memcontrol-correct-the-nr=5Fanon=5Fthps-counter-of-hier?=
 =?US-ASCII?Q?archical-memcg-fix.patch?= removed from -mm tree
Message-ID: <20201102010039.qthoxAZEg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch

This patch was dropped because it was folded into mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch

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
@@ -4119,7 +4119,7 @@ static int memcg_stat_show(struct seq_fi
 		if (memcg1_stats[i] == NR_ANON_THPS)
 			nr *= HPAGE_PMD_NR;
 #endif
-		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
+		seq_printf(m, "total_%s %lu\n", memcg1_stat_names[i],
 						nr * PAGE_SIZE);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

