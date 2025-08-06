Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0949145346
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754522052; cv=none; b=LiqOV1BFxtRy8UX0VWbvYMe+o72REXca7s3jD8SAjoh4aNYCcLgnWfHlCRuEJX1udYJ05MF6YH0JC2cr9mWSR6PUTVgwnTEU7njM0TS//SwKF860Dnb0CMjcgwFKrZ3PBzT18DwTJzviE3Lh9KcMamNwUARCMH5MT0LmqEELEq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754522052; c=relaxed/simple;
	bh=eO9Mxg9ituZg6G5gxnfRfdIJvbsT9EL9283xpJJ10dw=;
	h=Date:To:From:Subject:Message-Id; b=umC8Q7aaoNAvBW7DeUYR6cw9tilqATDFCguGw4T20d02T094de2HEE5Od7i/nQe64Zz9Ur1lNyoea8kLhw4XBSyxGzZ64UQt3hdeV3A3cXiO2RFnLQrRMg+yJhaDvig+tgdbMzuw8/OM2UK/gUgX1bNUxRciNLL0yHXVbBU/NeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R+Kab+ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R+Kab+ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296B7C4CEE7;
	Wed,  6 Aug 2025 23:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754522052;
	bh=eO9Mxg9ituZg6G5gxnfRfdIJvbsT9EL9283xpJJ10dw=;
	h=Date:To:From:Subject:From;
	b=R+Kab+exsYjo9vCt8Ozwjg+l9gvIJpuOeBJw5Xh6ouKuKorjRUocxQZ2mcbHuohl4
	 v/TFpoR4Tfqd976mZXLeDM0wYOuP6vHT/vM5oQrm3BeUkq/2uVjkJkbGCb25E8kisN
	 2m4BBGHrw27/NMfeV8vtDjry+WhW8mG4CF3FtX9o=
Date: Wed, 06 Aug 2025 16:14:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kent.overstreet@linux.dev,jannh@google.com,herbert@gondor.apana.org.au,dakr@kernel.org,aliceryhl@google.com,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-add-support-for-numa-ids-in-allocations.patch added to mm-new branch
Message-Id: <20250806231412.296B7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: add support for NUMA ids in allocations
has been added to the -mm mm-new branch.  Its filename is
     rust-add-support-for-numa-ids-in-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-add-support-for-numa-ids-in-allocations.patch

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
Subject: rust: add support for NUMA ids in allocations
Date: Wed, 6 Aug 2025 14:55:22 +0200

Add a new type to support specifying NUMA identifiers in Rust allocators
and extend the allocators to have NUMA id as a parameter.  Thus, modify
ReallocFunc to use the new extended realloc primitives from the C side of
the kernel (i.e.  k[v]realloc_node_align/vrealloc_node_align) and add the
new function alloc_node to the Allocator trait while keeping the existing
one (alloc) for backward compatibility.

This will allow to specify node to use for allocation of e.  g.  {KV}Box,
as well as for future NUMA aware users of the API.

Link: https://lkml.kernel.org/r/20250806125522.1726992-1-vitaly.wool@konsulko.se
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

 rust/helpers/slab.c                 |    8 +--
 rust/helpers/vmalloc.c              |    4 -
 rust/kernel/alloc.rs                |   54 +++++++++++++++++++++++---
 rust/kernel/alloc/allocator.rs      |   35 ++++++++++------
 rust/kernel/alloc/allocator_test.rs |    1 
 rust/kernel/alloc/kbox.rs           |    4 -
 rust/kernel/alloc/kvec.rs           |   11 ++++-
 7 files changed, 89 insertions(+), 28 deletions(-)

--- a/rust/helpers/slab.c~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/helpers/slab.c
@@ -3,13 +3,13 @@
 #include <linux/slab.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_krealloc(const void *objp, size_t new_size, gfp_t flags)
+rust_helper_krealloc_node(const void *objp, size_t new_size, gfp_t flags, int node)
 {
-	return krealloc(objp, new_size, flags);
+	return krealloc_node(objp, new_size, flags, node);
 }
 
 void * __must_check __realloc_size(2)
-rust_helper_kvrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_kvrealloc_node(const void *p, size_t size, gfp_t flags, int node)
 {
-	return kvrealloc(p, size, flags);
+	return kvrealloc_node(p, size, flags, node);
 }
--- a/rust/helpers/vmalloc.c~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/helpers/vmalloc.c
@@ -3,7 +3,7 @@
 #include <linux/vmalloc.h>
 
 void * __must_check __realloc_size(2)
-rust_helper_vrealloc(const void *p, size_t size, gfp_t flags)
+rust_helper_vrealloc_node(const void *p, size_t size, gfp_t flags, int node)
 {
-	return vrealloc(p, size, flags);
+	return vrealloc_node(p, size, flags, node);
 }
--- a/rust/kernel/alloc/allocator.rs~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/kernel/alloc/allocator.rs
@@ -13,7 +13,7 @@ use core::alloc::Layout;
 use core::ptr;
 use core::ptr::NonNull;
 
-use crate::alloc::{AllocError, Allocator};
+use crate::alloc::{AllocError, Allocator, NumaNode};
 use crate::bindings;
 use crate::pr_warn;
 
@@ -56,20 +56,25 @@ fn aligned_size(new_layout: Layout) -> u
 
 /// # Invariants
 ///
-/// One of the following: `krealloc`, `vrealloc`, `kvrealloc`.
+/// One of the following: `krealloc_node`, `vrealloc_node`, `kvrealloc_node`.
 struct ReallocFunc(
-    unsafe extern "C" fn(*const crate::ffi::c_void, usize, u32) -> *mut crate::ffi::c_void,
+    unsafe extern "C" fn(
+        *const crate::ffi::c_void,
+        usize,
+        u32,
+        crate::ffi::c_int,
+    ) -> *mut crate::ffi::c_void,
 );
 
 impl ReallocFunc {
-    // INVARIANT: `krealloc` satisfies the type invariants.
-    const KREALLOC: Self = Self(bindings::krealloc);
+    // INVARIANT: `krealloc_node` satisfies the type invariants.
+    const KREALLOC: Self = Self(bindings::krealloc_node);
 
-    // INVARIANT: `vrealloc` satisfies the type invariants.
-    const VREALLOC: Self = Self(bindings::vrealloc);
+    // INVARIANT: `vrealloc_node` satisfies the type invariants.
+    const VREALLOC: Self = Self(bindings::vrealloc_node);
 
-    // INVARIANT: `kvrealloc` satisfies the type invariants.
-    const KVREALLOC: Self = Self(bindings::kvrealloc);
+    // INVARIANT: `kvrealloc_node` satisfies the type invariants.
+    const KVREALLOC: Self = Self(bindings::kvrealloc_node);
 
     /// # Safety
     ///
@@ -87,6 +92,7 @@ impl ReallocFunc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let size = aligned_size(layout);
         let ptr = match ptr {
@@ -110,7 +116,7 @@ impl ReallocFunc {
         // - Those functions provide the guarantees of this function.
         let raw_ptr = unsafe {
             // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
-            self.0(ptr.cast(), size, flags.0).cast()
+            self.0(ptr.cast(), size, flags.0, nid.0).cast()
         };
 
         let ptr = if size == 0 {
@@ -134,9 +140,10 @@ unsafe impl Allocator for Kmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
-        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
 
@@ -151,6 +158,7 @@ unsafe impl Allocator for Vmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // TODO: Support alignments larger than PAGE_SIZE.
         if layout.align() > bindings::PAGE_SIZE {
@@ -160,7 +168,7 @@ unsafe impl Allocator for Vmalloc {
 
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
 
@@ -175,6 +183,7 @@ unsafe impl Allocator for KVmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         // TODO: Support alignments larger than PAGE_SIZE.
         if layout.align() > bindings::PAGE_SIZE {
@@ -184,6 +193,6 @@ unsafe impl Allocator for KVmalloc {
 
         // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
         // allocated with this `Allocator`.
-        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags) }
+        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags, nid) }
     }
 }
--- a/rust/kernel/alloc/allocator_test.rs~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/kernel/alloc/allocator_test.rs
@@ -40,6 +40,7 @@ unsafe impl Allocator for Cmalloc {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        _nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let src = match ptr {
             Some(src) => {
--- a/rust/kernel/alloc/kbox.rs~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/kernel/alloc/kbox.rs
@@ -4,7 +4,7 @@
 
 #[allow(unused_imports)] // Used in doc comments.
 use super::allocator::{KVmalloc, Kmalloc, Vmalloc};
-use super::{AllocError, Allocator, Flags};
+use super::{AllocError, Allocator, Flags, NumaNode};
 use core::alloc::Layout;
 use core::borrow::{Borrow, BorrowMut};
 use core::fmt;
@@ -273,7 +273,7 @@ where
     /// ```
     pub fn new_uninit(flags: Flags) -> Result<Box<MaybeUninit<T>, A>, AllocError> {
         let layout = Layout::new::<MaybeUninit<T>>();
-        let ptr = A::alloc(layout, flags)?;
+        let ptr = A::alloc(layout, flags, NumaNode::NO_NODE)?;
 
         // INVARIANT: `ptr` is either a dangling pointer or points to memory allocated with `A`,
         // which is sufficient in size and alignment for storing a `T`.
--- a/rust/kernel/alloc/kvec.rs~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/kernel/alloc/kvec.rs
@@ -5,7 +5,7 @@
 use super::{
     allocator::{KVmalloc, Kmalloc, Vmalloc},
     layout::ArrayLayout,
-    AllocError, Allocator, Box, Flags,
+    AllocError, Allocator, Box, Flags, NumaNode,
 };
 use core::{
     borrow::{Borrow, BorrowMut},
@@ -634,6 +634,7 @@ where
                 layout.into(),
                 self.layout.into(),
                 flags,
+                NumaNode::NO_NODE,
             )?
         };
 
@@ -1111,7 +1112,13 @@ where
             // the type invariant to be smaller than `cap`. Depending on `realloc` this operation
             // may shrink the buffer or leave it as it is.
             ptr = match unsafe {
-                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags)
+                A::realloc(
+                    Some(buf.cast()),
+                    layout.into(),
+                    old_layout.into(),
+                    flags,
+                    NumaNode::NO_NODE,
+                )
             } {
                 // If we fail to shrink, which likely can't even happen, continue with the existing
                 // buffer.
--- a/rust/kernel/alloc.rs~rust-add-support-for-numa-ids-in-allocations
+++ a/rust/kernel/alloc.rs
@@ -28,6 +28,8 @@ pub use self::kvec::Vec;
 /// Indicates an allocation error.
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
+
+use crate::error::{code::EINVAL, Result};
 use core::{alloc::Layout, ptr::NonNull};
 
 /// Flags to be used when allocating memory.
@@ -115,6 +117,31 @@ pub mod flags {
     pub const __GFP_NOWARN: Flags = Flags(bindings::__GFP_NOWARN);
 }
 
+/// Non Uniform Memory Access (NUMA) node identifier.
+#[derive(Clone, Copy, PartialEq)]
+pub struct NumaNode(i32);
+
+impl NumaNode {
+    /// Create a new NUMA node identifier (non-negative integer).
+    ///
+    /// Returns [`EINVAL`] if a negative id or an id exceeding [`bindings::MAX_NUMNODES`] is
+    /// specified.
+    pub fn new(node: i32) -> Result<Self> {
+        // MAX_NUMNODES never exceeds 2**10 because NODES_SHIFT is 0..10.
+        if node < 0 || node >= bindings::MAX_NUMNODES as i32 {
+            return Err(EINVAL);
+        }
+        Ok(Self(node))
+    }
+}
+
+/// Specify necessary constant to pass the information to Allocator that the caller doesn't care
+/// about the NUMA node to allocate memory from.
+impl NumaNode {
+    /// No node preference.
+    pub const NO_NODE: NumaNode = NumaNode(bindings::NUMA_NO_NODE);
+}
+
 /// The kernel's [`Allocator`] trait.
 ///
 /// An implementation of [`Allocator`] can allocate, re-allocate and free memory buffers described
@@ -137,7 +164,7 @@ pub mod flags {
 /// - Implementers must ensure that all trait functions abide by the guarantees documented in the
 ///   `# Guarantees` sections.
 pub unsafe trait Allocator {
-    /// Allocate memory based on `layout` and `flags`.
+    /// Allocate memory based on `layout`, `flags` and `nid`.
     ///
     /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
     /// constraints (i.e. minimum size and alignment as specified by `layout`).
@@ -153,13 +180,21 @@ pub unsafe trait Allocator {
     ///
     /// Additionally, `Flags` are honored as documented in
     /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
-    fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, AllocError> {
+    fn alloc(layout: Layout, flags: Flags, nid: NumaNode) -> Result<NonNull<[u8]>, AllocError> {
         // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
         // new memory allocation.
-        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags) }
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags, nid) }
     }
 
-    /// Re-allocate an existing memory allocation to satisfy the requested `layout`.
+    /// Re-allocate an existing memory allocation to satisfy the requested `layout` and
+    /// a specific NUMA node request to allocate the memory for.
+    ///
+    /// Systems employing a Non Uniform Memory Access (NUMA) architecture contain collections of
+    /// hardware resources including processors, memory, and I/O buses, that comprise what is
+    /// commonly known as a NUMA node.
+    ///
+    /// `nid` stands for NUMA id, i. e. NUMA node identifier, which is a non-negative integer
+    /// if a node needs to be specified, or [`NumaNode::NO_NODE`] if the caller doesn't care.
     ///
     /// If the requested size is zero, `realloc` behaves equivalent to `free`.
     ///
@@ -196,6 +231,7 @@ pub unsafe trait Allocator {
         layout: Layout,
         old_layout: Layout,
         flags: Flags,
+        nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError>;
 
     /// Free an existing memory allocation.
@@ -211,7 +247,15 @@ pub unsafe trait Allocator {
         // SAFETY: The caller guarantees that `ptr` points at a valid allocation created by this
         // allocator. We are passing a `Layout` with the smallest possible alignment, so it is
         // smaller than or equal to the alignment previously used with this allocation.
-        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
+        let _ = unsafe {
+            Self::realloc(
+                Some(ptr),
+                Layout::new::<()>(),
+                layout,
+                Flags(0),
+                NumaNode::NO_NODE,
+            )
+        };
     }
 }
 
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-vmalloc-allow-to-set-node-and-align-in-vrealloc.patch
mm-slub-allow-to-set-node-and-align-in-krealloc.patch
rust-add-support-for-numa-ids-in-allocations.patch
rust-support-large-alignments-in-allocations.patch

