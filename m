Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E53C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 22:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiDVWrS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbiDVWqt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 18:46:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138852EFF03
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 14:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB092B83296
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 21:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BCAC385AC;
        Fri, 22 Apr 2022 21:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650663472;
        bh=gtHCaHxqOQkWMMNKnWJhKkbMWD5Ph3ECKnfjzpJwkBs=;
        h=Date:To:From:Subject:From;
        b=jC8vmAe1f9jGocNO0u0VFaSFTuZfrTrz1oHV+mWYg9bfhJCkJtNRoQju/CsebcvPh
         TTgjbu173NZOk3c/ZUjao5cQJ+w8f1NbBgW+AF1+8krWyFjRYlgIEUSZrWw/kNr5IH
         T+vPx2MmYPQ/1ms+gQ9gC1MmMsEbl2Q9K14d2ETg=
Date:   Fri, 22 Apr 2022 14:37:51 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, weixugc@google.com,
        vaibhav@linux.ibm.com, tj@kernel.org, tim.c.chen@linux.intel.com,
        shuah@kernel.org, shakeelb@google.com, schatzberg.dan@gmail.com,
        roman.gushchin@linux.dev, rientjes@google.com, mkoutny@suse.com,
        mhocko@suse.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        gthelen@google.com, dave.hansen@linux.intel.com, corbet@lwn.net,
        chenwandun@huawei.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch added to -mm tree
Message-Id: <20220422213752.64BCAC385AC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix alloc_anon_noexit() instantly freeing memory
has been added to the -mm tree.  Its filename is
     selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: fix alloc_anon_noexit() instantly freeing memory

Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
the allocated memory.  alloc_anon_noexit() is usually used with
cg_run_nowait() to run a process in the background that allocates memory. 
It makes sense for the background process to keep the memory allocated and
not instantly free it (otherwise there is no point of running it in the
background).

Link: https://lkml.kernel.org/r/20220421234426.3494842-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -214,13 +214,17 @@ static int alloc_pagecache_50M_noexit(co
 static int alloc_anon_noexit(const char *cgroup, void *arg)
 {
 	int ppid = getppid();
+	size_t size = (unsigned long)arg;
+	char *buf, *ptr;
 
-	if (alloc_anon(cgroup, arg))
-		return -1;
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
 
 	while (getppid() == ppid)
 		sleep(1);
 
+	free(buf);
 	return 0;
 }
 
_

Patches currently in -mm which might be from yosryahmed@google.com are

selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch
selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch
selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

