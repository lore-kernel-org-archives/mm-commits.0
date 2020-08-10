Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E518BC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AE1206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027244;
	bh=putPR2xNAkGIGsixvwZw3M/bF/d6azam6Sf+s230ANY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JX4lmG+j+kqueUCgMYda3fgyerSlOLxiEs3YNI/NopZ3uKtuEHvfIXGvaPTkCnPIZ
	 XOfX0OxE0QBoGV0EGQuBiOdd7DyyEDHSfSDbDe0IqRACsueAP2r1IhkgybY25lUk6D
	 ejHwwUTjtImQV4ZeBL9ZmMALDyKe6DPPCswXgeDU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCko (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 874FE2065D;
        Mon, 10 Aug 2020 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027243;
        bh=putPR2xNAkGIGsixvwZw3M/bF/d6azam6Sf+s230ANY=;
        h=Date:From:To:Subject:From;
        b=JQoQRvxc7li3RIfXz2P/8qPqyUIeK45KZLFnVMpOk61lM4oVUAzyAJFDnSnVIHrtt
         x2vQB2Gd/qpykGWYMjHinsKsY56X7WzqVJtS3lLVCjd8479zqBzVSNt4D5AtrFtKja
         3vLdjvN+SRoZ1FGUtSA8xKUjCd+yGAKna8I4CYG4=
Date:   Sun, 09 Aug 2020 19:40:43 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] mm-vmscan-consistent-update-to-pgrefill.patch
 removed from -mm tree
Message-ID: <20200810024043.yOHz8M-SI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: consistent update to pgrefill
has been removed from the -mm tree.  Its filename was
     mm-vmscan-consistent-update-to-pgrefill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


