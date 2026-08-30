Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBBF2222A9
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788053582; cv=none; b=R4wajCneIuZX9AW5dNK6h9Jz81rIAbWV/r+bD5mLwQ+pO7fjLF6NWL4tHHAVWitbPgnOjxuMTPpAJPogPW31lt9KZkXD3XhNlQSQ6a0s9bQTA3UFivE0ctAOpFN8vqEdyqq1B2jXMF9BI3iiDT3t6cDIsgU2iMicA+8N13a0Z54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788053582; c=relaxed/simple;
	bh=GbTYkF+tFtQyEEpX5T4H+TEvsPbq9cThA9+HZ/PJ+y0=;
	h=Date:To:From:Subject:Message-Id; b=XAqUoK+/yh53B+EaiXi1+g9doVYzKIK97E+kSeCV5tS14zTft3CYbLqyNzhb2DU7tFCME8q7xUZtTYTL9n7KjI4nfOQ7nxzO6UXBdTBW7b+9By5L6ilDsqXo9YlAbVcnjjEOIwJk5VURJWwXtuvwqUeR6ksfSLnXQ2HpPIbXheg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnnrcaG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnnrcaG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A91F00A3D;
	Sun, 30 Aug 2026 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788053581;
	bh=m1kiNdyl497p/u6dwuS+yUNbzsmUSwycNN4yruN+sAc=;
	h=Date:To:From:Subject;
	b=NnnrcaG07VY4BCFopYyKDb15oOgk42d6VNo9YRz0/hYpaBtsDm5kVF0OPORJCoauK
	 vAG3f8SfyiJVTYEfW5rIH9WpHsY/n3gYUGwweLcqWSvWXM32QzwLhlPXAcxoJCcT8I
	 XZ+96G6QBFM4CON1k3k8GcpcMREAKZsMXx6KqsZ0=
Date: Sat, 29 Aug 2026 18:33:00 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,eamon112009@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch added to mm-new branch
Message-Id: <20260830013300.E10A91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cma: make mm/cma.h self-contained and conditionalize includes
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-cma-make-mm-cmah-self-contained-and-conditionalize-includes.patch

