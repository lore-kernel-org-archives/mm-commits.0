Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22D61F429C
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450022; cv=none; b=G3iT6VYkX0NYVZEn3uBL4dSL9cCmB2BhR5KRUqNe0h7Et4KEh7J82l4G9bDVLNpDcwvnVcwfuKLCOBZSjDmC4219PrTkJIXD9esbHVjrgWydDkdaWgmRKGMpsxuEL3lKSx/xL/GmuMocraYyDjAI4dLprMN/mi5aZRBH354tufs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450022; c=relaxed/simple;
	bh=aqanAwOR0H1s6biK1+D0vC3YozgfvfRwAa3CajpL0z8=;
	h=Date:To:From:Subject:Message-Id; b=up/s9LJ6GZJli45lwwCaxzpjG0yBRTbiFHLSu+rC3SIOCgkpW+1OGU1DxqUJL7M52ML1lo0CdmpFs8Hm9gv/6/IrbmQL1bKAxHFKWURawJZaHwVhovTN5uRFg095f2LqR3cmnz/gHUbySskE8z2YMKNDjWOo18t39yGXKspJ7Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RD/7fjoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RD/7fjoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5689C4CEE3;
	Sun, 13 Jul 2025 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450021;
	bh=aqanAwOR0H1s6biK1+D0vC3YozgfvfRwAa3CajpL0z8=;
	h=Date:To:From:Subject:From;
	b=RD/7fjozyB63vsqe7A/tsyKcHRnyEzFNr+FYwu3QYyD9+SXgfqbDQs5JsByrUrp5j
	 8clQss1IcblimIl7t4+4ohFPmyLKJpisliBjoJ+pw9N3RSqN9KqbfY0KwUzT5MGkSX
	 wglYrcVB+vDtctb7ngCstQYZ0vjXfqUAjbGGExxc=
Date: Sun, 13 Jul 2025 16:40:20 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,yunjeong.mun@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-add-parameters-for-node0-memory-usage.patch removed from -mm tree
Message-Id: <20250713234021.C5689C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: add parameters for node0 memory usage
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-add-parameters-for-node0-memory-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yunjeong Mun <yunjeong.mun@sk.com>
Subject: samples/damon/mtier: add parameters for node0 memory usage
Date: Fri, 27 Jun 2025 09:33:29 -0700

Change the hard-coded quota goal metric values into sysfs knobs:
`node0_mem_used_bp` and `node0_mem_free_bp`.  These knobs represent the
used and free memory ratio of node0 in basis points (bp, where 1 bp =
0.01%).  As mentioned in [1], this patch is developed under the assumption
that node0 is always the fast-tier in a two-tiers memory setup.

[1] https://lore.kernel.org/linux-mm/20250420194030.75838-8-sj@kernel.org/

Link: https://lkml.kernel.org/r/20250627163329.50997-1-sj@kernel.org
Link: https://patch.msgid.link/20250619050313.1535-1-yunjeong.mun@sk.com
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/samples/damon/mtier.c~samples-damon-mtier-add-parameters-for-node0-memory-usage
+++ a/samples/damon/mtier.c
@@ -24,6 +24,12 @@ module_param(node1_start_addr, ulong, 06
 static unsigned long node1_end_addr __read_mostly;
 module_param(node1_end_addr, ulong, 0600);
 
+static unsigned long node0_mem_used_bp __read_mostly = 9970;
+module_param(node0_mem_used_bp, ulong, 0600);
+
+static unsigned long node0_mem_free_bp __read_mostly = 50;
+module_param(node0_mem_free_bp, ulong, 0600);
+
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp);
 
@@ -112,7 +118,7 @@ static struct damon_ctx *damon_sample_mt
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
-			promote ? 9970 : 50);
+			promote ? node0_mem_used_bp : node0_mem_free_bp);
 	if (!quota_goal)
 		goto free_out;
 	quota_goal->nid = 0;
_

Patches currently in -mm which might be from yunjeong.mun@sk.com are

samples-damon-support-automatic-node-address-detection.patch

