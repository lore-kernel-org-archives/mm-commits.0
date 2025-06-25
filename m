Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849DB1FBCB2
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750885971; cv=none; b=T2ZC+2/Pk/4VjxurFfT8cl8d8oph6jKmR1VJFRoefAXxuHvfIOTlvJmcM0dWvex4RpNqX4/ziEKFXgTG6yL89imFtTZ3Y2eS7GwJp1ImaJnKil387vx7nnfIatjYpRj5cNNg9jwfkq0UBGcAOv/v0vlDFNvroBsHaeV+ZlY6MDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750885971; c=relaxed/simple;
	bh=YGEs1p7bRiQRetzHjn1DBZBiNfq/zSVuxhWa6iMe83c=;
	h=Date:To:From:Subject:Message-Id; b=PImwfMm1DyxpnlyW+Yr2wg4kqai8zCwsE92sa1bHBm7wopouOvomwtQfkxXvbATwMFfJAKDno9HcJ3KRceWa4I5a0HOT0WHAdnSjrjQKSHFTAd4H1EW2DT6+Jb3SHEIWxiJona20VTyU4vojI4toswtNfAPRgaUFemx8yqmy9WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxpPu2k5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxpPu2k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035F9C4CEEA;
	Wed, 25 Jun 2025 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750885971;
	bh=YGEs1p7bRiQRetzHjn1DBZBiNfq/zSVuxhWa6iMe83c=;
	h=Date:To:From:Subject:From;
	b=UxpPu2k5bSSvH2mjhS743gJrBX5F7uckKPAh5L7EAq8UbfpyyoHBVuz00y3VB/+4x
	 CEURz+3tfEq+NLmUSktgZgH0jK3roZy4KbkBQMeix9G0xNd/TyOzgMPeIp7EiIkGxQ
	 OnM1u8vgXX4mH3C6kviR8ik6idQZlA0Frtq3n9A4=
Date: Wed, 25 Jun 2025 14:12:50 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-support-align-and-numa-id-in-allocations.patch added to mm-new branch
Message-Id: <20250625211251.035F9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: support align and NUMA id in allocations
has been added to the -mm mm-new branch.  Its filename is
     rust-support-align-and-numa-id-in-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-support-align-and-numa-id-in-allocations.patch

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
Subject: rust: support align and NUMA id in allocations
Date: Wed, 25 Jun 2025 08:30:26 +0200

Add support for large (> PAGE_SIZE) alignments in Rust allocators (Kmalloc
support for large alignments is limited to the requested size, which is a
reasonable limitation anyway).  Besides, add support for NUMA id to
Vmalloc.

Link: https://lkml.kernel.org/r/20250625063026.3379921-1-vitaly.wool@konsulko.se
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/slab.c            |    8 ++++--
 rust/helpers/vmalloc.c         |    4 +--
 rust/kernel/alloc.rs           |   28 ++++++++++++++++++++-
 rust/kernel/alloc/allocator.rs |   40 +++++++++++++++++--------------
 rust/kernel/alloc/kvec.rs      |    3 +-
 5 files changed, 59 insertions(+), 24 deletions(-)

--- a/rust/helpers/slab.c~rust-support-align-and-numa-id-in-allocations
+++ a/rust/helpers/slab.c
@@ -3,13 +3,17 @@
 #include <linux/slab.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_krealloc(const void *objp, size_t new_size, gfp_t flags)
+rust_helper_krealloc(const void *objp, size_t new_size, unsigned long align, gfp_t flags, int nid)
 {
+	if (WARN_ON(new_size & (align - 1)))
+		return NULL;
 	return krealloc(objp, new_size, flags);
 }
 
 void * __must_check __realloc_size(2)
-rust_helper_kvrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_kvrealloc(const void *p, size_t size, unsigned long align, gfp_t flags, int nid)
 {
+	if (WARN_ON(size & (align - 1)))
+		return NULL;
 	return kvrealloc(p, size, flags);
 }
--- a/rust/helpers/vmalloc.c~rust-support-align-and-numa-id-in-allocations
+++ a/rust/helpers/vmalloc.c
@@ -3,7 +3,7 @@
 #include <linux/vmalloc.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_vrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_vrealloc_node(const void *p, size_t size, unsigned long align, gfp_t flags, int node)
 {
-	return vrealloc(p, size, flags);
+	return vrealloc_node(p, size, align, flags, node);
 }
--- a/rust/kernel/alloc/allocator.rs~rust-support-align-and-numa-id-in-allocations
+++ a/rust/kernel/alloc/allocator.rs
@@ -58,7 +58,8 @@ fn aligned_size(new_layout: Layout) -> u
 ///
 /// One of the following: `krealloc`, `vrealloc`, `kvrealloc`.
 struct ReallocFunc(
-    unsafe extern "C" fn(*const crate::ffi::c_void, usize, u32) -> *mut crate::ffi::c_void,
+    unsafe extern "C" fn(*const crate::ffi::c_void, usize, usize, u32, i32)
+                        -> *mut crate::ffi::c_void,
 );
 
 impl ReallocFunc {
@@ -66,7 +67,7 @@ impl ReallocFunc {
     const KREALLOC: Self = Self(bindings::krealloc);
 
     // INVARIANT: `vrealloc` satisfies the type invariants.
-    const VREALLOC: Self = Self(bindings::vrealloc);
+    const VREALLOC: Self = Self(bindings::vrealloc_node);
 
     // INVARIANT: `kvrealloc` satisfies the type invariants.
     const KVREALLOC: Self = Self(bindings::kvrealloc);
@@ -87,6 +88,7 @@ impl ReallocFunc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: Option<i32>,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let size = aligned_size(layout);
         let ptr = match ptr {
@@ -100,6 +102,11 @@ impl ReallocFunc {
             None => ptr::null(),
         };
 
+        let c_nid = match nid {
+            None => bindings::NUMA_NO_NODE,
+            Some(n) => n,
+        };
+
         // SAFETY:
         // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc` and thus only requires that
         //   `ptr` is NULL or valid.
@@ -110,7 +117,7 @@ impl ReallocFunc {
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, flags.0).cast()
+            self.0(ptr.cast(), size, layout.align(), flags.0, c_nid).cast()
         };
 
         let ptr = if size == 0 {
@@ -134,9 +141,10 @@ unsafe impl Allocator for Kmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        _nid: Option<i32>,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
-        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags, None) }
     }
 }
 
@@ -151,16 +159,11 @@ unsafe impl Allocator for Vmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: Option<i32>,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("Vmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
-
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
 
@@ -175,15 +178,18 @@ unsafe impl Allocator for KVmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        _nid: Option<i32>,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        // TODO: Support alignments larger than PAGE_SIZE.
-        if layout.align() > bindings::PAGE_SIZE {
-            pr_warn!("KVmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-            return Err(AllocError);
-        }
+        // if the caller wants to have alignment bigger than PAGE_SIZE
+        // it's only vmalloc we can offer to satisfy that request
+        let alloc_func = if layout.align() > bindings::PAGE_SIZE {
+            ReallocFunc::VREALLOC
+        } else {
+            ReallocFunc::KVREALLOC
+        };
 
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { alloc_func.call(ptr, layout, old_layout, flags, None) }
     }
 }
--- a/rust/kernel/alloc/kvec.rs~rust-support-align-and-numa-id-in-allocations
+++ a/rust/kernel/alloc/kvec.rs
@@ -633,6 +633,7 @@ where
                 layout.into(),
                 self.layout.into(),
                 flags,
+                None,
             )?
         };
 
@@ -1058,7 +1059,7 @@ where
             // the type invariant to be smaller than `cap`. Depending on `realloc` this operation
             // may shrink the buffer or leave it as it is.
             ptr = match unsafe {
-                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags)
+                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags, None)
             } {
                 // If we fail to shrink, which likely can't even happen, continue with the existing
                 // buffer.
--- a/rust/kernel/alloc.rs~rust-support-align-and-numa-id-in-allocations
+++ a/rust/kernel/alloc.rs
@@ -156,7 +156,30 @@ pub unsafe trait Allocator {
     fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
         // new memory allocation.
-        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags) }
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags, None) }
+    }
+
+    /// Allocate memory based on `layout`, `flags` and `nid`.
+    ///
+    /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
+    /// constraints (i.e. minimum size and alignment as specified by `layout`).
+    ///
+    /// This function is equivalent to `realloc` when called with `None`.
+    ///
+    /// # Guarantees
+    ///
+    /// When the return value is `Ok(ptr)`, then `ptr` is
+    /// - valid for reads and writes for `layout.size()` bytes, until it is passed to
+    ///   [`Allocator::free`] or [`Allocator::realloc`],
+    /// - aligned to `layout.align()`,
+    ///
+    /// Additionally, `Flags` are honored as documented in
+    /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
+    fn alloc_node(layout: Layout, flags: Flags, nid: Option<i32>)
+                -> Result<NonNull<[u8]>, AllocError> {
+        // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
+        // new memory allocation.
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags, nid) }
     }
 
     /// Re-allocate an existing memory allocation to satisfy the requested `layout`.
@@ -196,6 +219,7 @@ pub unsafe trait Allocator {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: Option<i32>,
     ) -> Result<NonNull<[u8]>, AllocError>;
 
     /// Free an existing memory allocation.
@@ -211,7 +235,7 @@ pub unsafe trait Allocator {
         // SAFETY: The caller guarantees that `ptr` points at a valid allocation created by this
         // allocator. We are passing a `Layout` with the smallest possible alignment, so it is
         // smaller than or equal to the alignment previously used with this allocation.
-        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
+        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0), None) };
     }
 }
 
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch
rust-support-align-and-numa-id-in-allocations.patch
mm-add-zblock-allocator.patch

