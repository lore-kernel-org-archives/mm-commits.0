Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E525775808
	for <mm-commits@vger.kernel.org>; Thu, 18 Jul 2024 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721338438; cv=none; b=SSbEPQl7XYjbDZFpumTJ4UywOPjQIokudzcnyTUpRkFUhMc5LZCw/qwQHotVVnING6haWZPJ5jyZazXv9vo+nlTrGo7wFRdkBucsljhx9spUggS0eOT4OB0JJyKq0e4DYBZo2rKm3xsqJmhv7jcmNqG+1SV8wNXy3cLSJXyrDrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721338438; c=relaxed/simple;
	bh=pRn2vKtpI/E52+BOPTwr02CI/y5v668f7NUtT2iZHDE=;
	h=Date:To:From:Subject:Message-Id; b=RULYSJiOXd8/DKlQ97RMSSLcDfWyb5vqYY29FwJBPU/cOA3fMu6sPRCCaGTUwoAXHzHR1969anaLEwssFOg1ZxdOtOPJJPmOhpHrZNesWUO7bbZOlYJPxTQXBgWDpkspE7YRgQmbmi4S4+OZVcnUfrzZY0pPuct2eB6h7YfAQ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSA5/Ul0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSA5/Ul0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6586DC116B1;
	Thu, 18 Jul 2024 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721338437;
	bh=pRn2vKtpI/E52+BOPTwr02CI/y5v668f7NUtT2iZHDE=;
	h=Date:To:From:Subject:From;
	b=MSA5/Ul0Oi4cXSNswWdp3r6FDmi4oW2ZECje2dI5v6gTxpecXK7LN7f/OzCbDTL38
	 zvwzxckyHgUzqGcg2W14K5vZYd4nLrCfYIiet7PnOmLnjdCXWra0bxNLSfMc7IGqe3
	 K7HnXJUbK7PMEZIOYXCl6LQSrFJUTWdrtgSHWAMo=
Date: Thu, 18 Jul 2024 14:33:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,hannes@cmpxchg.org,valdis.kletnieks@vt.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-typo-in-kconfig.patch added to mm-unstable branch
Message-Id: <20240718213357.6586DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix typo in Kconfig
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-typo-in-kconfig.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-typo-in-kconfig.patch

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
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Subject: mm: fix typo in Kconfig
Date: Sat, 13 Jul 2024 02:59:50 -0400

Fix typo in Kconfig help

Link: https://lkml.kernel.org/r/78656.1720853990@turing-police
Fixes: e93d4166b40a8 ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~mm-fix-typo-in-kconfig
+++ a/init/Kconfig
@@ -984,7 +984,7 @@ config MEMCG_V1
 	  going to shrink due to deprecation process. New deployments with v1
 	  controller are highly discouraged.
 
-	  San N is unsure.
+	  Say N if unsure.
 
 config BLK_CGROUP
 	bool "IO controller"
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

mm-fix-typo-in-kconfig.patch

