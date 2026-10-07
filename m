Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAAF2F3614
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334257; cv=none; b=GmkyVHc3cIFxMsD7/EflNX/WyZnhWYLmrsOdvLXO1GaUYMO/nQburcfDFuOeRbwnxqyrulqly1Hbaka59xgO/iqAtqLX3rkYH5IInjhdJAiAqhGjlOcWK0oqwM2VTUwRdBuXa0MP871oe1NQq6BZUgnGgDaEIup/8kqScjbIV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334257; c=relaxed/simple;
	bh=k8nzvyFy5m1dZUWk7THDtJL6SlypZPEB/FryQu2kRa8=;
	h=Date:To:From:Subject:Message-Id; b=G8nkSLp/HI0bPoPzeaFlsph8OcuD+4FnTiSyZJu57LuDb2z60Rrq1J/8xcLI2ODEKgfoOnrVrX9SjQs+iS1zGiwoHzF6fFpY2MEaupqtcbJFBfqXIbIylCOH6ubgtNqbZsMVBoe56teEtmuMnQPFhPieVbo2Z7FuYEMtT+AX5IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OjYZXovD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OjYZXovD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117161F0089C;
	Wed,  7 Oct 2026 00:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334256;
	bh=ONbxgpiUBkOPlkpXFOBoPwx2DjCHEKnN2EGBQuo1/fc=;
	h=Date:To:From:Subject;
	b=OjYZXovDVm4fWqYRu75sJJWW9VUM/96W8z6Q8ln/CM/qSwrZ80VO5LwfFuuUYytuH
	 DkihR8ZxS3X7QNunJcIuC5f1dUkqTZ9mHNviF0RTMD2JsKt7ZXLXzPdBavK7+PUyRg
	 OJPzS392UfFscxqwZ6YBLUMQCcfJaf2LOMiJlm0E=
Date: Tue, 06 Oct 2026 17:50:55 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,eamon112009@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch removed from -mm tree
Message-Id: <20261007005056.117161F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: cma: make mm/cma.h self-contained and conditionalize includes
has been removed from the -mm tree.  Its filename was
     mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eamon Sippy <eamon112009@gmail.com>
Subject: mm: cma: make mm/cma.h self-contained and conditionalize includes
Date: Sat, 15 Aug 2026 10:32:45 +0000

mm/cma.h uses types from <linux/spinlock.h>, <linux/mutex.h>,
<linux/atomic.h> and <linux/list.h> without explicitly including them,
violating the kernel header self-containment guidelines.

<linux/debugfs.h> and <linux/kobject.h> are also included unconditionally
even though they are only needed under CONFIG_CMA_DEBUGFS and
CONFIG_CMA_SYSFS respectively.  Move the struct cma_kobject definition and
<linux/kobject.h> inside the CONFIG_CMA_SYSFS block, and move
<linux/debugfs.h> inside CONFIG_CMA_DEBUGFS.

Remove spurious trailing semicolons after the empty inline function bodies
in the CONFIG_CMA_SYSFS #else branch.

Add <linux/cma.h> so that MAX_CMA_AREAS and CMA_MAX_NAME are always
available when this header is included.

Link: https://lore.kernel.org/20260815103246.5315-1-eamon112009@gmail.com
Signed-off-by: Eamon Sippy <eamon112009@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---

 mm/cma.h |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/cma.h~mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes
+++ a/mm/cma.h
@@ -2,14 +2,24 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#include <linux/atomic.h>
 #include <linux/cma.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#ifdef CONFIG_CMA_DEBUGFS
 #include <linux/debugfs.h>
+#endif
+
+#ifdef CONFIG_CMA_SYSFS
 #include <linux/kobject.h>
 
 struct cma_kobject {
 	struct kobject kobj;
 	struct cma *cma;
 };
+#endif
 
 /*
  * Multi-range support. This can be useful if the size of the allocation
@@ -38,10 +48,10 @@ struct cma_memrange {
 #define CMA_MAX_RANGES 8
 
 struct cma {
-	unsigned long   count;
-	unsigned long	available_count;
+	unsigned long count;
+	unsigned long available_count;
 	unsigned int order_per_bit; /* Order of pages represented by one bit */
-	spinlock_t	lock;
+	spinlock_t lock;
 	struct mutex alloc_mutex;
 #ifdef CONFIG_CMA_DEBUGFS
 	struct hlist_head mem_head;
@@ -87,10 +97,11 @@ void cma_sysfs_account_fail_pages(struct
 void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
 #else
 static inline void cma_sysfs_account_success_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 static inline void cma_sysfs_account_fail_pages(struct cma *cma,
-						unsigned long nr_pages) {};
+						unsigned long nr_pages) {}
 static inline void cma_sysfs_account_release_pages(struct cma *cma,
-						   unsigned long nr_pages) {};
+						   unsigned long nr_pages) {}
 #endif
+
 #endif
_

Patches currently in -mm which might be from eamon112009@gmail.com are


