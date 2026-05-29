Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67A1AA1D2
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027601; cv=none; b=o6kedm7mfg5kSkFa4d7CtJKdcJdU1ozx+gwYvG/B4vcdmNcNlfKQt3K2ZSuRQhzTvwRQffgV/Pn6WhfprH8we/4/bVYZG1+EJiNoH3jOO9dhjsLMyx1LRZB0uwJ6RbIY4WA/aP5jQzJW0Qcd1JFzu/XljRDnJfYQd241zQhrFzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027601; c=relaxed/simple;
	bh=kNQzIW+P1XpFwSzAKmWZ7QvlKelwjbYc0Fj5ZptK7Vs=;
	h=Date:To:From:Subject:Message-Id; b=b5NeJr8++4KOYIx15QGHuhYdq9IOiAvIsiA45dGKPqsq6k0TidENS0yth1I15N+wgPR364W5/nMyr3xWHcRknR4uR7O3iWVdC8+2+GzTlg579kTD7Qw8tTsn5sStfepQDgMiJygQ7+r/P7pC2o0YtRrUVCG35kluwVMbMaXtaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GscDAC7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GscDAC7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3201F00893;
	Fri, 29 May 2026 04:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027600;
	bh=gWEcLoCeDB0vARE80UQYXqfCxsCPR4k4/NgqPDsaJoA=;
	h=Date:To:From:Subject;
	b=GscDAC7C0V6DEqmhYR5WNq4c4Yj46//pv/Qg0/8owEZWOSPhHHtSSburIJFYSUUjU
	 R7JOmez+y9ZEZGGXfAI/ATDdLIBg3HdrzqxcjmOWPE4Sd9Rz8YhuEsXpABR/O5tPZI
	 yF2NgMSriiqpfWLCAmzOgLGClR1ssEFWJiPeh1jA=
Date: Thu, 28 May 2026 21:06:39 -0700
To: mm-commits@vger.kernel.org,donettom@linux.ibm.com,baohua@kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20260529040640.4A3201F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiang Gao <gaoxiang17@xiaomi.com>
Subject: mm/vmscan: fix typos in comments
Date: Thu, 16 Apr 2026 14:23:02 +0800

Fix three typos in comments:

- Line 112: "zome_reclaim_mode" -> "zone_reclaim_mode"
- Line 6208: "prioities" -> "priorities"
- Line 7067: "that that high" -> "that the high" (duplicated word)

Link: https://lore.kernel.org/20260416062302.727468-1-gxxa03070307@gmail.com
Signed-off-by: Xiang Gao <gaoxiang17@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-fix-typos-in-comments
+++ a/mm/vmscan.c
@@ -109,7 +109,7 @@ struct scan_control {
 	/* zone_reclaim_mode */
 	unsigned int may_unmap:1;
 
-	/* zome_reclaim_mode, boost reclaim, cgroup restrictions */
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
 	unsigned int may_swap:1;
 
 	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
@@ -6359,7 +6359,7 @@ static void consider_reclaim_throttle(pg
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7224,7 +7224,7 @@ restart:
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &sc))
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are


