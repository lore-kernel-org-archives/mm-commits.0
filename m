Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362BAC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F252A22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781595;
	bh=DRFCcEScmQDmGhb5Lm/X4w55dtL6vDILWoa6JBc/yEw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tCjVrNfv0+9PFiq59UC/kpxsapQ1MS4saQGzusP1WSp7oqfeGn52tKNJ3rD3AjXEK
	 W4rMxO8zE+EhjX9GIWVZiQ+Uzh80NdtHZ+2sF7uQX6jTfNjc+Ul08H/RIfqmLMr/jG
	 j7goVJngbHbJRSX0QwabpNcJRpnZEu5N+EYIQw1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGG0e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A56422CF6;
        Fri,  7 Aug 2020 06:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781593;
        bh=DRFCcEScmQDmGhb5Lm/X4w55dtL6vDILWoa6JBc/yEw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0wmJPurs5alYMTmXme/aBdS7VerirRzLboitYXUK3sPBVs9GQRGOsiQFko8hYSu0O
         xJz3U0NtPajJ1CFoJy8qdXfdNTvYUvrC8lrrie3Anmrf7b179UrzXwuIEedlV4Pl3y
         3AP5dsDD9Tz3GGqP1bIKXaXmfpQchPTfuJhsTsXo=
Date:   Thu, 06 Aug 2020 23:26:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 163/163] mm: vmscan: consistent update to pgrefill
Message-ID: <20200807062632.VjEnptD9e%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
