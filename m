Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FC5487B2
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175483; cv=none; b=Bjv9JjlMf2DD7/DtP4z/xVc882z+xdq8QMldqeLJso1g0AXGFd0diIJ6KBjv8YFMiVXPChGmmpTUCokPlVr7/WiRccei3EA++DskLOvKZ6AuNbnFdW7VMvfdWWbuXJ5pvCxjxwi/u6xesg5s4/fq0PA1l9tmj8erQlpn8tugMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175483; c=relaxed/simple;
	bh=htxZ3bVJVvsltI8kCefkRLjSprinpQQ3hJ7BzHSA8gk=;
	h=Date:To:From:Subject:Message-Id; b=A54xD9W+yxWl3EhkqbPCLlDM/CVZ5yfbFwIH3ginYDBi/Zl/hF5K2usVU/GwDLIMaOZvJmiORYJsn2zPgjj9GfPO5HxBPnXpWHGrPZJLKcHYVoEr5LqLDf6fBg/FicfoCSXB9clOxWdb3X0/nMpxxm2Gt15ejp+/fq9U7cFkR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJF2cvpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJF2cvpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E425C433C7;
	Mon,  5 Feb 2024 23:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707175483;
	bh=htxZ3bVJVvsltI8kCefkRLjSprinpQQ3hJ7BzHSA8gk=;
	h=Date:To:From:Subject:From;
	b=AJF2cvpUwme7Je9a/pRos5meimmhtVBnu2y8oSqJRMEVRDeQzcLaCfegr6ASwQlgm
	 QKrOFJHEVgWJ+6XJiBlv7th+n2e+iUbQENCLeDb9NOllc0NKkGLu2nJIxMaXv5xgC0
	 wgk+W8fHOXFZTydO++IhhZynnAqq2Mxv3pmgayD4=
Date: Mon, 05 Feb 2024 15:24:42 -0800
To: mm-commits@vger.kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-drop-config_cma_debug.patch added to mm-unstable branch
Message-Id: <20240205232443.5E425C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: drop CONFIG_CMA_DEBUG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-drop-config_cma_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-drop-config_cma_debug.patch

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
Subject: mm/cma: drop CONFIG_CMA_DEBUG
Date: Mon, 5 Feb 2024 08:46:47 +0530

All pr_debug() prints in (mm/cma.c) could be enabled via standard Makefile
based method.  Besides cma_debug_show_areas() should always be called
during cma_alloc() failure path.  This seemingly redundant config,
CONFIG_CMA_DEBUG can be dropped without any problem.

Link: https://lkml.kernel.org/r/20240205031647.283510-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    9 ---------
 mm/cma.c   |    9 ---------
 2 files changed, 18 deletions(-)

--- a/mm/cma.c~mm-cma-drop-config_cma_debug
+++ a/mm/cma.c
@@ -14,11 +14,6 @@
 
 #define pr_fmt(fmt) "cma: " fmt
 
-#ifdef CONFIG_CMA_DEBUG
-#ifndef DEBUG
-#  define DEBUG
-#endif
-#endif
 #define CREATE_TRACE_POINTS
 
 #include <linux/memblock.h>
@@ -387,7 +382,6 @@ err:
 	return ret;
 }
 
-#ifdef CONFIG_CMA_DEBUG
 static void cma_debug_show_areas(struct cma *cma)
 {
 	unsigned long next_zero_bit, next_set_bit, nr_zero;
@@ -412,9 +406,6 @@ static void cma_debug_show_areas(struct
 	pr_cont("=> %lu free of %lu total pages\n", nr_total, cma->count);
 	spin_unlock_irq(&cma->lock);
 }
-#else
-static inline void cma_debug_show_areas(struct cma *cma) { }
-#endif
 
 /**
  * cma_alloc() - allocate pages from contiguous area
--- a/mm/Kconfig~mm-cma-drop-config_cma_debug
+++ a/mm/Kconfig
@@ -901,15 +901,6 @@ config CMA
 
 	  If unsure, say "n".
 
-config CMA_DEBUG
-	bool "CMA debug messages (DEVELOPMENT)"
-	depends on DEBUG_KERNEL && CMA
-	help
-	  Turns on debug messages in CMA.  This produces KERN_DEBUG
-	  messages for every CMA call as well as various messages while
-	  processing calls such as dma_alloc_from_contiguous().
-	  This option does not affect warning and error messages.
-
 config CMA_DEBUGFS
 	bool "CMA debugfs interface"
 	depends on CMA && DEBUG_FS
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-cma-dont-treat-bad-input-arguments-for-cma_alloc-as-its-failure.patch
mm-cma-drop-config_cma_debug.patch
mm-cma-make-max_cma_areas-=-config_cma_areas.patch

