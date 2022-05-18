Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E55C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 17:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbiERRUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 13:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240806AbiERRUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 13:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F81A04A5
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 10:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D63861799
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 17:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B77C385A5;
        Wed, 18 May 2022 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652894408;
        bh=nKd8QIYVtcN4lEp4UXIMV25/0MBxJEfWz0mB4Q7wD3A=;
        h=Date:To:From:Subject:From;
        b=jAe1JPOu/VJrc9ZqiXsI0Rthm96JRXz/LtRNpyuNK2ryreGRHFdfRQ/DfrRtAG46E
         L7I+HlrSYi9TFyndidmAOBVOosQjoZ0MegRdssXfEXVjM/ICvAvkJ5853Kzf4nTwzE
         mSTkvHZUQMnvqistEIKS5B0Lu0IdT0PJEPyBasJc=
Date:   Wed, 18 May 2022 10:20:07 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-fix-compilation.patch added to mm-unstable branch
Message-Id: <20220518172008.73B77C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: fix compilation
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
Subject: selftests: memcg: fix compilation
Date: Wed, 18 May 2022 18:18:55 +0200

Patch series "memcontrol selftests fixups", v2.

Flushing the patches to make memcontrol selftests check the events
behavior we had consensus about (test_memcg_low fails).

(test_memcg_reclaim, test_memcg_swap_max fail for me now but it's present
even before the refactoring.)

The two bigger changes are:
- adjustment of the protected values to make tests succeed with the given
  tolerance,
- both test_memcg_low and test_memcg_min check protection of memory in
  populated cgroups (actually as per Documentation/admin-guide/cgroup-v2.rst
  memory.min should not apply to empty cgroups, which is not the case
  currently. Therefore I unified tests with the populated case in order to to
  bring more broken tests).


This patch (of 5):

This fixes mis-applied changes from commit 72b1e03aa725 ("cgroup: account
for memory_localevents in test_memcg_oom_group_leaf_events()").

Link: https://lkml.kernel.org/r/20220518161859.21565-1-mkoutny@suse.com
Link: https://lkml.kernel.org/r/20220518161859.21565-2-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: David Vernet <void@manifault.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Cc: Shakeel Butt <shakeelb@google.com>
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
+		goto cleanup;
 
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
selftests-memcg-factor-out-common-parts-of-memorylowmin-tests.patch

