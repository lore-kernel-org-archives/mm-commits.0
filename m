Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C1EC83F33
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjIDTyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbjIDTyC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39F3CDB
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78808614C1
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE386C433C8;
        Mon,  4 Sep 2023 19:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857234;
        bh=I4qfWvO9vt15hc2irE1XllfaXGt8QZYCB9D9PuA6iNs=;
        h=Date:To:From:Subject:From;
        b=T1o+zEICeCxCzJfheJKGYhfxxicXvRU3FAkhvZGN/Zz4oiXYZ0UIXy2WIHcrX30mF
         9IGY4bA0v5RBlm9a28sBGWkLwHiyRc93j5Xaj6u3/jmMLYqlBAjxzSSoHquQfP5/R5
         q5aBE6CxjcCqTiCiscWrtDLyXDiaLMx+3mO0hCoc=
Date:   Mon, 04 Sep 2023 12:53:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch added to mm-unstable branch
Message-Id: <20230904195354.CE386C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: move vmap_init_free_space() down in vmalloc.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: move vmap_init_free_space() down in vmalloc.c
Date: Tue, 29 Aug 2023 10:11:36 +0200

A vmap_init_free_space() is a function that setups a vmap space and is
considered as part of initialization phase.  Since a main entry which is
vmalloc_init(), has been moved down in vmalloc.c it makes sense to follow
the pattern.

There is no a functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20230829081142.3619-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
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

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

