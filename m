Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35FFC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A422177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781313;
	bh=Dl3Dm/Eu5wjiTaKK45eDk/3qF/7YCH/X+eekyMacs4s=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1V2v7Bdn/ZUzX/etlaiUsVDYiP3RQe30TFJt22j+7b68wcDjyH8vXmocbi+I5bb2E
	 WuMRbg+ih6r9g8nWZ0iF9AXP3Bj694NNZzZ26/4HB1m7nI9SsRc9V8d1nXsYBC68J4
	 Mrl6cNqMAGJYeCUPkeXL8YxVgytt6s5K2YEcsGs0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGVx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGGVx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F81D221E5;
        Fri,  7 Aug 2020 06:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781312;
        bh=Dl3Dm/Eu5wjiTaKK45eDk/3qF/7YCH/X+eekyMacs4s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=j3iOVIdvXBQzyDWvr08wtiWnnW4Cg4M1PSsNy8TOkRUJPHJSYcHRDg4DUG9NnbznD
         3e03V4qTC82SCn4p7A5ZxNgcaXzSmQwnlOE2qBR38FWVncDrAVoYYtFC0fAAkufe9f
         WWYOeoKDAYkITKBdRmBo9mSykeG69z/wXzZAVBGo=
Date:   Thu, 06 Aug 2020 23:21:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, domas@fb.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 085/163] mm: memcontrol: avoid workload stalls
 when lowering memory.high
Message-ID: <20200807062151.2JYr5jJgy%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcontrol: avoid workload stalls when lowering memory.high

Memory.high limit is implemented in a way such that the kernel penalizes
all threads which are allocating a memory over the limit.  Forcing all
threads into the synchronous reclaim and adding some artificial delays
allows to slow down the memory consumption and potentially give some time
for userspace oom handlers/resource control agents to react.

It works nicely if the memory usage is hitting the limit from below,
however it works sub-optimal if a user adjusts memory.high to a value way
below the current memory usage.  It basically forces all workload threads
(doing any memory allocations) into the synchronous reclaim and sleep. 
This makes the workload completely unresponsive for a long period of time
and can also lead to a system-wide contention on lru locks.  It can happen
even if the workload is not actually tight on memory and has, for example,
a ton of cold pagecache.

In the current implementation writing to memory.high causes an atomic
update of page counter's high value followed by an attempt to reclaim
enough memory to fit into the new limit.  To fix the problem described
above, all we need is to change the order of execution: try to push the
memory usage under the limit first, and only then set the new high limit.

Link: http://lkml.kernel.org/r/20200709194718.189231-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reported-by: Domas Mituzas <domas@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh
+++ a/mm/memcontrol.c
@@ -6213,8 +6213,6 @@ static ssize_t memory_high_write(struct
 	if (err)
 		return err;
 
-	page_counter_set_high(&memcg->memory, high);
-
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
@@ -6238,6 +6236,8 @@ static ssize_t memory_high_write(struct
 			break;
 	}
 
+	page_counter_set_high(&memcg->memory, high);
+
 	return nbytes;
 }
 
_
