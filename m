Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8661AC3F6B0
	for <mm-commits@archiver.kernel.org>; Fri, 29 Jul 2022 19:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiG2TC7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238537AbiG2TCt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 15:02:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2887486C29
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 12:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D133DB827B4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 19:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A6CC433D6;
        Fri, 29 Jul 2022 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659121363;
        bh=z7xd17x6F3refkNfn0HreJk7MMdz2LiKkOUKXTxTxw0=;
        h=Date:To:From:Subject:From;
        b=E1CSsyssnchKzLd4WQxlWE8aRfukiKmuQ3Jsa1eS6Uhbw3ML+mbSyb41zG5Cq5srg
         Vsgb+otP0ycKSn+JFjB3cBatbyde6AIJBB42cv0QWoTaRtaPEhPR+okJhyJSwfewJx
         iJ52Y7wwOZpFE67jOc3nF6L2ZRc4gQWruOSikIPg=
Date:   Fri, 29 Jul 2022 12:02:42 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-notify-about-global-mem_cgroup_id-space-depletion.patch removed from -mm tree
Message-Id: <20220729190243.90A6CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: notify about global mem_cgroup_id space depletion
has been removed from the -mm tree.  Its filename was
     memcg-notify-about-global-mem_cgroup_id-space-depletion.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vasily Averin <vvs@openvz.org>
Subject: memcg: notify about global mem_cgroup_id space depletion
Date: Mon, 27 Jun 2022 05:11:26 +0300

Currently, the host owner is not informed about the exhaustion of the
global mem_cgroup_id space.  When this happens, systemd cannot start a new
service and receives a unique -ENOSPC error code.  However, this can
happen inside this container, persist in the log file of the local
container, and may not be noticed by the host owner if he did not try to
start any new services.

Link: https://lkml.kernel.org/r/97bed1fd-f230-c2ea-1cb6-8230825a9a64@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memcontrol.c~memcg-notify-about-global-mem_cgroup_id-space-depletion
+++ a/mm/memcontrol.c
@@ -5175,6 +5175,8 @@ static struct mem_cgroup *mem_cgroup_all
 				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
+		if (error == -ENOSPC)
+			pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from vvs@openvz.org are


