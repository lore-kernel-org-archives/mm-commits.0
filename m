Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F563911BC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298498; cv=none; b=BUZlz86Zw1YRJjmZOmPjihB1F6JSG53AnqIaKJDGXO/5MZZYKIcBD6BMo26FfewTH7y8UuFMgbleT6AlBai4mHuQuz7N+GseJQ8MaBajqTXxUR0sDb3ptOr8+MWWWRFIyJTDsMdnDlvldMi+WqMnPiLWMLT67n2bAJQnLbxwOlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298498; c=relaxed/simple;
	bh=QIW2frKWn3fh51z9uqNxsgouMCvD75QsDd+Vz7QaEsc=;
	h=Date:To:From:Subject:Message-Id; b=RziaQwbph10Lv76Bmuxy9Vs/ZleZUXuXc+l9B0TiayrZ6cDTcRmBZQW/QSrm0zN/wlTWLaCRPDzLjvzg7A4PsafmdsEJuYBxy8rWvT4ygid0NZU74tpurPvEN/T/lZOUueloge8XNkz7R7CJkKPHtEl2dLzzLS5gxxpzBhNiN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tvFSrqpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tvFSrqpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF71F000E9;
	Wed, 29 Jul 2026 04:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298496;
	bh=L/CtFN4afNEi3bWcd+/8sqfDZLxExcGUsZC31sej6d8=;
	h=Date:To:From:Subject;
	b=tvFSrqpHCu1SOsZ4HbhWzHFn8UY6D5L5jASr4RYZnYzT/S3+JMsHNebyThFnxvt86
	 OiAldeTTkmm5uUwUHUnQWCfcKY3v95Bh/DeK3Es1y+2KjVZlJxNFd1RF8+o5DTkJ8b
	 LB3VsfUj/CfUe8z16PAWzuMYaS2gXCoR6Oa4OX6g=
Date: Tue, 28 Jul 2026 21:14:56 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,xueyuan.chen21@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch removed from -mm tree
Message-Id: <20260729041456.B3BF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: drop class lock before freeing zspage
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-drop-class-lock-before-freeing-zspage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -877,13 +877,10 @@ unlock:
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
 
@@ -899,7 +896,13 @@ static void __free_zspage(struct zs_pool
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
@@ -1520,6 +1523,7 @@ void zs_free(struct zs_pool *pool, unsig
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1530,10 +1534,23 @@ void zs_free(struct zs_pool *pool, unsig
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


