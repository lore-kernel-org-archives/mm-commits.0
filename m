Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6AF25484D
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744146253; cv=none; b=XmCa9SN51YWLtZ5BTj2tcBFt0gIwxT3W4M3BNClDZTNQ+w4Me05gKuTzq9Yjvu03kZ0sbZVscr+tUemZNw70geVY+/78GtrDBgelJHGMWqptuZcYsbPoJYtLZk9BdKWHbUyM17T0B7UcHk9ySo6Gq5w72ysunJpTqLSXsYUmtJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744146253; c=relaxed/simple;
	bh=7MzR8OQZZJ0Bs14Me/DSftLFv+fOffKz0VrlF9aZsO8=;
	h=Date:To:From:Subject:Message-Id; b=LGEc2tmL7xA3rHzqQhQI1ue3QDaguWCNzZUdMoFgBzHf+yme6RDlQCyt0N2ZWtSqAXD0/3p8sLg3PBKpgLr7ui1WizFgsLKe/r1AQlKV9jX0N+zMaVBDBBivEg4K7/6k3cWgdpylpSS2o406y6lc1qpB5BUKtO3I9mvFFcoCQFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i653DWed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i653DWed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1A3C4CEE9;
	Tue,  8 Apr 2025 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744146253;
	bh=7MzR8OQZZJ0Bs14Me/DSftLFv+fOffKz0VrlF9aZsO8=;
	h=Date:To:From:Subject:From;
	b=i653DWeda/cS6cg1X0jdcSwdn+M2JClpNVMXvinKthjOL2Zbn3R8uMeIMkTHZcTN0
	 jGNUw1VyPy5xDFkDgCyGjrLhLqJ4NvGZkC4t0a0DfX63m1dth/4rB3sq/P3WeSkGGw
	 jkov2mrh9Mpb4pMBz/N9fMKCx/8D+uk1pEx0lZF8=
Date: Tue, 08 Apr 2025 14:04:12 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,geert@linux-m68k.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-report-base-address-of-single-range-correctly-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250408210413.0D1A3C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-cma-report-base-address-of-single-range-correctly-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-report-base-address-of-single-range-correctly-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-report-base-address-of-single-range-correctly-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Frank van der Linden <fvdl@google.com>
Subject: mm-cma-report-base-address-of-single-range-correctly-v2
Date: Tue, 8 Apr 2025 16:40:00 +0000

Link: https://lkml.kernel.org/r/20250408164000.3215690-1-fvdl@google.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdVWviQ7O9yBFE3f=ev0eVb1CnsQvR6SKtEROBbM6z7g3w@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/cma.c~mm-cma-report-base-address-of-single-range-correctly-v2
+++ a/mm/cma.c
@@ -722,14 +722,15 @@ static int __init __cma_declare_contiguo
 	}
 
 	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
-	if (ret)
+	if (ret) {
 		memblock_phys_free(base, size);
-	else {
-		(*res_cma)->nid = nid;
-		*basep = base;
+		return ret;
 	}
 
-	return ret;
+	(*res_cma)->nid = nid;
+	*basep = base;
+
+	return 0;
 }
 
 static void cma_debug_show_areas(struct cma *cma)
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-report-base-address-of-single-range-correctly.patch
mm-cma-report-base-address-of-single-range-correctly-v2.patch
mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

