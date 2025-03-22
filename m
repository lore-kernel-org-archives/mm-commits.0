Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9696E12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619826; cv=none; b=YtBVCIP9cy9xLstYFDdq1Xga3Ot8D0CBwNkJ6vBTdTOtQm2Xw/nQp8r2lwEio9Q8PNDpKH6nyOGJIe9OnUTGGxWYkvtRzK8cjUfkWN8r1DjEM1ZMhRn3QCUoqZf1JDDK15RmDvYzCdofhLlJKiWeL7q7AsztAeUUymHLUaF7soE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619826; c=relaxed/simple;
	bh=72U5/8m1S39/yZlxTx1mEJKeKT3ic8l6f1L32oB8v2U=;
	h=Date:To:From:Subject:Message-Id; b=ZGwvv1pRVeiKDLki9rDlDAEcnI4KfwqhF+SgMojpBrAdVM7DXI3l1feLvlGGRPAzzrimFlQ6RwiUheSDUaVexQA86KWTFT/SPUuWEzcoZblckpCSDnIVGn0ZJ+gSUuCXbuUrTCQLJSZd5YICUtovFHJXDDtnkhmS74mhM3MxZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lwHn93BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lwHn93BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62548C4CEDD;
	Sat, 22 Mar 2025 05:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619826;
	bh=72U5/8m1S39/yZlxTx1mEJKeKT3ic8l6f1L32oB8v2U=;
	h=Date:To:From:Subject:From;
	b=lwHn93BU80aBVBDSTJxFrETd1WOwEh7IC6reCC+uGx7/R2GBZKOXsnqnQT88DV9NA
	 HhPMLh9XG5BZ7nXgbL7348GI23Oy/lzWp/ry8HQi4A5YuN41evYA6IzkVxOJEgwLiN
	 jz6n4qzl7bK0eYPyGA7qfDn11VJMgYPxh4JtbDcE=
Date: Fri, 21 Mar 2025 22:03:45 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhockoc@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-avoid-refill_stock-for-root-memcg.patch removed from -mm tree
Message-Id: <20250322050346.62548C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: avoid refill_stock for root memcg
has been removed from the -mm tree.  Its filename was
     memcg-avoid-refill_stock-for-root-memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: avoid refill_stock for root memcg
Date: Wed, 12 Mar 2025 22:48:12 -0700

We never charge the page counters of root memcg, so there is no need to
put root memcg in the memcg stock.  At the moment, refill_stock() can be
called from try_charge_memcg(), obj_cgroup_uncharge_pages() and
mem_cgroup_uncharge_skmem().

The try_charge_memcg() and mem_cgroup_uncharge_skmem() are never called
with root memcg, so those are fine.  However obj_cgroup_uncharge_pages()
can potentially call refill_stock() with root memcg if the objcg object
has been reparented over to the root memcg.  Let's just avoid
refill_stock() from obj_cgroup_uncharge_pages() for root memcg.

Link: https://lkml.kernel.org/r/20250313054812.2185900-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhockoc@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-avoid-refill_stock-for-root-memcg
+++ a/mm/memcontrol.c
@@ -2643,7 +2643,8 @@ static void obj_cgroup_uncharge_pages(st
 
 	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
-	refill_stock(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


