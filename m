Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930E713E04C
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722556197; cv=none; b=hAxep1R5x3wxAcdYRzhkNuVnoEgmfWEomUzZMh7OUHq8CjW2/+X0RvZsQ4qDILQ4sryJ9+a/l4CWdAYR3DnCBevSbIJhL3h13rgLICyvrHbj4NFYPDXznonICiIhahrhi687UQrXnf8ZThKwZfWRTsV3Vk1qEX5+O3J8tcdwO5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722556197; c=relaxed/simple;
	bh=zVk2vSMha+p9EN/rFQUB86CtkYEdBs6r/UsQ0+iCw9k=;
	h=Date:To:From:Subject:Message-Id; b=bmnGNuwcKm3wUrciBCmxHemf3ZvNuuz0/4K7p4IfRME+eZa/u3idIPYfBBtuEZ+/Elz/uddgpKxH+P9y7BRv888cuLd5f7qhkqCBEI19vq/Ak5XuNzVC1viqXQf4He4tSwwt//mVNN/KoXGNOUFP1EDW5eRvJf/TPl9vqtsesro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STs7HJI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STs7HJI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F472C32786;
	Thu,  1 Aug 2024 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722556197;
	bh=zVk2vSMha+p9EN/rFQUB86CtkYEdBs6r/UsQ0+iCw9k=;
	h=Date:To:From:Subject:From;
	b=STs7HJI+p/qAKeG/2EgnU/E07BhRxVaktka7yDnR2b7kKe3sOrpDk3qsDxPn+iW7z
	 7bmMqcYLH7aVWDxQ47ekFxzvhTw5Ss6i/XlnJzgGlRJOtEFENDHPmwkK7hUXNfzGn5
	 RcdaerbSvvpZinvuyYH7kkwe9M8BioGm0INFTFAQ=
Date: Thu, 01 Aug 2024 16:49:56 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-print-the-promo-watermark-in-zoneinfo.patch added to mm-unstable branch
Message-Id: <20240801234957.1F472C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: print the promo watermark in zoneinfo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-print-the-promo-watermark-in-zoneinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-print-the-promo-watermark-in-zoneinfo.patch

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
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm: print the promo watermark in zoneinfo
Date: Thu, 1 Aug 2024 23:25:48 +0000

Print the promo watermark in zoneinfo just like other watermarks.  This
helps users check and verify all the watermarks are appropriate.

Link: https://lkml.kernel.org/r/20240801232548.36604-3-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmstat.c~mm-print-the-promo-watermark-in-zoneinfo
+++ a/mm/vmstat.c
@@ -1725,6 +1725,7 @@ static void zoneinfo_show_print(struct s
 		   "\n        min      %lu"
 		   "\n        low      %lu"
 		   "\n        high     %lu"
+		   "\n        promo    %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
 		   "\n        managed  %lu"
@@ -1734,6 +1735,7 @@ static void zoneinfo_show_print(struct s
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
+		   promo_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone_managed_pages(zone),
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch
mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch
mm-print-the-promo-watermark-in-zoneinfo.patch

