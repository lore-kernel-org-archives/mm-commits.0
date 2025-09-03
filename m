Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773FA1917FB
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 22:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756936996; cv=none; b=rvbC7g1GeOAadn/tpDB2ZiQEFyvfK3PV/T9FEoFfXo3Dr3si0x1UIsXLaX9haLOdEbFmOTkytP64mab2naT9UJmfzghHMiGLoKT8rSSO0r7SpBzt3RsEGNusnRLsLbE6CwzDXsiAfv/IC1m29+nAW1Jwi1Ie2m6TDZWfunsjm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756936996; c=relaxed/simple;
	bh=Ac3p8ojFqLs7Cek6iaPgiiAoa1SKx2IKShAihzbZAG0=;
	h=Date:To:From:Subject:Message-Id; b=TLG4PgDOga1v7oJoOWAYe5Sna8CJhr1SEqGGaE0KXPdj6UedGvg+5cDjYKBHdF/x1LHOtdkr5i5YSQITkHmmlmK2reR6NCzyzaGjyjbb3pxbTKFBaB69HPh+QCeG2zVsqxxchKObjCYwgICvjmH3bJMh3JuKfDmq5h/q1zaDItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftj7gcRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftj7gcRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E85C4CEF7;
	Wed,  3 Sep 2025 22:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756936994;
	bh=Ac3p8ojFqLs7Cek6iaPgiiAoa1SKx2IKShAihzbZAG0=;
	h=Date:To:From:Subject:From;
	b=ftj7gcRIA9qCAOv2QOQ3QuRkya6iWLCo97NcakPZf9u7NV4sMXmruJYW/vyqH1amk
	 MNV2lcUzCRjRYfDcW+8VxNHBcKkSLsQZh/aZl671plpGlgoJZ4kCe+wx34uBcqgcsA
	 sf2rBdBZ3FW0rBtbX8m/txlLDUNAXZTwDaf6jKQI=
Date: Wed, 03 Sep 2025 15:03:13 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,gary@garyguo.net,daniel.almeida@collabora.com,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-maple_tree-add-mapletreealloc.patch added to mm-new branch
Message-Id: <20250903220314.23E85C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: maple_tree: add MapleTreeAlloc
has been added to the -mm mm-new branch.  Its filename is
     rust-maple_tree-add-mapletreealloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-maple_tree-add-mapletreealloc.patch

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
From: Alice Ryhl <aliceryhl@google.com>
Subject: rust: maple_tree: add MapleTreeAlloc
Date: Tue, 02 Sep 2025 08:35:13 +0000

To support allocation trees, we introduce a new type MapleTreeAlloc for
the case where the tree is created using MT_FLAGS_ALLOC_RANGE.  To ensure
that you can only call mtree_alloc_range on an allocation tree, we
restrict thta method to the new MapleTreeAlloc type.  However, all methods
on MapleTree remain accessible to MapleTreeAlloc as allocation trees can
use the other methods without issues.

Link: https://lkml.kernel.org/r/20250902-maple-tree-v3-3-fb5c8958fb1e@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/maple_tree.rs |  158 ++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

--- a/rust/kernel/maple_tree.rs~rust-maple_tree-add-mapletreealloc
+++ a/rust/kernel/maple_tree.rs
@@ -32,6 +32,26 @@ pub struct MapleTree<T: ForeignOwnable>
     _p: PhantomData<T>,
 }
 
+/// A maple tree with `MT_FLAGS_ALLOC_RANGE` set.
+///
+/// All methods on [`MapleTree`] are also accessible on this type.
+#[pin_data]
+#[repr(transparent)]
+pub struct MapleTreeAlloc<T: ForeignOwnable> {
+    #[pin]
+    tree: MapleTree<T>,
+}
+
+// Make MapleTree methods usable on MapleTreeAlloc.
+impl<T: ForeignOwnable> core::ops::Deref for MapleTreeAlloc<T> {
+    type Target = MapleTree<T>;
+
+    #[inline]
+    fn deref(&self) -> &MapleTree<T> {
+        &self.tree
+    }
+}
+
 #[inline]
 fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usize)> {
     let first = match range.start_bound() {
@@ -359,6 +379,107 @@ impl<'tree, T: ForeignOwnable> MapleGuar
     }
 }
 
+impl<T: ForeignOwnable> MapleTreeAlloc<T> {
+    /// Create a new allocation tree.
+    pub fn new() -> impl PinInit<Self> {
+        let tree = pin_init!(MapleTree {
+            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
+            // destroyed in Drop before the memory location becomes invalid.
+            tree <- Opaque::ffi_init(|slot| unsafe {
+                bindings::mt_init_flags(slot, bindings::MT_FLAGS_ALLOC_RANGE)
+            }),
+            _p: PhantomData,
+        });
+
+        pin_init!(MapleTreeAlloc { tree <- tree })
+    }
+
+    /// Insert an entry with the given size somewhere in the given range.
+    ///
+    /// The maple tree will search for a location in the given range where there is space to insert
+    /// the new range. If there is not enough available space, then an error will be returned.
+    ///
+    /// The index of the new range is returned.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTreeAlloc, AllocErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTreeAlloc::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// let thirty = KBox::new(30, GFP_KERNEL)?;
+    /// let hundred = KBox::new(100, GFP_KERNEL)?;
+    ///
+    /// // Allocate three ranges.
+    /// let idx1 = tree.alloc_range(100, ten, ..1000, GFP_KERNEL)?;
+    /// let idx2 = tree.alloc_range(100, twenty, ..1000, GFP_KERNEL)?;
+    /// let idx3 = tree.alloc_range(100, thirty, ..1000, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(idx1, 0);
+    /// assert_eq!(idx2, 100);
+    /// assert_eq!(idx3, 200);
+    ///
+    /// // This will fail because the remaining space is too small.
+    /// assert_eq!(
+    ///     tree.alloc_range(800, hundred, ..1000, GFP_KERNEL).unwrap_err().cause,
+    ///     AllocErrorKind::Busy,
+    /// );
+    /// # Ok::<_, Error>(())
+    /// ```
+    pub fn alloc_range<R>(
+        &self,
+        size: usize,
+        value: T,
+        range: R,
+        gfp: Flags,
+    ) -> Result<usize, AllocError<T>>
+    where
+        R: RangeBounds<usize>,
+    {
+        let Some((min, max)) = to_maple_range(range) else {
+            return Err(AllocError {
+                value,
+                cause: AllocErrorKind::InvalidRequest,
+            });
+        };
+
+        let ptr = T::into_foreign(value);
+        let mut index = 0;
+
+        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
+        let res = to_result(unsafe {
+            bindings::mtree_alloc_range(
+                self.tree.tree.get(),
+                &mut index,
+                ptr,
+                size,
+                min,
+                max,
+                gfp.as_raw(),
+            )
+        });
+
+        if let Err(err) = res {
+            // SAFETY: As `mtree_alloc_range` failed, it is safe to take back ownership.
+            let value = unsafe { T::from_foreign(ptr) };
+
+            let cause = if err == ENOMEM {
+                AllocErrorKind::AllocError(kernel::alloc::AllocError)
+            } else if err == EBUSY {
+                AllocErrorKind::Busy
+            } else {
+                AllocErrorKind::InvalidRequest
+            };
+            Err(AllocError { value, cause })
+        } else {
+            Ok(index)
+        }
+    }
+}
+
 /// A helper type used for navigating a [`MapleTree`].
 ///
 /// # Invariants
@@ -488,3 +609,40 @@ impl<T> From<InsertError<T>> for Error {
         Error::from(insert_err.cause)
     }
 }
+
+/// Error type for failure to insert a new value.
+pub struct AllocError<T> {
+    /// The value that could not be inserted.
+    pub value: T,
+    /// The reason for the failure to insert.
+    pub cause: AllocErrorKind,
+}
+
+/// The reason for the failure to insert.
+#[derive(PartialEq, Eq, Copy, Clone)]
+pub enum AllocErrorKind {
+    /// There is not enough space for the requested allocation.
+    Busy,
+    /// Failure to allocate memory.
+    AllocError(kernel::alloc::AllocError),
+    /// The insertion request was invalid.
+    InvalidRequest,
+}
+
+impl From<AllocErrorKind> for Error {
+    #[inline]
+    fn from(kind: AllocErrorKind) -> Error {
+        match kind {
+            AllocErrorKind::Busy => EBUSY,
+            AllocErrorKind::AllocError(kernel::alloc::AllocError) => ENOMEM,
+            AllocErrorKind::InvalidRequest => EINVAL,
+        }
+    }
+}
+
+impl<T> From<AllocError<T>> for Error {
+    #[inline]
+    fn from(insert_err: AllocError<T>) -> Error {
+        Error::from(insert_err.cause)
+    }
+}
_

Patches currently in -mm which might be from aliceryhl@google.com are

rust-maple_tree-add-mapletree.patch
rust-maple_tree-add-lock-guard-for-maple-tree.patch
rust-maple_tree-add-mapletreealloc.patch

