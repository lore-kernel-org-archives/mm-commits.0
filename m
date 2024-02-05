Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0D14D5BB
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175287; cv=none; b=J+xHuerUlly0aWqQ0ZM0/31dQ657LUuOvvciNENX2eXy36lkGBTLVL2TeSFQKTFy26uQT1Yu0qH8bnWuU+ub/JWwzOQ/2m4aP46qaRaY/BZuDopJrA5/bPXoemPkvnuU/lh/TqN6tTszZ0nPjRq0UkJGa7P48pKUgdOaREMmnno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175287; c=relaxed/simple;
	bh=evmcTWaXP65jR5/2gu7N97EhUrQjvHsd0HqfAlOegAM=;
	h=Date:To:From:Subject:Message-Id; b=CuVQkBpD7gGPzL6NRZnezwoPUreDd8pgeHYvendcsv95qgm0zgH/4u4rLtlIAYcWuKGOG3vngHoHRqLysr+T1lErL9+Qk1j0zxupMBNHPcZnZ5+EJN6wh/TzkHB3zkelFcxwDm3Rfcrl1qyBIf9bw4q9rleRZnoB216fcQiyvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iPjDlwCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iPjDlwCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E116C433C7;
	Mon,  5 Feb 2024 23:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175287;
	bh=evmcTWaXP65jR5/2gu7N97EhUrQjvHsd0HqfAlOegAM=;
	h=Date:To:From:Subject:From;
	b=iPjDlwCm8J6NoTHHZW5u14fQGivlc9rcItl9bQNIs11TqA3YuplCbDIRKPAtwwlPM
	 Se6MwzLI+qph6ljL+JB/6NC3TVOKFNxj1r8se3hiTQKqgOLXiwfBOC6ODwWwdvJcoJ
	 CFbHFFsp/MrNgy/D85np55GQ66tKUEfPj97SRhHU=
Date: Mon, 05 Feb 2024 15:21:26 -0800
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-make-max_cma_areas-=-config_cma_areas.patch added to mm-unstable branch
Message-Id: <20240205232127.4E116C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: make MAX_CMA_AREAS = CONFIG_CMA_AREAS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-make-max_cma_areas-=-config_cma_areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-make-max_cma_areas-=-config_cma_areas.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: make MAX_CMA_AREAS = CONFIG_CMA_AREAS
Date: Mon, 5 Feb 2024 10:49:29 +0530

There is no real difference between the global area, and other
additionally configured CMA areas via CONFIG_CMA_AREAS that always
defaults without user input.  This makes MAX_CMA_AREAS same as
CONFIG_CMA_AREAS, also incrementing its default values, thus maintaining
current default for MAX_CMA_AREAS both for UMA and NUMA systems.

Link: https://lkml.kernel.org/r/20240205051929.298559-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    6 +-----
 mm/Kconfig          |    6 +++---
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/cma.h~mm-cma-make-max_cma_areas-=-config_cma_areas
+++ a/include/linux/cma.h
@@ -6,12 +6,8 @@
 #include <linux/types.h>
 #include <linux/numa.h>
 
-/*
- * There is always at least global CMA area and a few optional
- * areas configured in kernel .config.
- */
 #ifdef CONFIG_CMA_AREAS
-#define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
+#define MAX_CMA_AREAS	CONFIG_CMA_AREAS
 #endif
 
 #define CMA_MAX_NAME 64
--- a/mm/Kconfig~mm-cma-make-max_cma_areas-=-config_cma_areas
+++ a/mm/Kconfig
@@ -926,14 +926,14 @@ config CMA_SYSFS
 config CMA_AREAS
 	int "Maximum count of the CMA areas"
 	depends on CMA
-	default 19 if NUMA
-	default 7
+	default 20 if NUMA
+	default 8
 	help
 	  CMA allows to create CMA areas for particular purpose, mainly,
 	  used as device private area. This parameter sets the maximum
 	  number of CMA area in the system.
 
-	  If unsure, leave the default value "7" in UMA and "19" in NUMA.
+	  If unsure, leave the default value "8" in UMA and "20" in NUMA.
 
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch

