Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7352F370ADF
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067226; cv=none; b=QLTKeKjKFTBBsP25HG6jJVH6Amimf3IDKEJeNB+MftY5jgBTdshphxImfaUoVckimzIT+fTjxGLVMJXugv+vqwN/bX7n9hGypxeOmiFapdC+xj/SkM7wiPyElwNj3oIAA5DdhxMwHTuh14IZ0zEKodxVXnQa4osFUhwKBZQJjfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067226; c=relaxed/simple;
	bh=pp1wtIYNSwi5I1/3v/DhRmrxoHHPWBRNR6yukm74FBc=;
	h=Date:To:From:Subject:Message-Id; b=BAKt20uaGh//Ugu+SCfpWDgaED+QZJWTbfy2TKmdi0AJ6KNUMzC7vkEr5Qv+xBESgj0MIM0JRyvNTxKzqio4aUkhvwQResgd4gKaObHhK67Mt0Tvyew12rI66ZmJPtrXkKk8/n+bo7pRTyTi1p03ith45nhDMfh0Dt8NVpDgPlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d4c7l1BY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d4c7l1BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480751F000E9;
	Sun, 21 Jun 2026 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067225;
	bh=p1lG/H52ozKbBlbWVs1cBdN2nDlDP1GFzmtTr54GQyE=;
	h=Date:To:From:Subject;
	b=d4c7l1BYpVvflGjPT4S6PgyC+ibKwzKpQdfXU1x0Zm4Z4b3XV6zhH9Hc0q4d9jBBI
	 BQh4cE0GAaweM83kMSKaXyY8edkCyYBIMWPRkZzSWRFdwGMFpNqU+Y4rc0RZgqEzEs
	 VBdnoj1yXZ9DKsisHLf7beFrBWn5ojZj4mtlTcqg=
Date: Sun, 21 Jun 2026 11:40:24 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,ben.dooks@codethink.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch removed from -mm tree
Message-Id: <20260621184025.480751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: pass NULL to trace vmscan node reclaim
has been removed from the -mm tree.  Its filename was
     mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: mm/vmscan: pass NULL to trace vmscan node reclaim
Date: Tue, 16 Jun 2026 10:59:06 +0100

The tracepoint for node relcaims takes a `struct mem_cgroup *`
as the third argument, so pass NULL instead of 0 to fix warning
about using an integer as a pointer.

Fixes the following warnings:

mm/vmscan.c:6753:66: warning: Using plain integer as NULL pointer
mm/vmscan.c:6757:58: warning: Using plain integer as NULL pointer
mm/vmscan.c:7818:60: warning: Using plain integer as NULL pointer

Link: https://lore.kernel.org/20260616095906.210016-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-pass-null-to-trace-vmscan-node-reclaim
+++ a/mm/vmscan.c
@@ -6706,11 +6706,11 @@ unsigned long try_to_free_pages(struct z
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, 0);
+	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, NULL);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -7776,7 +7776,7 @@ static unsigned long __node_reclaim(stru
 	delayacct_freepages_end();
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, 0);
+	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
 
 	return sc->nr_reclaimed;
 }
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are


