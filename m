Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB620E033
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 22:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744928255; cv=none; b=XlNeSHJHLSEqPZqK8bpdZ9eilNG/cmxfi6fzwQS8qHH0XMfnl8a5MbuRY+ZRMeJD/v1Ig9dyndIMxg/u+SlSv4AcQ16dGJqcrgEEnyTsu+Swvi39OS/3YCEIc8oyT/fTEJ68771lXEHeFkJTnBHgL52BXLBOKFu3jhAGAG2raBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744928255; c=relaxed/simple;
	bh=RlY2REyxtmlircIWTjg/kN8ZLy17NvYwaLI7zHSN7PA=;
	h=Date:To:From:Subject:Message-Id; b=TZK1R8nNZ7e14wx+/vwL8y9TzGTo0T0BsDcETpVbv9cwOmMwE5CQpmNzv31VNAXQJRs7KQgQW3bmiqhn5GefU63/LpgjJY0kFuJlDUbvBJr639Zi9pK26zh+cg8GkMIOoOAVw8HvM99J6ITL48FPrlMIAOLy7frdaukHoquzNyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AytrvYfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AytrvYfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4586C4CEE4;
	Thu, 17 Apr 2025 22:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744928254;
	bh=RlY2REyxtmlircIWTjg/kN8ZLy17NvYwaLI7zHSN7PA=;
	h=Date:To:From:Subject:From;
	b=AytrvYfCnGVmWzlpg82mG7k2/2wPd3kKXTnSD582Piy5XhrcnoR1VwKFlkekHTTYq
	 5R1O4sBpYIoda32biB1I7LD4qC1FxDM/UIeI+yc2DAbPPZQThdSS5L8rk3m+0R9ipo
	 BuL0/+oFy+ILw9THanCxml6sv+KoGWRY4KQh0+cU=
Date: Thu, 17 Apr 2025 15:17:33 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch added to mm-unstable branch
Message-Id: <20250417221734.A4586C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: modify the assignment logic of the scan and total_scan variables
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/vmscan: modify the assignment logic of the scan and total_scan variables
Date: Thu, 17 Apr 2025 17:24:22 +0800

The scan and total_scan variables can be initialized to 0 when they are
defined, replacing the separate assignment statements.

Link: https://lkml.kernel.org/r/20250417092422.1333620-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Acked-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables
+++ a/mm/vmscan.c
@@ -1725,13 +1725,11 @@ static unsigned long isolate_lru_folios(
 	unsigned long nr_taken = 0;
 	unsigned long nr_zone_taken[MAX_NR_ZONES] = { 0 };
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
-	unsigned long skipped = 0;
-	unsigned long scan, total_scan, nr_pages;
+	unsigned long skipped = 0, total_scan = 0, scan = 0;
+	unsigned long nr_pages;
 	unsigned long max_nr_skipped = 0;
 	LIST_HEAD(folios_skipped);
 
-	total_scan = 0;
-	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
 		struct list_head *move_to = src;
 		struct folio *folio;
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-vmscan-modify-the-assignment-logic-of-the-scan-and-total_scan-variables.patch

