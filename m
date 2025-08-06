Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6840145346
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754522054; cv=none; b=XBbTjwq9gf4oXwCO4obE9cvdbYBuoV+P4M9AqI6MEMobCPR6HycPMCSfzd7n0QutfGKh6HKj5XFiT233I5m3/IGSu63vQq/1BxvX0UgKlBpp+KurxkLDtSWDqmDMoY1N+N5kejj4HGf5+oUf2bAQA1g//9OwlCm6i54YlcoiIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754522054; c=relaxed/simple;
	bh=ro6rOnc7VHCQ2Q70jTvgU2FoO2KmWbapIjtTiaOyWrQ=;
	h=Date:To:From:Subject:Message-Id; b=q8jZWjmJAQR/3TJvTgHPlTDOaCb9millUr9Kz00KeC3H2UkjOvHc5rvMJd0AeFl3E7vd7hPBj0BByTV9c+vKVu1LXS8cvFaX2jT6kljkhyeV6HRkTfPy4+YS6SOJwlgQtnquk0LgF0pfW77P/Zv2A6BGRV/06820GWYecW9KQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+tgv/Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+tgv/Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE90C4CEE7;
	Wed,  6 Aug 2025 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754522054;
	bh=ro6rOnc7VHCQ2Q70jTvgU2FoO2KmWbapIjtTiaOyWrQ=;
	h=Date:To:From:Subject:From;
	b=N+tgv/Eu2gKVbPDxm/o1+NaD4Jg4fBNq48gR4wojDEOhxgkcVZDrMOtnA/iD9d5tN
	 Wp9RdgAcn8LlGWqpPnjdjQeCz24RAhjTKht3WTJTuKPIghOqtI7SmcsmrlCVQyDbMC
	 dhZUX5j0GUUF51djnbEg8qBxwti9TONAh5J+mBQU=
Date: Wed, 06 Aug 2025 16:14:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,jannh@google.com,herbert@gondor.apana.org.au,dakr@kernel.org,aliceryhl@google.com,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-support-large-alignments-in-allocations.patch added to mm-new branch
Message-Id: <20250806231414.2FE90C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: support large alignments in allocations
has been added to the -mm mm-new branch.  Its filename is
     rust-support-large-alignments-in-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-support-large-alignments-in-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Vitaly Wool <vitaly.wool@konsulko.se>
Subject: rust: support large alignments in allocations
Date: Wed, 6 Aug 2025 14:55:52 +0200

Add support for large (> PAGE_SIZE) alignments in Rust allocators.  All
the preparations on the C side are already done, we just need to add
bindings for <alloc>_node_align() functions and start using those.

Link: https://lkml.kernel.org/r/20250806125552.1727073-1-vitaly.wool@konsulko.se
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Alice Ryhl <aliceryhl@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jann Horn <jannh@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/slab.c            |   10 ++++++----
 rust/helpers/vmalloc.c         |    5 +++--
 rust/kernel/alloc/allocator.rs |   30 +++++++++---------------------
 3 files changed, 18 insertions(+), 27 deletions(-)

--- a/rust/helpers/slab.c~rust-support-large-alignments-in-allocations
+++ a/rust/helpers/slab.c
@@ -3,13 +3,15 @@
 #include <linux/slab.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_krealloc_node(const void *objp, size_t new_size, gfp_t flags, int node)
+rust_helper_krealloc_node_align(const void *objp, size_t new_size, unsigned long align,
+				gfp_t flags, int node)
 {
-	return krealloc_node(objp, new_size, flags, node);
+	return krealloc_node_align(objp, new_size, align, flags, node);
 }
 
 void * __must_check __realloc_size(2)
-rust_helper_kvrealloc_node(const void *p, size_t size, gfp_t flags, int node)
+rust_helper_kvrealloc_node_align(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int node)
 {
-	return kvrealloc_node(p, size, flags, node);
+	return kvrealloc_node_align(p, size, align, flags, node);
 }
--- a/rust/helpers/vmalloc.c~rust-support-large-alignments-in-allocations
+++ a/rust/helpers/vmalloc.c
@@ -3,7 +3,8 @@
 #include <linux/vmalloc.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_vrealloc_node(const void *p, size_t size, gfp_t flags, int node)
+rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
+				gfp_t flags, int node)
 {
-	return vrealloc_node(p, size, flags, node);
+	return vrealloc_node_align(p, size, align, flags, node);
 }
--- a/rust/kernel/alloc/allocator.rs~rust-support-large-alignments-in-allocations
+++ a/rust/kernel/alloc/allocator.rs
@@ -15,7 +15,6 @@ use core::ptr::NonNull;
 
 use crate::alloc::{AllocError, Allocator, NumaNode};
 use crate::bindings;
-use crate::pr_warn;
 
 /// The contiguous kernel allocator.
 ///
@@ -56,25 +55,26 @@ fn aligned_size(new_layout: Layout) -> u
 
 /// # Invariants
 ///
-/// One of the following: `krealloc_node`, `vrealloc_node`, `kvrealloc_node`.
+/// One of the following: `krealloc_node_align`, `vrealloc_node_align`, `kvrealloc_node_align`.
 struct ReallocFunc(
     unsafe extern "C" fn(
         *const crate::ffi::c_void,
         usize,
+        crate::ffi::c_ulong,
         u32,
         crate::ffi::c_int,
     ) -> *mut crate::ffi::c_void,
 );
 
 impl ReallocFunc {
-    // INVARIANT: `krealloc_node` satisfies the type invariants.
-    const KREALLOC: Self = Self(bindings::krealloc_node);
+    // INVARIANT: `krealloc_node_align` satisfies the type invariants.
+    const KREALLOC: Self = Self(bindings::krealloc_node_align);
 
-    // INVARIANT: `vrealloc_node` satisfies the type invariants.
-    const VREALLOC: Self = Self(bindings::vrealloc_node);
+    // INVARIANT: `vrealloc_node_align` satisfies the type invariants.
+    const VREALLOC: Self = Self(bindings::vrealloc_node_align);
 
-    // INVARIANT: `kvrealloc_node` satisfies the type invariants.
-    const KVREALLOC: Self = Self(bindings::kvrealloc_node);
+    // INVARIANT: `kvrealloc_node_align` satisfies the type invariants.
+    const KVREALLOC: Self = Self(bindings::kvrealloc_node_align);
 
     /// # Safety
     ///
@@ -116,7 +116,7 @@ impl ReallocFunc {
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, flags.0, nid.0).cast()
+            self.0(ptr.cast(), size, layout.align(), flags.0, nid.0).cast()
         };
 
         let ptr = if size == 0 {
@@ -160,12 +160,6 @@ unsafe impl Allocator for Vmalloc {
         flags: Flags,
         nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("Vmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
-
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
         unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags, nid) }
@@ -185,12 +179,6 @@ unsafe impl Allocator for KVmalloc {
         flags: Flags,
         nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("KVmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
-
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
         unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags, nid) }
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch
mm-slub-allow-to-set-node-and-align-in-krealloc.patch
rust-add-support-for-numa-ids-in-allocations.patch
rust-support-large-alignments-in-allocations.patch

