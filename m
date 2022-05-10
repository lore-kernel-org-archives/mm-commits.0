Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAF0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiEJEUe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiEJESg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19BD246DBA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E46061744
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAEBC385C2;
        Tue, 10 May 2022 04:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156064;
        bh=QcR2CBgMebEu0LG8TcOyJoFLOS8em0ZIt7eACa1AYK4=;
        h=Date:To:From:Subject:From;
        b=A4WWa1KdY+7Hw74rXoJfks29p2y6Vy9Xnrs+NfHiDmOkg4xfar0fYA96h3k4eK9Ob
         kmkJYSoDlLSO1Lz21arvc4yyF/zvk19iGjfZl1vB3A7SrWzfxXOKrVr7Bgc3OwcSjL
         JYpcpegH+3Z9n/VN/A03Bfir+fnGiV1eE2ipQosY=
Date:   Mon, 09 May 2022 21:14:24 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, weixugc@google.com,
        vaibhav@linux.ibm.com, tj@kernel.org, tim.c.chen@linux.intel.com,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, mkoutny@suse.com, mhocko@suse.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, gthelen@google.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, chenwandun@huawei.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch removed from -mm tree
Message-Id: <20220510041424.9DAEBC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix alloc_anon_noexit() instantly freeing memory
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: fix alloc_anon_noexit() instantly freeing memory

Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
the allocated memory. alloc_anon_noexit() is usually used with
cg_run_nowait() to run a process in the background that allocates
memory. It makes sense for the background process to keep the memory
allocated and not instantly free it (otherwise there is no point of
running it in the background).

Link: https://lkml.kernel.org/r/20220425190040.2475377-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutn" <mkoutny@suse.com>
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
@@ -211,13 +211,17 @@ static int alloc_pagecache_50M_noexit(co
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


