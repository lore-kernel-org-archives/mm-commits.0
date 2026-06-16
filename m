Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E7A3A9627
	for <mm-commits@vger.kernel.org>; Tue, 16 Jun 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631517; cv=none; b=F2BYSnkYiJb2HpQhtIV6mq9D1HuGuSDzH7n+XNuEUVqMzuCLPAmKG8G28FDVInzVKmmxMBnKIAEyPzxFZqomTE4MNfCpsBh9qGABNa7Se2K8ZWW6JJXveKyuAV1oE6UfHXLUkv6mG+Z6Zsa7RnRelU14pxqMZw/nFYRzuawRFoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631517; c=relaxed/simple;
	bh=X/WTGgPs9U6S8yLbZJbha1zQd3NlkWqLm2L/zB9RrZk=;
	h=Date:To:From:Subject:Message-Id; b=SZyXr/t0BTJlnCC77A1AM99ZrqAiFUwIyvXD78dHmv/yqSa/eLSHaZS1byoR5nytYddW4m6jQvuWp4LdldiMYIC6lSsqn1Zn68EGHU4O4jHOXmJDnkW6jX/EqFTAJhn29VVK1GuR+lqkcSiyVUaDXenwp4qY7SxaWn3dSbROShc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egI1xT0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egI1xT0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE34E1F00A3D;
	Tue, 16 Jun 2026 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781631516;
	bh=hKY5Oo8249h6Tqov5kCIdHuQMpR/1a7iT3VLIaAxL3E=;
	h=Date:To:From:Subject;
	b=egI1xT0+En02Q+WQH7/Dd3hcw6a2aBElKd6vIYx66GQQTbO/KSMvJf0K6Kc3aegU+
	 ZmN0vZ0zX79aRDKZx8CYEq0gs235oH3H5RWpviVMCG2hnB9X00gu5Mfp/BzXfNYjX0
	 ACwbKtw/z0WyZ/M6VZT2yoydj1UvfmHeTagClm0U=
Date: Tue, 16 Jun 2026 10:38:35 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,ben.dooks@codethink.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch added to mm-unstable branch
Message-Id: <20260616173835.DE34E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: pass NULL to trace vmscan node reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-vmscan-pass-null-to-trace-vmscan-node-reclaim.patch

