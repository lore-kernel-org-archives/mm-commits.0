Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5C94502A
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055651; cv=none; b=UFJE1f/c5iTdX5Au9m9JTFqAvEJh/7sLh7W9IDjmh+AqXjMpTdvK2rwEwzbr++88rETblfV0ed0MSelPw65fA6qUwtoRaXfimfss1aiH2iQ1c03Fv8GPxGoXf1OOySkQ5masTQSXLjY3yTFZYm3jtj0IT1CkgYVukIoT82vtEjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055651; c=relaxed/simple;
	bh=rg5g+Qb30ph629DRDsiyIuFhYP6e1w0vLPZRWCFFoIY=;
	h=Date:To:From:Subject:Message-Id; b=pR/IT6YGPBKSGH0dKxIQlaEDsR16LuEB6griBvUYNoMal/7f2HGKKwf/3WytughGfr7PWvwGPoAjNS4ivH+Af9qkwBA6FdnhlGCdw8ylZauOPDC7LLe+Kc27eL2mGuOSW5d2zzfIETm/9PQBbzz4KVdhw7mj7oJ2kuFrxQyFads=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qmopzZ12; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qmopzZ12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501F4C4CEE3;
	Fri, 27 Jun 2025 20:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055651;
	bh=rg5g+Qb30ph629DRDsiyIuFhYP6e1w0vLPZRWCFFoIY=;
	h=Date:To:From:Subject:From;
	b=qmopzZ12bVGofGlKMCyagCZqtjq+KKrKw53By0k90LuOkuW87T08i0YS8Q5p81NhR
	 XbZA4pJ1F776fF4wlWz6pJqBU1NTQ4blTCbn3j2mV4311S2s9VH1hcMSsjQTGZBEqk
	 u82BUZCeM4JbH+3cTfVTR+zKDEPoDRXZyQkr+8iE=
Date: Fri, 27 Jun 2025 13:20:50 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,yunjeong.mun@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-add-parameters-for-node0-memory-usage.patch added to mm-new branch
Message-Id: <20250627202051.501F4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: add parameters for node0 memory usage
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-mtier-add-parameters-for-node0-memory-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-add-parameters-for-node0-memory-usage.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

samples-damon-mtier-add-parameters-for-node0-memory-usage.patch

