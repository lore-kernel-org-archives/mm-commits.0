Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5878C84
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103887; cv=none; b=lbsmdtxpFY4iByPSnGjJLBqdAn68pld9jaES/cqJSvRHmMANvJrqSu341Vdp5hwFZyys6DdvnFXMIbl3JViPKzbeRuN0dDJQ0x/Kih684mi+MnrcwbMe3hSzYKSTIozey4C6zRg/wQqRy847lqtJ3WFXpMX93wi+ex8DufSgxiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103887; c=relaxed/simple;
	bh=6Wg3dY3wyb8VAzw9ZiZMX6wCvolc2AtqKNQdy3XO6yM=;
	h=Date:To:From:Subject:Message-Id; b=KQvaPmvCHb1KiUUzyRDHueXRMK7Bt0WNFjagZSknZIHZgTHrS8hItlgStK6PiwPNHikRQiLJ2Cu1JTYl+Nak91d4axt5xDqcx5Pmz0ueLi3tNJwrh3rL3jb0MunoVfO/wYPENI2Iw6lqfx219tmSq87IwEZnVNFB7mPiGSQ4Ovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yVqx0fhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yVqx0fhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE59C113CD;
	Fri, 26 Apr 2024 03:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103886;
	bh=6Wg3dY3wyb8VAzw9ZiZMX6wCvolc2AtqKNQdy3XO6yM=;
	h=Date:To:From:Subject:From;
	b=yVqx0fhIzchuu3OAuY/QypqV0rSGDJYe/715uIXiCYZDQihWVKQVu8XO0Qyo9uSF0
	 DuaaJp4rBOfArAnMaaJqKMKi7cPMA9+xe8LYEKvY5WBi4ilGeyYRJ2FDdMfHD4tFI4
	 /GHgfXz9DMIW8g468CGV1KjEMuZJ+0/lggLKbltI=
Date: Thu, 25 Apr 2024 20:58:06 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch removed from -mm tree
Message-Id: <20240426035806.BAE59C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
has been removed from the -mm tree.  Its filename was
     mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
Date: Thu, 21 Mar 2024 09:36:30 -0700

Slab extension objects can't be allocated before slab infrastructure is
initialized.  Some caches, like kmem_cache and kmem_cache_node, are
created before slab infrastructure is initialized.  Objects from these
caches can't have extension objects.  Introduce SLAB_NO_OBJ_EXT slab flag
to mark these caches and avoid creating extensions for objects allocated
from these slabs.

Link: https://lkml.kernel.org/r/20240321163705.3067592-9-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   10 ++++++++++
 mm/slub.c            |    5 +++--
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/slab.h~mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation
+++ a/include/linux/slab.h
@@ -56,6 +56,9 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
+#ifdef CONFIG_SLAB_OBJ_EXT
+	_SLAB_NO_OBJ_EXT,
+#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -202,6 +205,13 @@ enum _slab_flag_bits {
 #endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
+/* Slab created using create_boot_cache */
+#ifdef CONFIG_SLAB_OBJ_EXT
+#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
+#else
+#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
+#endif
+
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
  *
--- a/mm/slub.c~mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation
+++ a/mm/slub.c
@@ -5693,7 +5693,8 @@ void __init kmem_cache_init(void)
 		node_set(node, slab_nodes);
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
-		sizeof(struct kmem_cache_node), SLAB_HWCACHE_ALIGN, 0, 0);
+			sizeof(struct kmem_cache_node),
+			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
 	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
@@ -5703,7 +5704,7 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache, "kmem_cache",
 			offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *),
-		       SLAB_HWCACHE_ALIGN, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
 	kmem_cache = bootstrap(&boot_kmem_cache);
 	kmem_cache_node = bootstrap(&boot_kmem_cache_node);
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

