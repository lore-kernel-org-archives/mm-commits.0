Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BE9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbiE0QfQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354169AbiE0QfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90B23B2AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0E38CE251B
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CE3C385A9;
        Fri, 27 May 2022 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669305;
        bh=sl740DE1+/qe5bLFvS3d+cJJsOwVwfuGoUL1EEOhbeQ=;
        h=Date:To:From:Subject:From;
        b=ZwQ4ya2VsE8Y2dbmxZoKmlaAuElLemmXRWp3VLY0RWamVRRKEOSNS/Gu9OjaJqIBZ
         u0njJB/OuYROr6CJCHnyV4rVVQKuQuZOhrX9jjIvFawoLqCjksKPH0LySiaAady7Zj
         WItBBzCfxuPdcbu0vJcxprXrt7ffDjfHcAn699fA=
Date:   Fri, 27 May 2022 09:35:04 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch removed from -mm tree
Message-Id: <20220527163505.51CE3C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: memcg: adjust expected reclaim values of protected cgroups
has been removed from the -mm tree.  Its filename was
     selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Koutný <mkoutny@suse.com>
Subject: selftests: memcg: adjust expected reclaim values of protected cgroups
Date: Wed, 18 May 2022 18:18:57 +0200

The numbers are not easy to derive in a closed form (certainly mere
protections ratios do not apply), therefore use a simulation to obtain
expected numbers.

Link: https://lkml.kernel.org/r/20220518161859.21565-4-mkoutny@suse.com
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Vernet <void@manifault.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Richard Palethorpe <rpalethorpe@suse.de>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                       |    1 
 tools/testing/selftests/cgroup/memcg_protection.m |   89 ++++++++++++
 tools/testing/selftests/cgroup/test_memcontrol.c  |   29 ++-
 3 files changed, 107 insertions(+), 12 deletions(-)

--- a/MAINTAINERS~selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups
+++ a/MAINTAINERS
@@ -5029,6 +5029,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_kmem.c
 F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
--- /dev/null
+++ a/tools/testing/selftests/cgroup/memcg_protection.m
@@ -0,0 +1,89 @@
+% SPDX-License-Identifier: GPL-2.0
+%
+% run as: octave-cli memcg_protection.m
+%
+% This script simulates reclaim protection behavior on a single level of memcg
+% hierarchy to illustrate how overcommitted protection spreads among siblings
+% (as it depends also on their current consumption).
+%
+% Simulation assumes siblings consumed the initial amount of memory (w/out
+% reclaim) and then the reclaim starts, all memory is reclaimable, i.e. treated
+% same. It simulates only non-low reclaim and assumes all memory.min = 0.
+%
+% Input configurations
+% --------------------
+% E number	parent effective protection
+% n vector	nominal protection of siblings set at the given level (memory.low)
+% c vector	current consumption -,,- (memory.current)
+
+% example from testcase (values in GB)
+E = 50 / 1024;
+n = [75 25 0 500 ] / 1024;
+c = [50 50 50 0] / 1024;
+
+% Reclaim parameters
+% ------------------
+
+% Minimal reclaim amount (GB)
+cluster = 32*4 / 2**20;
+
+% Reclaim coefficient (think as 0.5^sc->priority)
+alpha = .1
+
+% Simulation parameters
+% ---------------------
+epsilon = 1e-7;
+timeout = 1000;
+
+% Simulation loop
+% ---------------
+
+ch = [];
+eh = [];
+rh = [];
+
+for t = 1:timeout
+        % low_usage
+        u = min(c, n);
+        siblings = sum(u);
+
+        % effective_protection()
+        protected = min(n, c);                % start with nominal
+        e = protected * min(1, E / siblings); % normalize overcommit
+
+        % recursive protection
+        unclaimed = max(0, E - siblings);
+        parent_overuse = sum(c) - siblings;
+        if (unclaimed > 0 && parent_overuse > 0)
+                overuse = max(0, c - protected);
+                e += unclaimed * (overuse / parent_overuse);
+        endif
+
+        % get_scan_count()
+        r = alpha * c;             % assume all memory is in a single LRU list
+
+        % commit 1bc63fb1272b ("mm, memcg: make scan aggression always exclude protection")
+        sz = max(e, c);
+        r .*= (1 - (e+epsilon) ./ (sz+epsilon));
+
+        % uncomment to debug prints
+        % e, c, r
+
+        % nothing to reclaim, reached equilibrium
+        if max(r) < epsilon
+                break;
+        endif
+
+        % SWAP_CLUSTER_MAX roundup
+        r = max(r, (r > epsilon) .* cluster);
+        % XXX here I do parallel reclaim of all siblings
+        % in reality reclaim is serialized and each sibling recalculates own residual
+        c = max(c - r, 0);
+
+        ch = [ch ; c];
+        eh = [eh ; e];
+        rh = [rh ; r];
+endfor
+
+t
+c, e
--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -248,7 +248,7 @@ static int cg_test_proc_killed(const cha
 /*
  * First, this test creates the following hierarchy:
  * A       memory.min = 50M,  memory.max = 200M
- * A/B     memory.min = 50M,  memory.current = 50M
+ * A/B     memory.min = 50M
  * A/B/C   memory.min = 75M,  memory.current = 50M
  * A/B/D   memory.min = 25M,  memory.current = 50M
  * A/B/E   memory.min = 0,    memory.current = 50M
@@ -259,10 +259,13 @@ static int cg_test_proc_killed(const cha
  * Then it creates A/G and creates a significant
  * memory pressure in it.
  *
+ * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
- * A/B/C  memory.current ~= 33M
- * A/B/D  memory.current ~= 17M
- * A/B/F  memory.current ~= 0
+ * A/B/C  memory.current ~= 29M
+ * A/B/D  memory.current ~= 21M
+ * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current  = 0
+ * (for origin of the numbers, see model in memcg_protection.m.)
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available, and checks
@@ -365,10 +368,10 @@ static int test_memcg_min(const char *ro
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(33), 10))
+	if (!values_close(c[0], MB(29), 10))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(17), 10))
+	if (!values_close(c[1], MB(21), 10))
 		goto cleanup;
 
 	if (c[3] != 0)
@@ -405,7 +408,7 @@ cleanup:
 /*
  * First, this test creates the following hierarchy:
  * A       memory.low = 50M,  memory.max = 200M
- * A/B     memory.low = 50M,  memory.current = 50M
+ * A/B     memory.low = 50M
  * A/B/C   memory.low = 75M,  memory.current = 50M
  * A/B/D   memory.low = 25M,  memory.current = 50M
  * A/B/E   memory.low = 0,    memory.current = 50M
@@ -417,9 +420,11 @@ cleanup:
  *
  * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
- * A/B/   memory.current ~= 33M
- * A/B/D  memory.current ~= 17M
- * A/B/F  memory.current ~= 0
+ * A/B/C  memory.current ~= 29M
+ * A/B/D  memory.current ~= 21M
+ * A/B/E  memory.current ~= 0
+ * A/B/F  memory.current  = 0
+ * (for origin of the numbers, see model in memcg_protection.m.)
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available,
@@ -512,10 +517,10 @@ static int test_memcg_low(const char *ro
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(33), 10))
+	if (!values_close(c[0], MB(29), 10))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(17), 10))
+	if (!values_close(c[1], MB(21), 10))
 		goto cleanup;
 
 	if (c[3] != 0)
_

Patches currently in -mm which might be from mkoutny@suse.com are


