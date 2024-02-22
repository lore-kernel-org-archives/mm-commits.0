Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45682919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560191; cv=none; b=mA2GbePGiFLfgurbRyOoM5R3cApem9isbdhiJCRCJt/6lBzNLv7ber61xlUHgPoYMd84V36Vxrho3UD4Z45AehxjsYaQ4ti9BKTMa/SY3b8t0em8c6JHcP29LIBeEly1pNxtqrQO/Yk9CPBXUuKpSFtff6ZKA4BwVa1DPQsa3sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560191; c=relaxed/simple;
	bh=esiaLbbzkYvdsYXfw1Ieswhcx1KpBfHIw5MGOssAJwI=;
	h=Date:To:From:Subject:Message-Id; b=Q92kUxT+Mbp6hs4jHYF28kf1t5iVAhx2iC1OQMu/H5qeLFTzbdJI9QociE8floLlrSDKZwP7JtJzbyfC52UW6vTZ7rWy856xzousuABzAPo+eu2acj8b5UcWzaGiI+T8UDnDmOh51t2n46rKpr8yejmE6ZHYkWyw677CiXwmjmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XyjPfP18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XyjPfP18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9A8C433C7;
	Thu, 22 Feb 2024 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560191;
	bh=esiaLbbzkYvdsYXfw1Ieswhcx1KpBfHIw5MGOssAJwI=;
	h=Date:To:From:Subject:From;
	b=XyjPfP18rI+bG0DLuT6oQhYqpDpgmH04S5ZX6fW7Je2AIwvVpe05+6h94v5kox+DH
	 xZccwOnLot64Yy2TPqiaIMByVrjdqtBV16pUYbr/p9t88jhrrluM1IaCls+M6XdV+c
	 bRBPOmhuIisCz3hA04INjNxveZ612MBxFd6pniK0=
Date: Wed, 21 Feb 2024 16:03:10 -0800
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-make-max_cma_areas-=-config_cma_areas.patch removed from -mm tree
Message-Id: <20240222000311.6E9A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: make MAX_CMA_AREAS = CONFIG_CMA_AREAS
has been removed from the -mm tree.  Its filename was
     mm-cma-make-max_cma_areas-=-config_cma_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -917,14 +917,14 @@ config CMA_SYSFS
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


