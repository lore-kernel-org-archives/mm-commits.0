Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6150C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 18:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiEXSvM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 14:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiEXSvL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 14:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D880192B3
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 11:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 529E8B81A76
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 18:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EC6C34100;
        Tue, 24 May 2022 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653418268;
        bh=k5jsgah7TETed5kYa2N0dkHh4AGyv8U0vBwIelw9ahY=;
        h=Date:To:From:Subject:From;
        b=PdMcFjUKeRPvnWeJ8Ojd03ZDpG+8O7YGocMKv+xsT/uA9+PB1dY20K9uIeN9W5ah7
         i7fSdpvuTVnbLaI2J4WNSSkquVOLqSnGIKlhrtlZlqpQhl8qMhy/Mgr3pxZNpaV6+h
         /8i4+rorF5lQPud8m9wQEfgSSm8h5PKy90I49A/E=
Date:   Tue, 24 May 2022 11:51:07 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        songmuchun@bytedance.com, shuah@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org,
        dan.carpenter@oracle.com, akpm@linux-foundation.org,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch added to mm-unstable branch
Message-Id: <20220524185108.02EC6C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: fix an error handling path in alloc_pagecache_max_30M()
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: cgroup: fix an error handling path in alloc_pagecache_max_30M()
Date: Sun, 22 May 2022 16:18:51 +0200

If the first goto is taken, 'fd' is not opened yet (and is un-initialized).
So a direct return is safer.

Link: https://lkml.kernel.org/r/628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr
Fixes: c1a31a2f7a9c ("cgroup: fix racy check in alloc_pagecache_max_30M() helper function")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Vernet <void@manifault.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -574,7 +574,7 @@ static int alloc_pagecache_max_30M(const
 	high = cg_read_long(cgroup, "memory.high");
 	max = cg_read_long(cgroup, "memory.max");
 	if (high != MB(30) && max != MB(30))
-		goto cleanup;
+		return -1;
 
 	fd = get_temp_fd();
 	if (fd < 0)
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

cgroup-fix-an-error-handling-path-in-alloc_pagecache_max_30m.patch

