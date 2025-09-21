Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7A29D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489914; cv=none; b=PpYAGUNVIkhG+wpuEnneyg9nMtu0T2ty2HYZQ/PvSleNwCTNjadkC6QTOJpblw7qMs2uJriSydPsKaNjJEWFsvjAXxUSc9UWaATZtRFM7SdFxcXFc26V4bTudMPLKc0JWHqawzq650rPfaGElopY74+ynMVICBhJWl6ULUd9MqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489914; c=relaxed/simple;
	bh=Cvdj/EeIkrMdPcZgKbe1d4V0noiqB1x4LFzZ83Oi1K0=;
	h=Date:To:From:Subject:Message-Id; b=TmTszToid5dbDC2JBlpMX6ZjkI6NSxS8SNvr/+r9bMpGIPDrxgbDt2eKmwVnCZrCh99G/7LsqBzkzMCm+tnRpHQ8la3miEU4ZWkpkI7w132Bsh+4C/eFX1nPVpnam8uuGwNL5BqfgiqQVye9Zlp5H3kAQtuyBYx4FIR/Wh9bBaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0gKuUMhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0gKuUMhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9277C4CEE7;
	Sun, 21 Sep 2025 21:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489913;
	bh=Cvdj/EeIkrMdPcZgKbe1d4V0noiqB1x4LFzZ83Oi1K0=;
	h=Date:To:From:Subject:From;
	b=0gKuUMhq7VVbYLqJHt/gStVYG1JBWqUcUOKoqAc1LY3XwGoyCtCV0yYe+RirgjXFo
	 6bWH+U4CIxBBz0vBjur8vjeIBbxMjbuGkpe4qt91dNHee3FsXkEScdrkHYFqg2pmUZ
	 ie8MiqtMseCL8fZJ7eRwmK3cG+rSzSkV+0ISsMbs=
Date: Sun, 21 Sep 2025 14:25:13 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,gary@garyguo.net,daniel.almeida@collabora.com,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rust-maple_tree-add-lock-guard-for-maple-tree.patch removed from -mm tree
Message-Id: <20250921212513.C9277C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: maple_tree: add lock guard for maple tree
has been removed from the -mm tree.  Its filename was
     rust-maple_tree-add-lock-guard-for-maple-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: rust: maple_tree: add lock guard for maple tree
Date: Tue, 02 Sep 2025 08:35:12 +0000

To load a value, one must be careful to hold the lock while accessing it. 
To enable this, we add a lock() method so that you can perform operations
on the value before the spinlock is released.

This adds a MapleGuard type without using the existing SpinLock type. 
This ensures that the MapleGuard type is not unnecessarily large, and that
it is easy to swap out the type of lock in case the C maple tree is
changed to use a different kind of lock.

There are two ways of using the lock guard: You can call load() directly
to load a value under the lock, or you can create an MaState to iterate
the tree with find().

The find() method does not have the mas_ prefix since it's a method on
MaState, and being a method on that struct serves a similar purpose to the
mas_ prefix in C.

Link: https://lkml.kernel.org/r/20250902-maple-tree-v3-2-fb5c8958fb1e@google.com
Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/maple_tree.rs |  140 ++++++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

--- a/rust/kernel/maple_tree.rs~rust-maple_tree-add-lock-guard-for-maple-tree
+++ a/rust/kernel/maple_tree.rs
@@ -213,6 +213,23 @@ impl<T: ForeignOwnable> MapleTree<T> {
         unsafe { T::try_from_foreign(ret) }
     }
 
+    /// Lock the internal spinlock.
+    #[inline]
+    pub fn lock(&self) -> MapleGuard<'_, T> {
+        // SAFETY: It's safe to lock the spinlock in a maple tree.
+        unsafe { bindings::spin_lock(self.ma_lock()) };
+
+        // INVARIANT: We just took the spinlock.
+        MapleGuard(self)
+    }
+
+    #[inline]
+    fn ma_lock(&self) -> *mut bindings::spinlock_t {
+        // SAFETY: This pointer offset operation stays in-bounds.
+        let lock_ptr = unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock };
+        lock_ptr.cast()
+    }
+
     /// Free all `T` instances in this tree.
     ///
     /// # Safety
@@ -256,6 +273,91 @@ impl<T: ForeignOwnable> PinnedDrop for M
     }
 }
 
+/// A reference to a [`MapleTree`] that owns the inner lock.
+///
+/// # Invariants
+///
+/// This guard owns the inner spinlock.
+#[must_use = "if unused, the lock will be immediately unlocked"]
+pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
+
+impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: By the type invariants, we hold this spinlock.
+        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
+    }
+}
+
+impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
+    /// Create a [`MaState`] protected by this lock guard.
+    pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
+        // SAFETY: The `MaState` borrows this `MapleGuard`, so it can also borrow the `MapleGuard`s
+        // read/write permissions to the maple tree.
+        unsafe { MaState::new_raw(self.0, first, end) }
+    }
+
+    /// Load the value at the given index.
+    ///
+    /// # Examples
+    ///
+    /// Read the value while holding the spinlock.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// let mut lock = tree.lock();
+    /// assert_eq!(lock.load(100).map(|v| *v), Some(10));
+    /// assert_eq!(lock.load(200).map(|v| *v), Some(20));
+    /// assert_eq!(lock.load(300).map(|v| *v), None);
+    /// # Ok::<_, Error>(())
+    /// ```
+    ///
+    /// Increment refcount under the lock, to keep value alive afterwards.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    /// use kernel::sync::Arc;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = Arc::new(10, GFP_KERNEL)?;
+    /// let twenty = Arc::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// // Briefly take the lock to increment the refcount.
+    /// let value = tree.lock().load(100).map(Arc::from);
+    ///
+    /// // At this point, another thread might remove the value.
+    /// tree.erase(100);
+    ///
+    /// // But we can still access it because we took a refcount.
+    /// assert_eq!(value.map(|v| *v), Some(10));
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
+        // SAFETY: `self.tree` contains a valid maple tree.
+        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
+        if ret.is_null() {
+            return None;
+        }
+
+        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It is
+        // safe to borrow the instance mutably because the signature of this function enforces that
+        // the mutable borrow is not used after the spinlock is dropped.
+        Some(unsafe { T::borrow_mut(ret) })
+    }
+}
+
 /// A helper type used for navigating a [`MapleTree`].
 ///
 /// # Invariants
@@ -309,6 +411,44 @@ impl<'tree, T: ForeignOwnable> MaState<'
         // to the tree.
         unsafe { bindings::mas_find(self.as_raw(), max) }
     }
+
+    /// Find the next entry in the maple tree.
+    ///
+    /// # Examples
+    ///
+    /// Iterate the maple tree.
+    ///
+    /// ```
+    /// use kernel::maple_tree::MapleTree;
+    /// use kernel::sync::Arc;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<Arc<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = Arc::new(10, GFP_KERNEL)?;
+    /// let twenty = Arc::new(20, GFP_KERNEL)?;
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(200, twenty, GFP_KERNEL)?;
+    ///
+    /// let mut ma_lock = tree.lock();
+    /// let mut iter = ma_lock.ma_state(0, usize::MAX);
+    ///
+    /// assert_eq!(iter.find(usize::MAX).map(|v| *v), Some(10));
+    /// assert_eq!(iter.find(usize::MAX).map(|v| *v), Some(20));
+    /// assert!(iter.find(usize::MAX).is_none());
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn find(&mut self, max: usize) -> Option<T::BorrowedMut<'_>> {
+        let ret = self.mas_find_raw(max);
+        if ret.is_null() {
+            return None;
+        }
+
+        // SAFETY: If the pointer is not null, then it references a valid instance of `T`. It's
+        // safe to access it mutably as the returned reference borrows this `MaState`, and the
+        // `MaState` has read/write access to the maple tree.
+        Some(unsafe { T::borrow_mut(ret) })
+    }
 }
 
 /// Error type for failure to insert a new value.
_

Patches currently in -mm which might be from aliceryhl@google.com are


