Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBACF14A94
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560190; cv=none; b=GhwfPLlqZPhgBSlaQ9/KAP7VhUBkumP22Z0KAezVDVgnTPYD63nzExKgL45qABOugu1AJnV28pj3z1Xj5pqMYoV8UuYVV8xRj/5FFl1TRYbRHG844/XqZL0s978+wFCzM8L3NkT9NjwV3IlgyzQfFU3B2KAVMO8ff7fkZOIgUW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560190; c=relaxed/simple;
	bh=yMUsxdRDcHdmyu/BjaJ5E7Wi/0UPxNTinGMfFbF2nsA=;
	h=Date:To:From:Subject:Message-Id; b=fynG3DUoY1Gl02Tfc6vhUZDJOf4Nik2wwlGO8GttXaQfTQeg3zJeWlRV/0f46d3AEhDwDwfsyHWP6tF15ws2WNkGKIgAGmm3G9OsWPM5+VN0jo7NV6NLAqur1Y6M6wf42V1r9eHPZqeBkofeJL1zOlqA8fggFYRUaL4/PYPh41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U1mQQMam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U1mQQMam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48537C43390;
	Thu, 22 Feb 2024 00:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560190;
	bh=yMUsxdRDcHdmyu/BjaJ5E7Wi/0UPxNTinGMfFbF2nsA=;
	h=Date:To:From:Subject:From;
	b=U1mQQMamdcK0si6vCk3SdWL2O7IbrzPl+HkvRDcj0mIAOgy8iyrVmYYNdf4I8MWVI
	 N5BmDIJBzjjtymSZVpu2OUn0/QHzggHtZRlAvQZNbNT1VM5u9wchNJyWWC3/rJDqSa
	 ZJBMwaU0sQBf0sDT72UAdfobqF2oqTYMqY35SfwM=
Date: Wed, 21 Feb 2024 16:03:09 -0800
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,m.szyprowski@samsung.com,lukas.bulwahn@gmail.com,hch@lst.de,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-drop-config_cma_debug.patch removed from -mm tree
Message-Id: <20240222000310.48537C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: drop CONFIG_CMA_DEBUG
has been removed from the -mm tree.  Its filename was
     mm-cma-drop-config_cma_debug.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/cma: drop CONFIG_CMA_DEBUG
Date: Mon, 5 Feb 2024 08:46:47 +0530

All pr_debug() prints in (mm/cma.c) could be enabled via standard Makefile
based method.  Besides cma_debug_show_areas() should always be called
during cma_alloc() failure path.  This seemingly redundant config,
CONFIG_CMA_DEBUG can be dropped without any problem.

[lukas.bulwahn@gmail.com: remove debug code to removed CONFIG_CMA_DEBUG]
  Link: https://lkml.kernel.org/r/20240207143825.986-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20240205031647.283510-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/contiguous.c |    6 ------
 mm/Kconfig              |    9 ---------
 mm/cma.c                |    9 ---------
 3 files changed, 24 deletions(-)

--- a/kernel/dma/contiguous.c~mm-cma-drop-config_cma_debug
+++ a/kernel/dma/contiguous.c
@@ -37,12 +37,6 @@
 
 #define pr_fmt(fmt) "cma: " fmt
 
-#ifdef CONFIG_CMA_DEBUG
-#ifndef DEBUG
-#  define DEBUG
-#endif
-#endif
-
 #include <asm/page.h>
 
 #include <linux/memblock.h>
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


