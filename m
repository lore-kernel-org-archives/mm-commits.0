Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4564688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739369; cv=none; b=NWGqgWb9e/CrBmd0yjgZecAawvJSS7aeKTxr5eRWIbpr7w/NQcoyl/+j/jun2j2MstWXf8WBeISGMitS4oU3TjqAJRO1msfuPZukFRklYSrON0QyfYNYCbj0KPkG7LVTlPkGP+WMkp2eqEcsiCFkACf7b2SGF5laZx3UV1W07rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739369; c=relaxed/simple;
	bh=AWRpcqMc/iO+ouxuBijYLxM4zDdyymfWxR0uf8p/Vow=;
	h=Date:To:From:Subject:Message-Id; b=Zi6T3EuL8+B2RBCSN3l8fqSSO4rHBPeBvEtVoI+Qk2Cw+Abiw9Y2LGuZ8bHFNebmPNxYYm5u5sHuyvuL3ZlAY53qy+yHb+l3Qu8XLPn3RMnUGczY1yqAAZOCHt+Inl9kXq0YlBJC6EaJBCN91C8xIwyizdffBhNXz9T+z0BjWu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gd/g3dhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gd/g3dhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E606AC433F1;
	Sat, 24 Feb 2024 01:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739369;
	bh=AWRpcqMc/iO+ouxuBijYLxM4zDdyymfWxR0uf8p/Vow=;
	h=Date:To:From:Subject:From;
	b=Gd/g3dhzzWu+hgrJsryVa7O5nN87+vxkKAGS7xjA3KG8cLjBUMSBQMufaNtzgLjHD
	 hJSKGyBJj7TNW/POcgwHehPaUNEBwAfTVRsiBQzocF7C+U6X3H2pv/BL3dzG95z+zJ
	 AAo69zaYv1YKBnOqs9wcaXTYChj4rhgp2kHVoFWo=
Date: Fri, 23 Feb 2024 17:49:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch removed from -mm tree
Message-Id: <20240224014928.E606AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: move vmap_init_free_space() down in vmalloc.c
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: move vmap_init_free_space() down in vmalloc.c
Date: Tue, 2 Jan 2024 19:46:25 +0100

A vmap_init_free_space() is a function that setups a vmap space and is
considered as part of initialization phase.  Since a main entry which is
vmalloc_init(), has been moved down in vmalloc.c it makes sense to follow
the pattern.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20240102184633.748113-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   82 ++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc
+++ a/mm/vmalloc.c
@@ -2512,47 +2512,6 @@ void __init vm_area_register_early(struc
 	kasan_populate_early_vm_area_shadow(vm->addr, vm->size);
 }
 
-static void vmap_init_free_space(void)
-{
-	unsigned long vmap_start = 1;
-	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *busy, *free;
-
-	/*
-	 *     B     F     B     B     B     F
-	 * -|-----|.....|-----|-----|-----|.....|-
-	 *  |           The KVA space           |
-	 *  |<--------------------------------->|
-	 */
-	list_for_each_entry(busy, &vmap_area_list, list) {
-		if (busy->va_start - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = busy->va_start;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
-
-		vmap_start = busy->va_end;
-	}
-
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
-}
-
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
@@ -4465,6 +4424,47 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void vmap_init_free_space(void)
+{
+	unsigned long vmap_start = 1;
+	const unsigned long vmap_end = ULONG_MAX;
+	struct vmap_area *busy, *free;
+
+	/*
+	 *     B     F     B     B     B     F
+	 * -|-----|.....|-----|-----|-----|.....|-
+	 *  |           The KVA space           |
+	 *  |<--------------------------------->|
+	 */
+	list_for_each_entry(busy, &vmap_area_list, list) {
+		if (busy->va_start - vmap_start > 0) {
+			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+			if (!WARN_ON_ONCE(!free)) {
+				free->va_start = vmap_start;
+				free->va_end = busy->va_start;
+
+				insert_vmap_area_augment(free, NULL,
+					&free_vmap_area_root,
+						&free_vmap_area_list);
+			}
+		}
+
+		vmap_start = busy->va_end;
+	}
+
+	if (vmap_end - vmap_start > 0) {
+		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+		if (!WARN_ON_ONCE(!free)) {
+			free->va_start = vmap_start;
+			free->va_end = vmap_end;
+
+			insert_vmap_area_augment(free, NULL,
+				&free_vmap_area_root,
+					&free_vmap_area_list);
+		}
+	}
+}
+
 void __init vmalloc_init(void)
 {
 	struct vmap_area *va;
_

Patches currently in -mm which might be from urezki@gmail.com are


