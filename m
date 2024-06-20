Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619E14287
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847373; cv=none; b=GaTZCRwsrF9nITgGSf+I5jYfbMLQfLRqJ752blHrRnqnQm1kBwvvXGR1atBSjg0tlA7+ZUDuWh8xCtCTcGAAwgFpq0v4GYxTzrfeQp6tD5Se6Rgp8upbWUfXCIOerKauTiqMpTASo4taWDAFptJRIhcFl5rGu8ojGTtLt9dHPrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847373; c=relaxed/simple;
	bh=41DSf25gEZ2MpgAaqh/hzd4lIYzyVJvNn0Zf0OaUsvI=;
	h=Date:To:From:Subject:Message-Id; b=FT3xMg8KL90pqTjWZjOyRQ5cdqCYraAtTuzkrls4fB3b+tnNoFVygLEkA18W1d/nZMSsCWB8GohwoYN7EP1/UEkWnbwloLF/0axWCg5NVD5M/AOCHaxpoKxRbQOSgntkbvqpU8IffZQ12VwtZx60P0ts11cMi9UHrfh8Z5V3JTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TX3ycz/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TX3ycz/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26995C4AF07;
	Thu, 20 Jun 2024 01:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718847373;
	bh=41DSf25gEZ2MpgAaqh/hzd4lIYzyVJvNn0Zf0OaUsvI=;
	h=Date:To:From:Subject:From;
	b=TX3ycz/GdJTI7tOCZxagy0JIyZYVLyLiDXhE9jloTFwry8ld+AtDzG1UO6eNc6jwo
	 P2sPYnsFIvqY52qTy14cbzsnMPKcZyKW3R8z8kHZXXdjuvGP4bMX84k2L0BgaMVEDY
	 pnF4FPXmrqsklk2ftIyhryZrK1Cnf5swlI/hyoZA=
Date: Wed, 19 Jun 2024 18:36:12 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch added to mm-unstable branch
Message-Id: <20240620013613.26995C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: move build check on MAX_ZONELISTS out of ifdef
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: move build check on MAX_ZONELISTS out of ifdef
Date: Wed, 19 Jun 2024 01:06:10 +0000

Current check on MAX_ZONELISTS is wrapped in CONFIG_DEBUG_MEMORY_INIT,
which may not be triggered all the time.

Let's move it out to a more general place.

Link: https://lkml.kernel.org/r/20240619010612.20740-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef
+++ a/mm/mm_init.c
@@ -54,7 +54,6 @@ void __init mminit_verify_zonelist(void)
 		struct zonelist *zonelist;
 		int i, listid, zoneid;
 
-		BUILD_BUG_ON(MAX_ZONELISTS > 2);
 		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
 
 			/* Identify the zone and nodelist */
@@ -2657,6 +2656,7 @@ static void __init mem_init_print_info(v
 void __init mm_core_init(void)
 {
 	/* Initializations relying on SMP setup */
+	BUILD_BUG_ON(MAX_ZONELISTS > 2);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch
mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch
mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

