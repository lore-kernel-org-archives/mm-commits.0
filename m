Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F20BC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiEJEPP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiEJEOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB977766D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D0BB81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1E2C385C2;
        Tue, 10 May 2022 04:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155843;
        bh=P55EwZeA4PaWMvqMkegr3wtRRgyRuSUzMS2BZtrLNGg=;
        h=Date:To:From:Subject:From;
        b=VR0RZjiiG9LDT6Lw2etBgpyKWvGDiITpuIcyNcCAPRyjW7oZ7mU1dFEgfK86jle3t
         n8IwRMv2upJN9JQIIdMlYJZI3gX9aO3UE4Yupi14KosHiR8qKQwO4i5jsIYjZcl5lU
         IkmUa3NDu1lYixfCvAgl14/ylsS2RmoNn0mO7nhQ=
Date:   Mon, 09 May 2022 21:10:42 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftests-memcg-update-the-oom-group-leaf-events-test.patch removed from -mm tree
Message-Id: <20220510041043.0C1E2C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftests: memcg: update the oom group leaf events test
has been removed from the -mm tree.  Its filename was
     kselftests-memcg-update-the-oom-group-leaf-events-test.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: kselftests: memcg: update the oom group leaf events test

Patch series "mm: memcg kselftests fixes".


This patch (of 4):

Commit 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events") made
memory.events recursive: all events are propagated upwards by the tree. 
It was a change in semantics.

It broke the oom group leaf events test: it assumes that after an OOM the
oom_kill counter is zero on parent's level.

Let's adjust the test: it should have similar expectations for the child
and parent levels.

The test passes after this fix.

Link: https://lkml.kernel.org/r/20220415000133.3955987-2-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20220415000133.3955987-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: David Vernet <void@manifault.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~kselftests-memcg-update-the-oom-group-leaf-events-test
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1079,7 +1079,8 @@ cleanup:
 /*
  * This test disables swapping and tries to allocate anonymous memory
  * up to OOM with memory.group.oom set. Then it checks that all
- * processes in the leaf (but not the parent) were killed.
+ * processes in the leaf were killed. It also checks that oom_events
+ * were propagated to the parent level.
  */
 static int test_memcg_oom_group_leaf_events(const char *root)
 {
@@ -1122,7 +1123,7 @@ static int test_memcg_oom_group_leaf_eve
 	if (cg_read_key_long(child, "memory.events", "oom_kill ") <= 0)
 		goto cleanup;
 
-	if (cg_read_key_long(parent, "memory.events", "oom_kill ") != 0)
+	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <= 0)
 		goto cleanup;
 
 	ret = KSFT_PASS;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


