Return-Path: <SRS0=97KN=AZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F675C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 431DA21841
	for <mm-commits@archiver.kernel.org>; Tue, 14 Jul 2020 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594685971;
	bh=iu1A99YYI53xhAedLmh3CyNGsnMx05D3DQGkv/m6Sy0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HgdzoNG3K5X5Gyz7f6eVkefaarFslPeh+v24oKdiR7slL1cQaDlM9ratLm1RuK5OJ
	 GOByDHOUwGi7ooIt57i1OQrLQN0GEMpNLBamAJnNH7XaoTn4srhcVi7kJvHO2u4U8B
	 JlOAL5W0VugidzSZbqH+3pQ9IkOZuaYEnAs/tm6Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgGNATa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jul 2020 20:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgGNATa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jul 2020 20:19:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C6C217BA;
        Tue, 14 Jul 2020 00:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594685970;
        bh=iu1A99YYI53xhAedLmh3CyNGsnMx05D3DQGkv/m6Sy0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JFfwWFIZkFI9ATXVUbij00EtYjK8WR3XzCWimTm/3mHS2J1iwzEgOzeOgTLLMLPq/
         /7GbKS0lkMBVphjyMXqRLIXfEUdLRtSZKUAXRtgc+mAbx0mvajV8AAipP/xnfxyEKN
         Xc8w9L1iDItwSqh4fDPtXYR0fKp3ObUJwOpMZmcc=
Date:   Mon, 13 Jul 2020 17:19:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-vmscan-consistent-update-to-pgrefill.patch added to
 -mm tree
Message-ID: <20200714001929.6757A27r_%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: consistent update to pgrefill
has been added to the -mm tree.  Its filename is
     mm-vmscan-consistent-update-to-pgrefill.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-consistent-update-to-pgrefill.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-consistent-update-to-pgrefill.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: vmscan: consistent update to pgrefill

The vmstat pgrefill is useful together with pgscan and pgsteal stats to
measure the reclaim efficiency.  However vmstat's pgrefill is not updated
consistently at system level.  It gets updated for both global and memcg
reclaim however pgscan and pgsteal are updated for only global reclaim. 
So, update pgrefill only for global reclaim.  If someone is interested in
the stats representing both system level as well as memcg level reclaim,
then consult the root memcg's memory.stat instead of /proc/vmstat.

Link: http://lkml.kernel.org/r/20200711011459.1159929-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-consistent-update-to-pgrefill
+++ a/mm/vmscan.c
@@ -2030,7 +2030,8 @@ static void shrink_active_list(unsigned
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 
-	__count_vm_events(PGREFILL, nr_scanned);
+	if (!cgroup_reclaim(sc))
+		__count_vm_events(PGREFILL, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&pgdat->lru_lock);
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcontrol-account-kernel-stack-per-node.patch
mm-vmscan-consistent-update-to-pgrefill.patch

