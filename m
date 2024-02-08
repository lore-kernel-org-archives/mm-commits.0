Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E0381D2
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707426085; cv=none; b=HBMRN4bzbFOw9GM9161e5C7ckVLy7uihkPNmf81Oa8OzwyqgjBjH2N6bhJizlaOHKEJ9U4PeWa4ENtjm4mVMmnQxS6KY2PuaRiqggnAvrlVsewx740ZVdIq9YobajE9ZSICBNHCkt/SkBDKHTyzTyd77GfX7BovjNhYCMkhs+Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707426085; c=relaxed/simple;
	bh=KM8w4EWmCNtGN9wqZO283iFT7oIc9y1hn542zNM1nMA=;
	h=Date:To:From:Subject:Message-Id; b=U6Rt5NWKqgp3MBQALwcHr1hZ/lLSm9MVYugdxg0s+0+QqglPdPA/smJDZuvLCA7McbthL+UTphSI5NZ05zXRUrFixMf4wBqKXEhySLshmM0tDclDZXRxk9QawmZpN6Cmzfj8x3Xo3c6YgmAlhmRSck2k+fY8Fhql0zA6GUe12/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2NQraq0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2NQraq0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF61C433C7;
	Thu,  8 Feb 2024 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707426085;
	bh=KM8w4EWmCNtGN9wqZO283iFT7oIc9y1hn542zNM1nMA=;
	h=Date:To:From:Subject:From;
	b=2NQraq0X5zty4TkR2pbMMwXaBJ7YGiT2usk24pAvTAQNWVGXMYl6Y8K9YdPo1GffH
	 lfQF0ArRXtXmXwQFab28GSkofuBVY4+wFi9RmBAz78ldaWS0h6pISoPyEuZlO8KzeG
	 LW2WTSCTHq/QhzhBI4YNuseLUbJ+hDG+h+56uOCU=
Date: Thu, 08 Feb 2024 13:01:24 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch added to mm-unstable branch
Message-Id: <20240208210124.DBF61C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, vmscan: don't turn on cache_trim_mode at the highest scan priority
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch

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
From: Byungchul Park <byungchul@sk.com>
Subject: mm, vmscan: don't turn on cache_trim_mode at the highest scan priority
Date: Thu, 8 Feb 2024 15:18:25 +0900

With cache_trim_mode on, reclaim logic doesn't bother reclaiming anon
pages.  However, it should be more careful to turn on the mode because
it's going to prevent anon pages from being reclaimed even if there are a
huge number of anon pages that are very cold and which should be
reclaimed.  Even worse, that can lead kswapd_failures to reach
MAX_RECLAIM_RETRIES and stopping kswapd until direct reclaim eventually
works to resume kswapd.

Link: https://lkml.kernel.org/r/20240208061825.36640-1-byungchul@sk.com
Signed-off-by: Byungchul Park <byungchul@sk.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority
+++ a/mm/vmscan.c
@@ -2269,7 +2269,8 @@ static void prepare_scan_control(pg_data
 	 * anonymous pages.
 	 */
 	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
-	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE))
+	if (sc->priority != 1 && file >> sc->priority &&
+	    !(sc->may_deactivate & DEACTIVATE_FILE))
 		sc->cache_trim_mode = 1;
 	else
 		sc->cache_trim_mode = 0;
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-vmscan-dont-turn-on-cache_trim_mode-at-the-highest-scan-priority.patch

