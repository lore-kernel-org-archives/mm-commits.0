Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C53DC388F2
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB80223AB
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604278844;
	bh=XwGBUEjWfGzP3fOSETsfxqJYRfezN3XmAqInLD6YHxg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KOyh8AzB+2ORdBNcqox7uUBBjvDTq0CwsFt/j+Ql00p5nEsjnrEyn/3Yc5gdNueS0
	 zvaGifyB6tfrEd2+KN1lNmlOc/bnkMQ+vM+ADhjnd0IMx1kT4t0J6SzkyH4tiZb0pR
	 Kyx0Mt2KeUV1/d26Y343Kdbpx4GENLCMhsTQx1IE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgKBBAn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBAn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:00:43 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5AD22267;
        Mon,  2 Nov 2020 01:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604278842;
        bh=XwGBUEjWfGzP3fOSETsfxqJYRfezN3XmAqInLD6YHxg=;
        h=Date:From:To:Subject:From;
        b=tC3u7IgpzM4TlcM2IjBgGl4p5ud1dwuA68+2ef9QtMuUK/Acfu0Jiren6tkj75JZ0
         U+snzltyisvc0ZaCKaoJ4wDWkdhqmTbno1urYI7XVAfq8BuoYZIOwgsXyJds7lQLIK
         ZRHE0Nog/1qhg4a1vXR5yCmdFIMbBNuWEt+F1bxY=
Date:   Sun, 01 Nov 2020 17:00:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, zhongjiang-ali@linux.alibaba.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memcontrol-correct-the-nr=5Fanon=5Fthps-counter-of-hier?=
 =?US-ASCII?Q?archical-memcg-fix-fix.patch?= removed from -mm tree
Message-ID: <20201102010042.WhaNGVhu9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch

This patch was dropped because it was folded into mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch

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

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg.patch
mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

