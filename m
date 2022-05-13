Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51572C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383563AbiEMTJh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383565AbiEMTJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:09:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D123BA7C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC13FB830F6
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2D2C34100;
        Fri, 13 May 2022 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652468970;
        bh=PJAZko8IdU78vtGeqtjbSB4rKKs10C2kc09qb7jMEIE=;
        h=Date:To:From:Subject:From;
        b=qB8vRggTl16a8gGC+7GOqGygmbKPFL3JU13W8zp4vCqeb25/eMOtpI5vFnrAp/vHd
         /c2rgNiz1E0idhKj2g8Mrc2/QHa5Zei0Fkr7rEaa1y1RdtlPZlwHCiMqKD1CJaTUtF
         c27dNKdNC0pCMrbvKsRu7RdwxGAdfKBgA0o4KZ8E=
Date:   Fri, 13 May 2022 12:09:29 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-fix-compilation.patch added to mm-unstable branch
Message-Id: <20220513190930.8D2D2C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: Fix compilation
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memcg-fix-compilation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-fix-compilation.patch

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
From: Michal Koutný <mkoutny@suse.com>
Subject: selftests: memcg: Fix compilation
Date: Fri, 13 May 2022 19:18:08 +0200

Patch series "memcontrol selftests fixups".

Simple patches to make memcontrol selftests check the events behavior we
had consensus about (test_memcg_low fails)


This patch (of 4):

This fixes mis-applied changes from commit 72b1e03aa725 ("cgroup:
account for memory_localevents in test_memcg_oom_group_leaf_events()").

Link: https://lkml.kernel.org/r/20220513171811.730-1-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20220513171811.730-2-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   25 +++++++------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-fix-compilation
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1241,7 +1241,16 @@ static int test_memcg_oom_group_leaf_eve
 	if (cg_read_key_long(child, "memory.events", "oom_kill ") <= 0)
 		goto cleanup;
 
-	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <= 0)
+	parent_oom_events = cg_read_key_long(
+			parent, "memory.events", "oom_kill ");
+	/*
+	 * If memory_localevents is not enabled (the default), the parent should
+	 * count OOM events in its children groups. Otherwise, it should not
+	 * have observed any events.
+	 */
+	if (has_localevents && parent_oom_events != 0)
+		goto cleanup;
+	else if (!has_localevents && parent_oom_events <= 0)
 		goto cleanup;
 
 	ret = KSFT_PASS;
@@ -1349,20 +1358,14 @@ static int test_memcg_oom_group_score_ev
 	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
 		goto cleanup;
 
-	parent_oom_events = cg_read_key_long(
-			parent, "memory.events", "oom_kill ");
-	/*
-	 * If memory_localevents is not enabled (the default), the parent should
-	 * count OOM events in its children groups. Otherwise, it should not
-	 * have observed any events.
-	 */
-	if ((has_localevents && parent_oom_events == 0) ||
-	     parent_oom_events > 0)
-		ret = KSFT_PASS;
+	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") != 3)
+		FAIL(cleanup);
 
 	if (kill(safe_pid, SIGKILL))
 		goto cleanup;
 
+	ret = KSFT_PASS;
+
 cleanup:
 	if (memcg)
 		cg_destroy(memcg);
_

Patches currently in -mm which might be from mkoutny@suse.com are

selftests-memcg-fix-compilation.patch
selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch
selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch
selftests-memcg-remove-protection-from-top-level-memcg.patch

