Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D21EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbiEJEPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiEJEOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83A1FA5F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE34B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570D8C385C2;
        Tue, 10 May 2022 04:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155848;
        bh=D9MXBOaXyWYz+VPFK9kYRQyaxRfE3Z49yTlVhf46030=;
        h=Date:To:From:Subject:From;
        b=q1nASgNguOOSJ6mWbAa+jCHRgzwKIKBaAKR84iOVF9inlBAbJN98csctOuYLxyRjR
         T2lza2Z9RUb4dufMqZSL5R7L3ROpLcEa2LIwEDGfsO6xEmZBOjLgwUSya8CvU+f1fK
         ymK4MtNn/s6Ooi3XQRF6vqjbI7+lYJAIgOD4ELHA=
Date:   Mon, 09 May 2022 21:10:47 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch removed from -mm tree
Message-Id: <20220510041048.570D8C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol.c: remove unused private flag of memory.oom_control
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: mm/memcontrol.c: remove unused private flag of memory.oom_control

There is no use for the private value, __OOM_TYPE and OOM notifier
OOM_CONTROL.  Therefore remove them to make the code clean.

Link: https://lkml.kernel.org/r/20220421122755.40899-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control
+++ a/mm/memcontrol.c
@@ -209,7 +209,6 @@ static struct move_charge_struct {
 enum res_type {
 	_MEM,
 	_MEMSWAP,
-	_OOM_TYPE,
 	_KMEM,
 	_TCP,
 };
@@ -217,8 +216,6 @@ enum res_type {
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
 #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
-/* Used for OOM notifier */
-#define OOM_CONTROL		(0)
 
 /*
  * Iteration constructs for visiting all cgroups (under a tree).  If
@@ -4887,7 +4884,6 @@ static struct cftype mem_cgroup_legacy_f
 		.name = "oom_control",
 		.seq_show = mem_cgroup_oom_control_read,
 		.write_u64 = mem_cgroup_oom_control_write,
-		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
 	{
 		.name = "pressure_level",
_

Patches currently in -mm which might be from lujialin4@huawei.com are


