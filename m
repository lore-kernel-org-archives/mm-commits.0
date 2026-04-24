Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEF3033E1
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044281; cv=none; b=HEVdVW/VCpJSph4e4NQ1RLaZiwi/4t622nrnC+R6mWOHQHquycnlRidrEd4HP/fHgWACAkw9Eqbh7Ge23TGRE7+euPOAUiGhSfdhk7s8371aR9jw2cN8BCI61EFbSSNawB6kFM/ON2aE/sAdCriIWlqxlbdRlDYerszsM3pDHxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044281; c=relaxed/simple;
	bh=TNdpOP0TwmXfYePM/P1+DPYjcr9AYgzZ3xkhN/CNNUw=;
	h=Date:To:From:Subject:Message-Id; b=uovxUj6Buqk/+LN9rfRn8MJPnyDtGDb7bCrfPRz6Sm1CgNtTvowunWgniLNe7Apka1nQjxxvEABUhkji9KrANX4OBD6doWs/oCT0QBSOMuHkbQiSyKtYvI89BR+PCFZz8fd/Lbb3lByTqH8aHPsy2M99yw4hXu1c0FSC3NlxAXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTn69G3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTn69G3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2ADC19425;
	Fri, 24 Apr 2026 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777044280;
	bh=TNdpOP0TwmXfYePM/P1+DPYjcr9AYgzZ3xkhN/CNNUw=;
	h=Date:To:From:Subject:From;
	b=yTn69G3ll1j/n31TWeKICIkY18e2iYcb5gRKyLPQYSEVdQXWahGh7Jda7Yi2RRZcF
	 DzHIUmfs9DxX7j1gK9iBleripnzKTMZWsHlGZkDI0FNkZhqGh6m1wSZt7SdJzmkc2Q
	 RZaAX0FUrCFr0MXgY3MkO5h/DnAQQazmyyeULFro=
Date: Fri, 24 Apr 2026 08:24:40 -0700
To: mm-commits@vger.kernel.org,donettom@linux.ibm.com,baohua@kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-typos-in-comments.patch added to mm-new branch
Message-Id: <20260424152440.BD2ADC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix typos in comments
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-fix-typos-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-typos-in-comments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
@@ -6315,7 +6315,7 @@ static void consider_reclaim_throttle(pg
 	if (current_is_kswapd() || cgroup_reclaim(sc))
 		return;
 
-	/* Throttle if making no progress at high prioities. */
+	/* Throttle if making no progress at high priorities. */
 	if (sc->priority == 1 && !sc->nr_reclaimed)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
@@ -7180,7 +7180,7 @@ restart:
 
 		/*
 		 * There should be no need to raise the scanning priority if
-		 * enough pages are already being scanned that that high
+		 * enough pages are already being scanned that the high
 		 * watermark would be met at 100% efficiency.
 		 */
 		if (kswapd_shrink_node(pgdat, &sc))
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are

mm-vmscan-fix-typos-in-comments.patch

