Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DCD14D6EB
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520475; cv=none; b=nR4XP3+uq1zAWqlbyx8GmaEI5o0NlWEkmjwLnp9ew/CuT1XpPcnVqwk46VTvfdGm3ZCrQC8+vtXEW3ruuX99/w+GQqq1BCpYRHfc2Vdd8vUHKQscnWeBy5FFEmCDTBrdVZXEOlc/sZ4lC3BstR5K8cNpmnBEJbo6/Wklr6nP014=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520475; c=relaxed/simple;
	bh=Hzt2Nin0kriAKrT9dpV7ADWxXbcOH1twoH/cxBD1R7M=;
	h=Date:To:From:Subject:Message-Id; b=rbG4gpLl0sKPtQ+iCh+W6H2NrNcie1UZGB1AFw3MJeF30uM/uhenX288i0X8oj6Pk27fu8CYyL5VZO72RVEQ2NHxaKVJ6scjUEXIiZdzPcNV+CiLt+CK4pzxMDGiNRvlv3zODsV5t2W7X5ySekGkk5w/myBMaP+xo5UCtQHgl9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQUWb2bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQUWb2bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E853AC2BBFC;
	Thu, 27 Jun 2024 20:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719520475;
	bh=Hzt2Nin0kriAKrT9dpV7ADWxXbcOH1twoH/cxBD1R7M=;
	h=Date:To:From:Subject:From;
	b=BQUWb2bSZJgJ0w+irwNsdlBJI+7ydLSf8QevjLhNPc1851pHGhw+KrxOvYfCB3Jb5
	 W9gQuXCVTU02EzzUqtzqRJganuCrWLtTLIrUJ/CqufV5Xr0Xf8dzsPk3S6w65BoTkD
	 CZILC6sgxD7EQ5TOPzOPwf8uLfn4r4/05RYUWiOc=
Date: Thu, 27 Jun 2024 13:34:34 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-move-record_obj-into-obj_malloc.patch added to mm-unstable branch
Message-Id: <20240627203434.E853AC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: move record_obj() into obj_malloc()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-move-record_obj-into-obj_malloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-move-record_obj-into-obj_malloc.patch

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
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/zsmalloc: move record_obj() into obj_malloc()
Date: Thu, 27 Jun 2024 15:59:59 +0800

We always record_obj() to make handle points to object after obj_malloc(),
so simplify the code by moving record_obj() into obj_malloc().  There
should be no functional change.

Link: https://lkml.kernel.org/r/20240627075959.611783-2-chengming.zhou@linux.dev
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-move-record_obj-into-obj_malloc
+++ a/mm/zsmalloc.c
@@ -1306,7 +1306,6 @@ static unsigned long obj_malloc(struct z
 	void *vaddr;
 
 	class = pool->size_class[zspage->class];
-	handle |= OBJ_ALLOCATED_TAG;
 	obj = get_freeobj(zspage);
 
 	offset = obj * class->size;
@@ -1322,15 +1321,16 @@ static unsigned long obj_malloc(struct z
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!ZsHugePage(zspage)))
 		/* record handle in the header of allocated chunk */
-		link->handle = handle;
+		link->handle = handle | OBJ_ALLOCATED_TAG;
 	else
 		/* record handle to page->index */
-		zspage->first_page->index = handle;
+		zspage->first_page->index = handle | OBJ_ALLOCATED_TAG;
 
 	kunmap_atomic(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
 	obj = location_to_obj(m_page, obj);
+	record_obj(handle, obj);
 
 	return obj;
 }
@@ -1348,7 +1348,7 @@ static unsigned long obj_malloc(struct z
  */
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
 {
-	unsigned long handle, obj;
+	unsigned long handle;
 	struct size_class *class;
 	int newfg;
 	struct zspage *zspage;
@@ -1371,10 +1371,9 @@ unsigned long zs_malloc(struct zs_pool *
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj = obj_malloc(pool, zspage, handle);
+		obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
-		record_obj(handle, obj);
 		class_stat_inc(class, ZS_OBJS_INUSE, 1);
 
 		goto out;
@@ -1389,10 +1388,9 @@ unsigned long zs_malloc(struct zs_pool *
 	}
 
 	spin_lock(&class->lock);
-	obj = obj_malloc(pool, zspage, handle);
+	obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
-	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
 	class_stat_inc(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	class_stat_inc(class, ZS_OBJS_INUSE, 1);
@@ -1591,7 +1589,6 @@ static void migrate_zspage(struct zs_poo
 		free_obj = obj_malloc(pool, dst_zspage, handle);
 		zs_object_copy(class, free_obj, used_obj);
 		obj_idx++;
-		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj);
 
 		/* Stop if there is no more space */
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are

mm-zswap-use-only-one-pool-in-zswap.patch
mm-zswap-use-only-one-pool-in-zswap-v2.patch
mm-zswap-use-only-one-pool-in-zswap-v3.patch
mm-ksm-refactor-out-try_to_merge_with_zero_page.patch
mm-ksm-dont-waste-time-searching-stable-tree-for-fast-changing-page.patch
mm-ksm-optimize-the-chain-chain_prune-interfaces.patch
mm-zsmalloc-fix-class-per-fullness-zspage-counts.patch
mm-zsmalloc-move-record_obj-into-obj_malloc.patch

