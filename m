Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDF11586CB
	for <mm-commits@vger.kernel.org>; Tue, 12 Nov 2024 00:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731370988; cv=none; b=EHj+tdLMyGRb9aoJpK0jZ2PvSLTcdPLmmdwilnzom6EHYgNLGB8+rzh17ZVaNOyIn/wQza16aRRYSVemQKpblStXILIBiQsEH59ERwOMSYJwr4VxRSKtuCQimgcaO0jY+RvsVLhBipMTciCsz/k6f6P6+rpsJ2GARL8VSs33EWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731370988; c=relaxed/simple;
	bh=5247WGtltTKC5ZJkpr9syLqEMXGEUNFxZE34SmtlRDs=;
	h=Date:To:From:Subject:Message-Id; b=CGooHudB1oBB2l672mYkd8ohISKy+Krl7F0W3obintXht4QwOdaUR+fOL5bqlegR3kwXjuNu1TjrFsXSzvHLelPgk3DwuY00d8FTckQRTszybXp8f7107XLmY4SiOGlmxGXHZKEjuI/CB+UlNfhJoads/czjcngsjzb22QtFQrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u2lL5YMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u2lL5YMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629DAC4CECF;
	Tue, 12 Nov 2024 00:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731370987;
	bh=5247WGtltTKC5ZJkpr9syLqEMXGEUNFxZE34SmtlRDs=;
	h=Date:To:From:Subject:From;
	b=u2lL5YMD/gXk1fHfGcg42qbdE9anKqWNV86zmPYstRSumPUsYKoMqEooTU6lJUjKE
	 mPZOb7fpJFWVv5F4IzYnbOVEeVy9klNt/B3c5Bx0Owx8UOR9iK4qvbPBtqPPHKTl2V
	 o3zPrTUgL1AYHLyJz7x5wtoZZHSyMhjuR4mHByjw=
Date: Mon, 11 Nov 2024 16:23:06 -0800
To: mm-commits@vger.kernel.org,mgorman@techsingularity.net,labbott@redhat.com,liuq131@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-the-total_isolated-in-strict-mode.patch added to mm-unstable branch
Message-Id: <20241112002307.629DAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: fix the total_isolated in strict mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-fix-the-total_isolated-in-strict-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-the-total_isolated-in-strict-mode.patch

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
From: Qiang Liu <liuq131@chinatelecom.cn>
Subject: mm/compaction: fix the total_isolated in strict mode
Date: Sat, 2 Nov 2024 20:16:21 +0000

If the last cycle reads bogus compound_order() and blockpfn > end_pfn
occurs, it is possible that total_isolated will be less than nr_scanned. 
In this case, strict mode should return 0, but the “if (strict &&
blockpfn < end_pfn)” statement cannot recognize this situation

Link: https://lkml.kernel.org/r/20241102201621.95291-1-liuq131@chinatelecom.cn
Signed-off-by: Qiang Liu <liuq131@chinatelecom.cn>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-the-total_isolated-in-strict-mode
+++ a/mm/compaction.c
@@ -699,7 +699,7 @@ isolate_fail:
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && blockpfn < end_pfn)
+	if (strict && (blockpfn < end_pfn || total_isolated != nr_scanned))
 		total_isolated = 0;
 
 	cc->total_free_scanned += nr_scanned;
_

Patches currently in -mm which might be from liuq131@chinatelecom.cn are

mm-compaction-fix-the-total_isolated-in-strict-mode.patch

