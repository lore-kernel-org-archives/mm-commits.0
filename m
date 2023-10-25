Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4307BC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 21:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjJYVs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 17:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjJYVs0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 17:48:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDAA185
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 14:48:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CC2C433C7;
        Wed, 25 Oct 2023 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698270504;
        bh=BV9xg9kc8Y+lR7uLpf0Nmuibq+gcT8egrAAQGZ6Qo1I=;
        h=Date:To:From:Subject:From;
        b=cIcaD/OnE3LNUU9bMRliWbHRqR9JH2USqblrLpFfjx4/1JDwC/X0a8td0LAwfwb/9
         QFB8yj3Xavt7hvshYDzeJ8dkk1TVVy9N+wkIKAN9suj/kYffW/JCfevjCHiz4qQgmb
         pRKXwMwqwTD9JjjdeVCQFtqqMqVAoAaXtga4ZgL4=
Date:   Wed, 25 Oct 2023 14:48:24 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch removed from -mm tree
Message-Id: <20231025214824.B9CC2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg, oom: unmark under_oom after the oom killer is done
has been removed from the -mm tree.  Its filename was
     memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: memcg, oom: unmark under_oom after the oom killer is done
Date: Sat, 23 Sep 2023 08:17:39 +0000

When application in userland receives oom notification from kernel and
reads the oom_control file, it's confusing that under_oom is 0 though the
omm killer hasn't finished.  The reason is that under_oom is cleared
before invoking mem_cgroup_out_of_memory(), so move the action that unmark
under_oom after completing oom handler.  Therefore the value of under_oom
won't mislead users.

Link: https://lkml.kernel.org/r/20230923081739.398912-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-oom-unmark-under_oom-after-the-oom-killer-is-done
+++ a/mm/memcontrol.c
@@ -2027,8 +2027,8 @@ static bool mem_cgroup_oom(struct mem_cg
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	mem_cgroup_unmark_under_oom(memcg);
 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
+	mem_cgroup_unmark_under_oom(memcg);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are


