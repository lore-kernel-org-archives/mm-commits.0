Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F186C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 19:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392127AbiDUTdU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 15:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392012AbiDUTco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 15:32:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EDB26C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 12:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550FCB828D0
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 19:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48BFC385A1;
        Thu, 21 Apr 2022 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650569390;
        bh=KNPf3ccnBBf1P8ZHkwH4A76/Ot5pVITMa8V9ypnku6o=;
        h=Date:To:From:Subject:From;
        b=a0ztpE/OYvVO8CRjJz1qAP3l6FdQDeIsIqgSo/XhAnhaKpndeALOnpCN5lbDt466y
         nM4dAB2ZGHm2SThTxi6O0E4GndSvcCRMxKodQjxKaObDxgm6Zhy0cV10uad0vV4bSp
         o8K39GVNVv0cYrS2ZGdAzg7/E8M0bCoO8hEw70Es=
Date:   Thu, 21 Apr 2022 12:29:49 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch added to -mm tree
Message-Id: <20220421192949.E48BFC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove unused private flag of memory.oom_control
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -210,7 +210,6 @@ static struct move_charge_struct {
 enum res_type {
 	_MEM,
 	_MEMSWAP,
-	_OOM_TYPE,
 	_KMEM,
 	_TCP,
 };
@@ -218,8 +217,6 @@ enum res_type {
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
 #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
-/* Used for OOM notifier */
-#define OOM_CONTROL		(0)
 
 /*
  * Iteration constructs for visiting all cgroups (under a tree).  If
@@ -4888,7 +4885,6 @@ static struct cftype mem_cgroup_legacy_f
 		.name = "oom_control",
 		.seq_show = mem_cgroup_oom_control_read,
 		.write_u64 = mem_cgroup_oom_control_write,
-		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
 	{
 		.name = "pressure_level",
_

Patches currently in -mm which might be from lujialin4@huawei.com are

mm-memcontrolc-make-cgroup_memory_noswap-static.patch
mm-memcontrolc-remove-unused-private-flag-of-memoryoom_control.patch

