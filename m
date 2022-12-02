Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD1DC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiLBVEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiLBVEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:04:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625B0EAB71
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:04:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B44B82212
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20ADC433C1;
        Fri,  2 Dec 2022 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670015068;
        bh=JLeec77b+LhFqlJWdMMQycjHLXAWSYUXN7TEIqQC300=;
        h=Date:To:From:Subject:From;
        b=SsRb+JxiNuRvPrzLbu2QCOgr4VA9I6zEYfmOOs+SrgHWx4VVN0FpvyirlmOjtDac5
         1dwfqZkSaPFf7zF13D0UH6uVZQUw0LHaoh5Tr+IpNt1ag7GnHo03YB3+QsquPwITgi
         tT3o3OvGNpOY7oBP0eHNzTEGRb8pDwecVX9LHaZc=
Date:   Fri, 02 Dec 2022 13:04:27 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, vasily.averin@linux.dev, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, chris@chrisdown.name, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch added to mm-unstable branch
Message-Id: <20221202210428.A20ADC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: make sure reclaim target memcg is unprotected
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: make sure reclaim target memcg is unprotected
Date: Fri, 2 Dec 2022 03:15:12 +0000

Make sure that we ignore protection of a memcg that is the target of memcg
reclaim.

Link: https://lkml.kernel.org/r/20221202031512.1365483-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -238,6 +238,8 @@ static int cg_test_proc_killed(const cha
 	return -1;
 }
 
+static bool reclaim_until(const char *memcg, long goal);
+
 /*
  * First, this test creates the following hierarchy:
  * A       memory.min = 0,    memory.max = 200M
@@ -266,6 +268,12 @@ static int cg_test_proc_killed(const cha
  * unprotected memory in A available, and checks that:
  * a) memory.min protects pagecache even in this case,
  * b) memory.low allows reclaiming page cache with low events.
+ *
+ * Then we try to reclaim from A/B/C using memory.reclaim until its
+ * usage reaches 10M.
+ * This makes sure that:
+ * (a) We ignore the protection of the reclaim target memcg.
+ * (b) The previously calculated emin value (~29M) should be dismissed.
  */
 static int test_memcg_protection(const char *root, bool min)
 {
@@ -385,6 +393,9 @@ static int test_memcg_protection(const c
 	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
 
+	if (!reclaim_until(children[0], MB(10)))
+		goto cleanup;
+
 	if (min) {
 		ret = KSFT_PASS;
 		goto cleanup;
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-fix-stale-protection-of-reclaim-target-memcg.patch
selftests-cgroup-refactor-proactive-reclaim-code-to-reclaim_until.patch
selftests-cgroup-make-sure-reclaim-target-memcg-is-unprotected.patch

