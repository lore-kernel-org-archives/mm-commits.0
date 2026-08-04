Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA69448CFC
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816283; cv=none; b=Q/Kll454uskqlbGND6NED5O1eChMj7pr7hkALTNnNCwM0FR7a44qf2G9CN7cVjhSM3xda6EGpP48vWpKS6smOF65iK1PE27TEPgc2DVejm3+P9GDt8dhqgXakB/U5v0xhCUCj0+1gVf37Xo4XldjZxI7gG5aSuOma/ElsjWrZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816283; c=relaxed/simple;
	bh=5yfqOGt4mWBrdXUh/wkonbkPki/FbYL3la1mPq86Id8=;
	h=Date:To:From:Subject:Message-Id; b=T1MBrAkhNaDfhgYBkwVRDcgSZk+6mCng07/caAFJAQGInUs98io+kdvXqfRVJZYVfWAqoaS/Zaa9ExoYiC9lIg/Zp8jcro1NHjahGQiSGo9NO0z2MyLcg1wR5GEafYU8udtd/g1Hph9/xXY1z5hYrFGaweAIW08vjbGG/lwYqBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLPeZkSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLPeZkSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AFC1F000E9;
	Tue,  4 Aug 2026 04:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816282;
	bh=3fTpE0A7kFyq7f7oeaGVzgxJ2YGmZq488oyuaBvKP8E=;
	h=Date:To:From:Subject;
	b=wLPeZkSdvBzcyO5GE9yCaFRbkpWZKcc6niz109iY+6yibGdl2X5iY02y6uYSkWbND
	 KT0OhiD+KlyMwhNWZovTmUnxyyJT13m9RgYlSBeACNaSVYpvrGDV/3DrRZW3FVgVRa
	 yxzRTwbS85G67tnaPUoD1+B7UREpXXvbpvFbhYwY=
Date: Mon, 03 Aug 2026 21:04:41 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,mika.westerberg@linux.intel.com,hansg@kernel.org,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,sakunix@yahoo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] resource-downgrade-resource-sanity-check-warning-to-debug-level.patch removed from -mm tree
Message-Id: <20260804040442.38AFC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: downgrade "resource sanity check" warning to debug level
has been removed from the -mm tree.  Its filename was
     resource-downgrade-resource-sanity-check-warning-to-debug-level.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manuel Quintero Fonseca <sakunix@yahoo.com>
Subject: resource: downgrade "resource sanity check" warning to debug level
Date: Fri, 22 May 2026 17:01:31 -0700

The "resource sanity check" warning need not mean that there is a
functional issue and in the cases when there isn't one, it is just useless
and confusing noise.

For this reason, downgrade the log level of it from "warn" to "debug".

This reduces log clutter while keeping the diagnostic information
available for debugging purposes if needed.

Link: https://lore.kernel.org/20260523000131.7086-1-sakunix@yahoo.com
Signed-off-by: Manuel Quintero Fonseca <sakunix@yahoo.com>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Hans de Goede <hansg@kernel.org>
Cc: Mika Westeberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~resource-downgrade-resource-sanity-check-warning-to-debug-level
+++ a/kernel/resource.c
@@ -1859,7 +1859,7 @@ int iomem_map_sanity_check(resource_size
 		if (p->flags & IORESOURCE_BUSY)
 			continue;
 
-		pr_warn("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
+		pr_debug("resource sanity check: requesting [mem %pa-%pa], which spans more than %s %pR\n",
 			&addr, &end, p->name, p);
 		err = -1;
 		break;
_

Patches currently in -mm which might be from sakunix@yahoo.com are


