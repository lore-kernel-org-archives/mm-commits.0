Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4752CE7A95
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjIYPd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjIYPd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:33:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEFC90
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:33:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10FFC433C9;
        Mon, 25 Sep 2023 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695656000;
        bh=MPSg8HBywvl9ues/6mr5cmEbzJa8whqJD36aFvo0cEg=;
        h=Date:To:From:Subject:From;
        b=MNPeJD3BxRlTNgAMjWnYfmH9g6Uca+UbbMHCNhND0CUulYboGePfzTdJ63wShj3Pt
         bK2eQv4L/IMlXLrZqewdwH3kifNx5fIoBp8DKvW2o5004vTvWHcVZyXkuHNpkcM487
         g49jTlb/A9bcgcp5wONHmoMuMtNts82KU8wJ5PHU=
Date:   Mon, 25 Sep 2023 08:33:19 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch added to mm-unstable branch
Message-Id: <20230925153319.F10FFC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, oom: unmark under_oom after the oom killer is done
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-oom-unmark-under_oom-after-the-oom-killer-is-done
+++ a/mm/memcontrol.c
@@ -2006,8 +2006,8 @@ static bool mem_cgroup_oom(struct mem_cg
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	mem_cgroup_unmark_under_oom(memcg);
 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
+	mem_cgroup_unmark_under_oom(memcg);
 
 	if (locked)
 		mem_cgroup_oom_unlock(memcg);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

memcg-oom-unmark-under_oom-after-the-oom-killer-is-done.patch

