Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84E2EEE84
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865919; cv=none; b=XeK47CLsUI1JWkWJs+WbitAiEVMELxsk7HOg+mAE3Q99s0wX0OCxm3RxS0L7g1aMI2NtOMbrDhNOHiyhPiAQ6TFwuw8AHU7L3gAP/RxpSRxconN4MJCR1LfL4dqyY23NhIjFtDZa9bapmFRUXSqq/nlcgPpx4h3MXuMcTwGsMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865919; c=relaxed/simple;
	bh=5ZBlROKf78HSaPrKq09em7vIEHiKlVq3QviIdf0v7QY=;
	h=Date:To:From:Subject:Message-Id; b=Var75X3kDs0H6jLk3fwZ81xuI8noKx271R8LZMxneeqC1COXr+KquCdgf6VIvkmo0IOqUxYmWIq0QOTXKt3mZl0xPRVhW+eAYYLXH/VqZdjgcAkyJDdBhTWqflvHle+DMRCeC2jB9cfXJbmLpbGs/T/UgTiUozC60pEfGJ+xETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mN5R3geP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mN5R3geP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED911F000FF;
	Tue, 13 Oct 2026 04:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865918;
	bh=nf+zF816otk/XTtnN41IEPQr1K41uwackikofwLGh40=;
	h=Date:To:From:Subject;
	b=mN5R3gePhf7kpBfJvwan4+kjfD4F6sKuY9LHHS3XmMr6uUynPgKyuNciZ8YOaopDi
	 RHi8DomsAUZbqJQFM/QuXpbFJvIV4e4QK6JQHdyvK9NfoGqLmQben3v7v8/A3PK9Lk
	 9TvmIlI7yBeNYAeMOpkLs2DVpLr1POOLS18++iYs=
Date: Mon, 12 Oct 2026 21:31:58 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-extract-vmap_insert_free_area-helper.patch removed from -mm tree
Message-Id: <20261013043158.6ED911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract vmap_insert_free_area helper
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-vmap_insert_free_area-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: extract vmap_insert_free_area helper
Date: Tue, 15 Sep 2026 10:43:31 +0800

The allocation and insertion of a free vmap_area is duplicated between the
loop body and the tail of vmap_init_free_space.  Factor it into a small
helper so the main function only deals with computing the free gaps
between busy regions.

Link: https://lore.kernel.org/20260915-vmalloc_study-v2-2-cc4dfe635e22@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---

 mm/vmalloc.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_insert_free_area-helper
+++ a/mm/vmalloc.c
@@ -5419,11 +5419,23 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
+{
+	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+
+	if (!WARN_ON_ONCE(!free)) {
+		free->va_start = start;
+		free->va_end = end;
+		insert_vmap_area_augment(free, NULL,
+					 &free_vmap_area_root,
+					 &free_vmap_area_list);
+	}
+}
+
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *free;
 	struct vm_struct *busy;
 
 	/*
@@ -5433,32 +5445,15 @@ static void __init vmap_init_free_space(
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if ((unsigned long) busy->addr - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = (unsigned long) busy->addr;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
+		if ((unsigned long) busy->addr - vmap_start > 0)
+			vmap_insert_free_area(vmap_start,
+					      (unsigned long) busy->addr);
 
 		vmap_start = (unsigned long) busy->addr + busy->size;
 	}
 
-	if (vmap_end - vmap_start > 0) {
-		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (!WARN_ON_ONCE(!free)) {
-			free->va_start = vmap_start;
-			free->va_end = vmap_end;
-
-			insert_vmap_area_augment(free, NULL,
-				&free_vmap_area_root,
-					&free_vmap_area_list);
-		}
-	}
+	if (vmap_end - vmap_start > 0)
+		vmap_insert_free_area(vmap_start, vmap_end);
 }
 
 static void vmap_init_nodes(void)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmalloc_dump_obj-address-alignment-for-last-page-lookups.patch
mm-vmalloc-fix-vmalloc_dump_obj-cross-zone-va-lookup.patch

