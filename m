Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC517C9
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 07:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726559914; cv=none; b=h6f5/Nm5xA0P3GkIuom/JTCkM4/tnBS9/ig/j2VJF8jm0K/OzoGThVFz9E0FN4ikVvLunHlzinusiS2rhCVFCrX8/RDUGYJavf1BgfiZjNxoMJ8j4hVsrg46YxoTHE24rZOKPS/qFfobP9RNvsF4g+gvTXb7ly8WepVscVr1Zpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726559914; c=relaxed/simple;
	bh=WWJSZVGGLWNSQcye3Q1IrYlYaClYXjNLdYHl1P3uh+4=;
	h=Date:To:From:Subject:Message-Id; b=j6pNbVLvIXJHTK7MFnkKZxCjV+0IpmMLG4c6GS0/oGOnnKpz7mbe+rQWWdM9B3M4CbUpV3XtgOX4i521l/IY5tszcrBSbaEZyOYjW1ysUXV9qVMovxo2/eD5YnaOGk1J68EA0o9xyImqxuDGPAMOhdMg9ARKrBYHVQ0F7rn/U5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zqf2yimk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zqf2yimk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5827BC4CEC6;
	Tue, 17 Sep 2024 07:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726559913;
	bh=WWJSZVGGLWNSQcye3Q1IrYlYaClYXjNLdYHl1P3uh+4=;
	h=Date:To:From:Subject:From;
	b=Zqf2yimkvtvAKhFv/86skFRiILnmr/XAkJgnAia+S90oRpyoJBj7CmArZug6zCrGv
	 dKPrsMzNhK4H5N/YCZBxt9jZ65dhsn4ZJREx65IKSPDG9p5YgI0Y250gtUh0ifqK5t
	 lkHRwkgHHBMc/EyEBGjUHc8P5AhCt/j5leuMT2S4=
Date: Tue, 17 Sep 2024 00:58:30 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zsmalloc-use-unique-zsmalloc-caches-names.patch removed from -mm tree
Message-Id: <20240917075833.5827BC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: use unique zsmalloc caches names
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-unique-zsmalloc-caches-names.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: use unique zsmalloc caches names
Date: Fri, 6 Sep 2024 12:45:44 +0900

Each zsmalloc pool maintains several named kmem-caches for zs_handle-s and
zspage-s.  On a system with multiple zsmalloc pools and CONFIG_DEBUG_VM
this triggers kmem_cache_sanity_check():

  kmem_cache of name 'zspage' already exists
  WARNING: at mm/slab_common.c:108 do_kmem_cache_create_usercopy+0xb5/0x310
  ...

  kmem_cache of name 'zs_handle' already exists
  WARNING: at mm/slab_common.c:108 do_kmem_cache_create_usercopy+0xb5/0x310
  ...

We provide zram device name when init its zsmalloc pool, so we can use
that same name for zsmalloc caches and, hence, create unique names that
can easily be linked to zram device that has created them.

So instead of having this

cat /proc/slabinfo
slabinfo - version: 2.1
zspage                46     46    ...
zs_handle            128    128    ...
zspage             34270  34270    ...
zs_handle          34816  34816    ...
zspage                 0      0    ...
zs_handle              0      0    ...

We now have this

cat /proc/slabinfo
slabinfo - version: 2.1
zspage-zram2          46     46    ...
zs_handle-zram2      128    128    ...
zspage-zram0       34270  34270    ...
zs_handle-zram0    34816  34816    ...
zspage-zram1           0      0    ...
zs_handle-zram1        0      0    ...

Link: https://lkml.kernel.org/r/20240906035103.2435557-1-senozhatsky@chromium.org
Fixes: 2e40e163a25a ("zsmalloc: decouple handle and object")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-use-unique-zsmalloc-caches-names
+++ a/mm/zsmalloc.c
@@ -54,6 +54,7 @@
 #include <linux/vmalloc.h>
 #include <linux/preempt.h>
 #include <linux/spinlock.h>
+#include <linux/sprintf.h>
 #include <linux/shrinker.h>
 #include <linux/types.h>
 #include <linux/debugfs.h>
@@ -293,17 +294,27 @@ static void SetZsPageMovable(struct zs_p
 
 static int create_cache(struct zs_pool *pool)
 {
-	pool->handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
-					0, 0, NULL);
+	char *name;
+
+	name = kasprintf(GFP_KERNEL, "zs_handle-%s", pool->name);
+	if (!name)
+		return -ENOMEM;
+	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
+						0, 0, NULL);
+	kfree(name);
 	if (!pool->handle_cachep)
-		return 1;
+		return -EINVAL;
 
-	pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
-					0, 0, NULL);
+	name = kasprintf(GFP_KERNEL, "zspage-%s", pool->name);
+	if (!name)
+		return -ENOMEM;
+	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
+						0, 0, NULL);
+	kfree(name);
 	if (!pool->zspage_cachep) {
 		kmem_cache_destroy(pool->handle_cachep);
 		pool->handle_cachep = NULL;
-		return 1;
+		return -EINVAL;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-free-secondary-algorithms-names.patch
zram-free-secondary-algorithms-names-v2.patch

