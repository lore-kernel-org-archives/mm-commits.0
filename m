Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E7913A244
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 04:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782621373; cv=none; b=rPvpkcEDh+ulqjqTEYbIjNrCqEfZuCLz86vLUsNuoOa/jDW57UC8sawVB8gn8seRbmfw/nMp8V1nxdQxAnC4MdyovGHRcOCzEIVUk4QJ1qwfpaUz9cm/7FuiNqaSpDyf+LYyP5ynhC997Y430E38IMZnv23XyJOmiD0EvWx5tQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782621373; c=relaxed/simple;
	bh=86ZXyelu9hf64Kv3EG4GBemAnf0aRfSCjiEI53btx8I=;
	h=Date:To:From:Subject:Message-Id; b=BEm86NQi5eduaE+l4DBZZ8jql+PQpkYujDY1O5998hdRRr/gEjcKPz5xq9aPvS10wdG+kEXmbnNmvUvpjW10xD3y4y2QrzjXjIBzSZkGHV6GgTy1QWos+9lFPvKEJA719kM+2QbaEUc0bCl+O3mOI1tWpRTkTrF/VQbIv1cMMsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYV0AmDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYV0AmDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047131F000E9;
	Sun, 28 Jun 2026 04:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782621372;
	bh=rNVw1NGM8qK3L5/Jx9/PUYfcAQDgGO902AnksgKYFq8=;
	h=Date:To:From:Subject;
	b=cYV0AmDLi6Q2SJTxuCydbGe5KK+sdmec9prCCZ9y5ZSi2ErjHwU6v6Y1P88GoNHYR
	 GK6ETEA9KUgcyGwvj2uagqapYt9VyUPNw4CSuRaNTG8Q8OQapdpLfWlS8sx+rrDVr3
	 dO84ipZyTiPLVW5VR/97y8IjN8QVvWPllVMoZs7U=
Date: Sat, 27 Jun 2026 21:36:11 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch added to mm-new branch
Message-Id: <20260628043612.047131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: drop class lock before freeing zspage
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch

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
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: mm/zsmalloc: drop class lock before freeing zspage
Date: Fri, 26 Jun 2026 09:50:02 +0800

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated.  However, freeing pages
back to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe.  When
this happens, the CPU holding the class->lock will stall waiting for the
zone lock, thereby blocking all other CPUs attempting to acquire the same
class->lock.

This patch shrinks the critical section of the class->lock to reduce lock
contention.  By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Link: https://lore.kernel.org/20260626015003.2965881-4-haowenchao22@gmail.com
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-class-lock-before-freeing-zspage
+++ a/mm/zsmalloc.c
@@ -883,13 +883,10 @@ unlock:
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -905,7 +902,13 @@ static void __free_zspage(struct zs_pool
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+			  struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1518,6 +1521,7 @@ void zs_free(struct zs_pool *pool, unsig
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1528,10 +1532,23 @@ void zs_free(struct zs_pool *pool, unsig
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				       class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else {
+			kick_deferred_free(pool);
+		}
+	}
 
 	spin_unlock(&class->lock);
+
+	if (zspage_to_free) {
+		__free_zspage_lockless(zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
_

Patches currently in -mm which might be from xueyuan.chen21@gmail.com are

mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch

