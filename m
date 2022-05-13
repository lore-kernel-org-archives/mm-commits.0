Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681A1C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383564AbiEMTJl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383566AbiEMTJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E704344F5
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12544B83132
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6637C34100;
        Fri, 13 May 2022 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652468974;
        bh=LIKXl3AF7t4fXu5N7fE99JMRiGruGUdN80t5eBds5dI=;
        h=Date:To:From:Subject:From;
        b=sNu2FpK+tHf+/67qtMdHSZXX1NBuPU2AncgumN5a1MznN4BxdeL2l8JoylWRsBglh
         s9g1OPT82w+vNlwiuKx/5Mxi0WikuicWaU/L7LNFnITg+P8WxDni+DEgfnH6skxov9
         2SyadfO/I7tgb6Yi/oMfMzTFfBVX92C+DNXL7bxw=
Date:   Fri, 13 May 2022 12:09:34 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, rpalethorpe@suse.de, roman.gushchin@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch added to mm-unstable branch
Message-Id: <20220513190934.B6637C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memcg: adjust expected reclaim values of protected cgroups
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch

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
Subject: selftests: memcg: adjust expected reclaim values of protected cgroups
Date: Fri, 13 May 2022 19:18:10 +0200

The numbers are not easy to derive in a closed form (certainly mere
protections ratios do not apply), therefore use a simulation to obtain
expected numbers.

The new values make the protection tests succeed more precisely.

	% run as: octave-cli script
	%
	% Input configurations
	% -------------------
	% E parent effective protection
	% n nominal protection of siblings set at the givel level
	% c current consumption -,,-

	% example from testcase (values in GB)
	E = 50 / 1024;
	n = [75 25 0 500 ] / 1024;
	c = [50 50 50 0] / 1024;

	% Reclaim parameters
	% ------------------

	% Minimal reclaim amount (GB)
	cluster = 32*4 / 2**20;

	% Reclaim coefficient (think as 0.5^sc->priority)
	alpha = .1

	% Simulation parameters
	% ---------------------
	epsilon = 1e-7;
	timeout = 1000;

	% Simulation loop
	% ---------------------
	% Simulation assumes siblings consumed the initial amount of memory (w/out
	% reclaim) and then the reclaim starts, all memory is reclaimable, i.e. treated
	% same. It simulates only non-low reclaim and assumes all memory.min = 0.

	ch = [];
	eh = [];
	rh = [];

	for t = 1:timeout
		% low_usage
		u = min(c, n);
		siblings = sum(u);

		% effective_protection()
		protected = min(n, c);                % start with nominal
		e = protected * min(1, E / siblings); % normalize overcommit

		% recursive protection
		unclaimed = max(0, E - siblings);
		parent_overuse = sum(c) - siblings;
		if (unclaimed > 0 && parent_overuse > 0)
			overuse = max(0, c - protected);
			e += unclaimed * (overuse / parent_overuse);
		endif

		% get_scan_count()
		r = alpha * c;             % assume all memory is in a single LRU list

		% commit 1bc63fb1272b ("mm, memcg: make scan aggression always exclude protection")
		sz = max(e, c);
		r .*= (1 - (e+epsilon) ./ (sz+epsilon));

		% uncomment to debug prints
		% e, c, r

		% nothing to reclaim, reached equilibrium
		if max(r) < epsilon
			break;
		endif

		% SWAP_CLUSTER_MAX
		r = max(r, (r > epsilon) .* cluster);
		% XXX here I do parallel reclaim of all siblings
		% in reality reclaim is serialized and each sibling recalculates own residual
		c = max(c - r, 0);

		ch = [ch ; c];
		eh = [eh ; e];
		rh = [rh ; r];
	endfor

	t
	c, e

Link: https://lkml.kernel.org/r/20220513171811.730-4-mkoutny@suse.com
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

 tools/testing/selftests/cgroup/test_memcontrol.c |   20 ++++++-------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -260,9 +260,9 @@ static int cg_test_proc_killed(const cha
  * memory pressure in it.
  *
  * A/B    memory.current ~= 50M
- * A/B/C  memory.current ~= 33M
- * A/B/D  memory.current ~= 17M
- * A/B/F  memory.current ~= 0
+ * A/B/C  memory.current ~= 29M
+ * A/B/D  memory.current ~= 21M
+ * A/B/E  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available, and checks
@@ -365,10 +365,10 @@ static int test_memcg_min(const char *ro
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(33), 10))
+	if (!values_close(c[0], MB(29), 10))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(17), 10))
+	if (!values_close(c[1], MB(21), 10))
 		goto cleanup;
 
 	if (c[3] != 0)
@@ -417,9 +417,9 @@ cleanup:
  *
  * Then it checks actual memory usages and expects that:
  * A/B    memory.current ~= 50M
- * A/B/   memory.current ~= 33M
- * A/B/D  memory.current ~= 17M
- * A/B/F  memory.current ~= 0
+ * A/B/   memory.current ~= 29M
+ * A/B/D  memory.current ~= 21M
+ * A/B/E  memory.current ~= 0
  *
  * After that it tries to allocate more than there is
  * unprotected memory in A available,
@@ -512,10 +512,10 @@ static int test_memcg_low(const char *ro
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

selftests-memcg-fix-compilation.patch
selftests-memcg-expect-no-low-events-in-unprotected-sibling.patch
selftests-memcg-adjust-expected-reclaim-values-of-protected-cgroups.patch
selftests-memcg-remove-protection-from-top-level-memcg.patch

