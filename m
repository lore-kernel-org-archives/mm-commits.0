Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E572745E
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740605660; cv=none; b=Mp1UQXfD3t58jiCW65huNbkBLh2OLOriumTsKKRapWQVmRwZidLPlr9pNHo9SF6gBc8e9c9g9fAPGhNLwxCXrwgsemV70/qHSloP/KH6izyG8UFq71TM5bcwtpXB5hI5F4KBcU45y7DRYI48Dh/6WHI6yKyIDh6kZasp+Bopjog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740605660; c=relaxed/simple;
	bh=n15JH1b9xmbw397RY0L+eichLCIf21Y7xlDKjwrx5ZQ=;
	h=Date:To:From:Subject:Message-Id; b=YQyik7t2CZ0TWtq23p3nQ5wg9d1eVE2Pea7fzqTiskWat+Q80H2HhVlbVB4A8r4JxYHHJXHb7zUU/iUqXDtQKCVIDBI3Zs7ro/hmnn5+bQM0oLdLQxDESo47f7Mvo8u/lyO8LdisdIoxfNc+/+Lnk5+ImJQuMEiA6/by6HPMsws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+c7yMi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+c7yMi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200DCC4CED6;
	Wed, 26 Feb 2025 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740605660;
	bh=n15JH1b9xmbw397RY0L+eichLCIf21Y7xlDKjwrx5ZQ=;
	h=Date:To:From:Subject:From;
	b=A+c7yMi0dfojFBurpfwRGrNVWE6VdSz2qJciwbqy1O0CYfxOJyTSFOa13C/N0EW3a
	 uDXDe5hZ47FMmTV8j4E67MIpFjAgCBtVvICnnycE8j0mOv32xfM2yfU2EaqNvI5LcS
	 ODfybKFIoO7COYeZJhff283ZsFqqhONY/DVgSj1k=
Date: Wed, 26 Feb 2025 13:34:19 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,bus710@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-a-typo-in-the-kconfig-sameple.patch added to mm-unstable branch
Message-Id: <20250226213420.200DCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon: a typo in the kconfig - sameple
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-a-typo-in-the-kconfig-sameple.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-a-typo-in-the-kconfig-sameple.patch

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
From: bus710 <bus710@gmail.com>
Subject: samples/damon: a typo in the kconfig - sameple
Date: Wed, 26 Feb 2025 10:42:04 -0800

There is a typo in the Kconfig file of the damon sample module.  Correct
it: s/sameple/sample/

Link: https://lkml.kernel.org/r/20250226184204.29370-1-sj@kernel.org
Signed-off-by: bus710 <bus710@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/samples/damon/Kconfig~samples-damon-a-typo-in-the-kconfig-sameple
+++ a/samples/damon/Kconfig
@@ -3,7 +3,7 @@
 menu "DAMON Samples"
 
 config SAMPLE_DAMON_WSSE
-	bool "DAMON sameple module for working set size estimation"
+	bool "DAMON sample module for working set size estimation"
 	depends on DAMON && DAMON_VADDR
 	help
 	  This builds DAMON sample module for working set size estimation.
@@ -15,7 +15,7 @@ config SAMPLE_DAMON_WSSE
 	  If unsure, say N.
 
 config SAMPLE_DAMON_PRCL
-	bool "DAMON sameple module for access-aware proactive reclamation"
+	bool "DAMON sample module for access-aware proactive reclamation"
 	depends on DAMON && DAMON_VADDR
 	help
 	  This builds DAMON sample module for access-aware proactive
_

Patches currently in -mm which might be from bus710@gmail.com are

samples-damon-a-typo-in-the-kconfig-sameple.patch

