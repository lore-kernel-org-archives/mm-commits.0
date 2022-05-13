Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16817C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383575AbiEMTJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383567AbiEMTJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:09:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF70A377EB
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBB362208
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ABBC34100;
        Fri, 13 May 2022 19:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652468976;
        bh=7DeuY2Ps3cEsS1RBDIY7K6wiyGtkdScg2dx9M3vTFA4=;
        h=Date:To:From:Subject:From;
        b=k58Ri3NaPhGFmKSL+Wj2+ZqH+9Bt0p0oVGN1/Y9gwkmJwL18kbQZsBeh/++hxZlAh
         oATuJXJFgOdBsjz92ypDGZaMXaKFv/dnvBDCsVOj6XL1Vkvzz093EP3a1hDv+dWYKv
         SqUCtkqNrR4QM6VXflUeutCcARSRANeDKiAwv1j8=
Date:   Fri, 13 May 2022 12:09:36 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-remove-protection-from-top-level-memcg.patch added to mm-unstable branch
Message-Id: <20220513190936.A1ABBC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: remove protection from top level memcg
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memcg-remove-protection-from-top-level-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-remove-protection-from-top-level-memcg.patch

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
Subject: selftests: memcg: remove protection from top level memcg
Date: Fri, 13 May 2022 19:18:11 +0200

The reclaim is triggered by memory limit in a subtree, therefore the
testcase does not need configured protection against external reclaim.

Also, correct/deduplicate respective comments.

Link: https://lkml.kernel.org/r/20220513171811.730-5-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Cc: David Vernet <void@manifault.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-remove-protection-from-top-level-memcg
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -247,7 +247,7 @@ static int cg_test_proc_killed(const cha
 
 /*
  * First, this test creates the following hierarchy:
- * A       memory.min = 50M,  memory.max = 200M
+ * A       memory.min = 0,    memory.max = 200M
  * A/B     memory.min = 50M,  memory.current = 50M
  * A/B/C   memory.min = 75M,  memory.current = 50M
  * A/B/D   memory.min = 25M,  memory.current = 50M
@@ -257,7 +257,7 @@ static int cg_test_proc_killed(const cha
  * Usages are pagecache, but the test keeps a running
  * process in every leaf cgroup.
  * Then it creates A/G and creates a significant
- * memory pressure in it.
+ * memory pressure in A.
  *
  * A/B    memory.current ~= 50M
  * A/B/C  memory.current ~= 29M
@@ -335,8 +335,6 @@ static int test_memcg_min(const char *ro
 			      (void *)(long)fd);
 	}
 
-	if (cg_write(parent[0], "memory.min", "50M"))
-		goto cleanup;
 	if (cg_write(parent[1], "memory.min", "50M"))
 		goto cleanup;
 	if (cg_write(children[0], "memory.min", "75M"))
@@ -404,8 +402,8 @@ cleanup:
 
 /*
  * First, this test creates the following hierarchy:
- * A       memory.low = 50M,  memory.max = 200M
- * A/B     memory.low = 50M,  memory.current = 50M
+ * A       memory.low = 0,    memory.max = 200M
+ * A/B     memory.low = 50M,  memory.current = ...
  * A/B/C   memory.low = 75M,  memory.current = 50M
  * A/B/D   memory.low = 25M,  memory.current = 50M
  * A/B/E   memory.low = 0,    memory.current = 50M
@@ -490,8 +488,6 @@ static int test_memcg_low(const char *ro
 			goto cleanup;
 	}
 
-	if (cg_write(parent[0], "memory.low", "50M"))
-		goto cleanup;
 	if (cg_write(parent[1], "memory.low", "50M"))
 		goto cleanup;
 	if (cg_write(children[0], "memory.low", "75M"))
_

Patches currently in -mm which might be from mkoutny@suse.com are

selftests-memcg-fix-compilation.patch
selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch
selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch
selftests-memcg-remove-protection-from-top-level-memcg.patch

