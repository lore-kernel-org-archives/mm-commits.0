Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C52C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 17:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240827AbiERRUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 13:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbiERRUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 13:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F59B1BDD96
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 10:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B85C6179B
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 17:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2F5C385A5;
        Wed, 18 May 2022 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652894415;
        bh=8QE6EPYVjkjuIEYl4sW1qn2qtuGJIHWbe10bMO9/KcA=;
        h=Date:To:From:Subject:From;
        b=RC0HKvi40IfyPB8ff9qgMCa5i281GCA2SvArAcKfAbnJMqai20dfnSUuBjqONE17E
         +QjSNVnwt8IBz+mgpcVgr4PyBrNDls3shr1E/qMrkLtD8lVfZlQVyn2M5mbUWLdQ+/
         WLH0wEVBIERWy6d+P1Q3REhprmQ0RIwDbmYVDmZc=
Date:   Wed, 18 May 2022 10:20:14 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-remove-protection-from-top-level-memcg.patch added to mm-unstable branch
Message-Id: <20220518172014.EA2F5C385A5@smtp.kernel.org>
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
Date: Wed, 18 May 2022 18:18:58 +0200

The reclaim is triggered by memory limit in a subtree, therefore the
testcase does not need configured protection against external reclaim.

Also, correct respective comments

Link: https://lkml.kernel.org/r/20220518161859.21565-5-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Cc: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-remove-protection-from-top-level-memcg
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -247,7 +247,7 @@ static int cg_test_proc_killed(const cha
 
 /*
  * First, this test creates the following hierarchy:
- * A       memory.min = 50M,  memory.max = 200M
+ * A       memory.min = 0,    memory.max = 200M
  * A/B     memory.min = 50M
  * A/B/C   memory.min = 75M,  memory.current = 50M
  * A/B/D   memory.min = 25M,  memory.current = 50M
@@ -257,7 +257,7 @@ static int cg_test_proc_killed(const cha
  * Usages are pagecache, but the test keeps a running
  * process in every leaf cgroup.
  * Then it creates A/G and creates a significant
- * memory pressure in it.
+ * memory pressure in A.
  *
  * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
@@ -338,8 +338,6 @@ static int test_memcg_min(const char *ro
 			      (void *)(long)fd);
 	}
 
-	if (cg_write(parent[0], "memory.min", "50M"))
-		goto cleanup;
 	if (cg_write(parent[1], "memory.min", "50M"))
 		goto cleanup;
 	if (cg_write(children[0], "memory.min", "75M"))
@@ -407,7 +405,7 @@ cleanup:
 
 /*
  * First, this test creates the following hierarchy:
- * A       memory.low = 50M,  memory.max = 200M
+ * A       memory.low = 0,    memory.max = 200M
  * A/B     memory.low = 50M
  * A/B/C   memory.low = 75M,  memory.current = 50M
  * A/B/D   memory.low = 25M,  memory.current = 50M
@@ -495,8 +493,6 @@ static int test_memcg_low(const char *ro
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
selftests-memcg-factor-out-common-parts-of-memorylowmin-tests.patch

