Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E271519AD
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161256; cv=none; b=PetiEn3P50qDh1AHu66PltA7mDoqPne01Ip0IWSkhWC9xOVCv9NKPSVJWoc7GutjcwgJeL0Fq0SbTkKQNGeXrpq7W7xqjbasO/2p9iKEqIGalTiN1gM3TLfhK0gwGvh/3icy7Q33dWG2hHzCTAHhOoYiUeb/Hr1qHxaOXHfmd3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161256; c=relaxed/simple;
	bh=xoQTS8jbu1tUTK24taS2gWEy/RimLN4P/9hDKZDXKAI=;
	h=Date:To:From:Subject:Message-Id; b=MbIe/hvaZFJyjdPZtC6PjMRD/R3ot9pzxIAeCP7/VuJs6PL8k/OAgpOZCTC9j6ZMT7ko8/2jn3Wm5zhtJAlitPmayjWHEYYeS30QlGEUbvjSOSTIj399O/t+vVuPnxoAkcQwkV0t6LEvIDkhdvcKDm3vKSvKdFPlDb/j5BlHfEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pV8NASn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pV8NASn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA02C4CEE9;
	Wed,  9 Apr 2025 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161256;
	bh=xoQTS8jbu1tUTK24taS2gWEy/RimLN4P/9hDKZDXKAI=;
	h=Date:To:From:Subject:From;
	b=pV8NASn/hOQWfZEiRabG+sS7MrPFWnMP7IB+B7cDx2z2tkh3BeHEGzRCUt99jVQ0r
	 hKDhVJqs9fXQ573bfDzjpZdpLZzWXFMtB8piVTQKWdrc9il0rsTDIh5C918tgTM5Nx
	 EF+puiR37o4L5bF5g73VGSpi2gSjPSjrW6TzWpRo=
Date: Tue, 08 Apr 2025 18:14:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-add-abstraction-for-struct-mm_struct.patch added to mm-new branch
Message-Id: <20250409011415.ECA02C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: add abstraction for struct mm_struct
has been added to the -mm mm-new branch.  Its filename is
     mm-rust-add-abstraction-for-struct-mm_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-add-abstraction-for-struct-mm_struct.patch

This patch will later appear in the mm-new branch at
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
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm: rust: add abstraction for struct mm_struct
Date: Tue, 08 Apr 2025 09:22:38 +0000

Patch series "Rust support for mm_struct, vm_area_struct, and mmap", v16.

This updates the vm_area_struct support to use the approach we discussed
at LPC where there are several different Rust wrappers for vm_area_struct
depending on the kind of access you have to the vma.  Each case allows a
different set of operations on the vma.

This includes an MM MAINTAINERS entry as proposed by Lorenzo:
https://lore.kernel.org/all/33e64b12-aa07-4e78-933a-b07c37ff1d84@lucifer.local/


This patch (of 9):

These abstractions allow you to reference a `struct mm_struct` using both
mmgrab and mmget refcounts.  This is done using two Rust types:

* Mm - represents an mm_struct where you don't know anything about the
  value of mm_users.
* MmWithUser - represents an mm_struct where you know at compile time
  that mm_users is non-zero.

This allows us to encode in the type system whether a method requires that
mm_users is non-zero or not.  For instance, you can always call
`mmget_not_zero` but you can only call `mmap_read_lock` when mm_users is
non-zero.

The struct is called Mm to keep consistency with the C side.

The ability to obtain `current->mm` is added later in this series.

The mm module is defined to only exist when CONFIG_MMU is set.  This
avoids various errors due to missing types and functions when CONFIG_MMU
is disabled.  More fine-grained cfgs can be considered in the future.  See
the thread at [1] for more info.

Link: https://lkml.kernel.org/r/20250408-vma-v16-9-d8b446e885d9@google.com
Link: https://lkml.kernel.org/r/20250408-vma-v16-1-d8b446e885d9@google.com
Link: https://lore.kernel.org/all/202503091916.QousmtcY-lkp@intel.com/
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/helpers.c |    1 
 rust/helpers/mm.c      |   39 +++++++
 rust/kernel/lib.rs     |    1 
 rust/kernel/mm.rs      |  210 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)

--- a/rust/helpers/helpers.c~mm-rust-add-abstraction-for-struct-mm_struct
+++ a/rust/helpers/helpers.c
@@ -19,6 +19,7 @@
 #include "io.c"
 #include "jump_label.c"
 #include "kunit.c"
+#include "mm.c"
 #include "mutex.c"
 #include "page.c"
 #include "platform.c"
diff --git a/rust/helpers/mm.c a/rust/helpers/mm.c
new file mode 100644
--- /dev/null
+++ a/rust/helpers/mm.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/mm.h>
+#include <linux/sched/mm.h>
+
+void rust_helper_mmgrab(struct mm_struct *mm)
+{
+	mmgrab(mm);
+}
+
+void rust_helper_mmdrop(struct mm_struct *mm)
+{
+	mmdrop(mm);
+}
+
+void rust_helper_mmget(struct mm_struct *mm)
+{
+	mmget(mm);
+}
+
+bool rust_helper_mmget_not_zero(struct mm_struct *mm)
+{
+	return mmget_not_zero(mm);
+}
+
+void rust_helper_mmap_read_lock(struct mm_struct *mm)
+{
+	mmap_read_lock(mm);
+}
+
+bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
+{
+	return mmap_read_trylock(mm);
+}
+
+void rust_helper_mmap_read_unlock(struct mm_struct *mm)
+{
+	mmap_read_unlock(mm);
+}
--- a/rust/kernel/lib.rs~mm-rust-add-abstraction-for-struct-mm_struct
+++ a/rust/kernel/lib.rs
@@ -61,6 +61,7 @@ pub mod jump_label;
 pub mod kunit;
 pub mod list;
 pub mod miscdevice;
+pub mod mm;
 #[cfg(CONFIG_NET)]
 pub mod net;
 pub mod of;
diff --git a/rust/kernel/mm.rs a/rust/kernel/mm.rs
new file mode 100644
--- /dev/null
+++ a/rust/kernel/mm.rs
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2024 Google LLC.
+
+//! Memory management.
+//!
+//! This module deals with managing the address space of userspace processes. Each process has an
+//! instance of [`Mm`], which keeps track of multiple VMAs (virtual memory areas). Each VMA
+//! corresponds to a region of memory that the userspace process can access, and the VMA lets you
+//! control what happens when userspace reads or writes to that region of memory.
+//!
+//! C header: [`include/linux/mm.h`](srctree/include/linux/mm.h)
+#![cfg(CONFIG_MMU)]
+
+use crate::{
+    bindings,
+    types::{ARef, AlwaysRefCounted, NotThreadSafe, Opaque},
+};
+use core::{ops::Deref, ptr::NonNull};
+
+/// A wrapper for the kernel's `struct mm_struct`.
+///
+/// This represents the address space of a userspace process, so each process has one `Mm`
+/// instance. It may hold many VMAs internally.
+///
+/// There is a counter called `mm_users` that counts the users of the address space; this includes
+/// the userspace process itself, but can also include kernel threads accessing the address space.
+/// Once `mm_users` reaches zero, this indicates that the address space can be destroyed. To access
+/// the address space, you must prevent `mm_users` from reaching zero while you are accessing it.
+/// The [`MmWithUser`] type represents an address space where this is guaranteed, and you can
+/// create one using [`mmget_not_zero`].
+///
+/// The `ARef<Mm>` smart pointer holds an `mmgrab` refcount. Its destructor may sleep.
+///
+/// # Invariants
+///
+/// Values of this type are always refcounted using `mmgrab`.
+///
+/// [`mmget_not_zero`]: Mm::mmget_not_zero
+#[repr(transparent)]
+pub struct Mm {
+    mm: Opaque<bindings::mm_struct>,
+}
+
+// SAFETY: It is safe to call `mmdrop` on another thread than where `mmgrab` was called.
+unsafe impl Send for Mm {}
+// SAFETY: All methods on `Mm` can be called in parallel from several threads.
+unsafe impl Sync for Mm {}
+
+// SAFETY: By the type invariants, this type is always refcounted.
+unsafe impl AlwaysRefCounted for Mm {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: The pointer is valid since self is a reference.
+        unsafe { bindings::mmgrab(self.as_raw()) };
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The caller is giving up their refcount.
+        unsafe { bindings::mmdrop(obj.cast().as_ptr()) };
+    }
+}
+
+/// A wrapper for the kernel's `struct mm_struct`.
+///
+/// This type is like [`Mm`], but with non-zero `mm_users`. It can only be used when `mm_users` can
+/// be proven to be non-zero at compile-time, usually because the relevant code holds an `mmget`
+/// refcount. It can be used to access the associated address space.
+///
+/// The `ARef<MmWithUser>` smart pointer holds an `mmget` refcount. Its destructor may sleep.
+///
+/// # Invariants
+///
+/// Values of this type are always refcounted using `mmget`. The value of `mm_users` is non-zero.
+#[repr(transparent)]
+pub struct MmWithUser {
+    mm: Mm,
+}
+
+// SAFETY: It is safe to call `mmput` on another thread than where `mmget` was called.
+unsafe impl Send for MmWithUser {}
+// SAFETY: All methods on `MmWithUser` can be called in parallel from several threads.
+unsafe impl Sync for MmWithUser {}
+
+// SAFETY: By the type invariants, this type is always refcounted.
+unsafe impl AlwaysRefCounted for MmWithUser {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: The pointer is valid since self is a reference.
+        unsafe { bindings::mmget(self.as_raw()) };
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The caller is giving up their refcount.
+        unsafe { bindings::mmput(obj.cast().as_ptr()) };
+    }
+}
+
+// Make all `Mm` methods available on `MmWithUser`.
+impl Deref for MmWithUser {
+    type Target = Mm;
+
+    #[inline]
+    fn deref(&self) -> &Mm {
+        &self.mm
+    }
+}
+
+// These methods are safe to call even if `mm_users` is zero.
+impl Mm {
+    /// Returns a raw pointer to the inner `mm_struct`.
+    #[inline]
+    pub fn as_raw(&self) -> *mut bindings::mm_struct {
+        self.mm.get()
+    }
+
+    /// Obtain a reference from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `ptr` points at an `mm_struct`, and that it is not deallocated
+    /// during the lifetime 'a.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_struct) -> &'a Mm {
+        // SAFETY: Caller promises that the pointer is valid for 'a. Layouts are compatible due to
+        // repr(transparent).
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Calls `mmget_not_zero` and returns a handle if it succeeds.
+    #[inline]
+    pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUser>> {
+        // SAFETY: The pointer is valid since self is a reference.
+        let success = unsafe { bindings::mmget_not_zero(self.as_raw()) };
+
+        if success {
+            // SAFETY: We just created an `mmget` refcount.
+            Some(unsafe { ARef::from_raw(NonNull::new_unchecked(self.as_raw().cast())) })
+        } else {
+            None
+        }
+    }
+}
+
+// These methods require `mm_users` to be non-zero.
+impl MmWithUser {
+    /// Obtain a reference from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that `ptr` points at an `mm_struct`, and that `mm_users` remains
+    /// non-zero for the duration of the lifetime 'a.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::mm_struct) -> &'a MmWithUser {
+        // SAFETY: Caller promises that the pointer is valid for 'a. The layout is compatible due
+        // to repr(transparent).
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Lock the mmap read lock.
+    #[inline]
+    pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
+        // SAFETY: The pointer is valid since self is a reference.
+        unsafe { bindings::mmap_read_lock(self.as_raw()) };
+
+        // INVARIANT: We just acquired the read lock.
+        MmapReadGuard {
+            mm: self,
+            _nts: NotThreadSafe,
+        }
+    }
+
+    /// Try to lock the mmap read lock.
+    #[inline]
+    pub fn mmap_read_trylock(&self) -> Option<MmapReadGuard<'_>> {
+        // SAFETY: The pointer is valid since self is a reference.
+        let success = unsafe { bindings::mmap_read_trylock(self.as_raw()) };
+
+        if success {
+            // INVARIANT: We just acquired the read lock.
+            Some(MmapReadGuard {
+                mm: self,
+                _nts: NotThreadSafe,
+            })
+        } else {
+            None
+        }
+    }
+}
+
+/// A guard for the mmap read lock.
+///
+/// # Invariants
+///
+/// This `MmapReadGuard` guard owns the mmap read lock.
+pub struct MmapReadGuard<'a> {
+    mm: &'a MmWithUser,
+    // `mmap_read_lock` and `mmap_read_unlock` must be called on the same thread
+    _nts: NotThreadSafe,
+}
+
+impl Drop for MmapReadGuard<'_> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: We hold the read lock by the type invariants.
+        unsafe { bindings::mmap_read_unlock(self.mm.as_raw()) };
+    }
+}
_

Patches currently in -mm which might be from aliceryhl@google.com are

mm-rust-add-abstraction-for-struct-mm_struct.patch
mm-rust-add-vm_area_struct-methods-that-require-read-access.patch
mm-rust-add-vm_insert_page.patch
mm-rust-add-lock_vma_under_rcu.patch
mm-rust-add-mmput_async-support.patch
mm-rust-add-vmanew-for-f_ops-mmap.patch
rust-miscdevice-add-mmap-support.patch
task-rust-rework-how-current-is-accessed.patch
mm-rust-add-memory-management.patch

