Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E69614658D
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 20:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747945853; cv=none; b=ROc7ZhOZ2bcokN3ejH7XgXMgeqX+gn6dAesCZVj3woNYQjLKzMWj/Kevxc/suyLNrIANmOryGWvcviSrxedXp3fiHk33TDoyj1l+mCitgZj7X/u9XalcE0bHFTehsULXpyUh8YJbHv/mkT173wjauASNywNrd3km1obDju2kfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747945853; c=relaxed/simple;
	bh=FddraD3AJIMA2HF8xiPkuryzjvGBP+NYo4sQF/rRb5s=;
	h=Date:To:From:Subject:Message-Id; b=nNtzrMWu4JL18aBKnLi6ohQ+iM0rOK1LJRGdu81HFGp9usVH3LkwopG2HYJ0Wib/hJPsTkZjYqxWgp1Vkcuu1C23CzXfmGAt3WEW4+3RzjFxWJDG3arwWULfnVl4xj9vT7nOZY/bawxD9wM5LiWXT82zGRxo0mTDIOBxKrGFuZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PcIrZ8PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PcIrZ8PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA455C4CEE4;
	Thu, 22 May 2025 20:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747945852;
	bh=FddraD3AJIMA2HF8xiPkuryzjvGBP+NYo4sQF/rRb5s=;
	h=Date:To:From:Subject:From;
	b=PcIrZ8PK52F4F4fOBDoUNGLtGFarpQyNIXmOwCpojveiuq4xRhKztnb0u9prysnZZ
	 9ZUuEetQ6bVgmc2f/HGESTxURC8LD+PdiouKRlrlUVAuH8hGpEz4CEDtMlIZNCokWW
	 X77SNWMVRNwKTJQcXe4nKLK3tlVklcPaFQCGTubs=
Date: Thu, 22 May 2025 13:30:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,boqun.feng@gmail.com,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-make-config_mmu-ifdefs-more-narrow.patch added to mm-new branch
Message-Id: <20250522203052.AA455C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: make CONFIG_MMU ifdefs more narrow
has been added to the -mm mm-new branch.  Its filename is
     mm-rust-make-config_mmu-ifdefs-more-narrow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-make-config_mmu-ifdefs-more-narrow.patch

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
Subject: mm: rust: make CONFIG_MMU ifdefs more narrow
Date: Fri, 16 May 2025 19:32:19 +0000

Currently the entire kernel::mm module is ifdef'd out when CONFIG_MMU=n.
However, there are some downstream users of the module in
rust/kernel/task.rs and rust/kernel/miscdevice.rs. Thus, update the cfgs
so that only MmWithUserAsync is removed with CONFIG_MMU=n.

The code is moved into a new file, since the #[cfg()] annotation
otherwise has to be duplicated several times.

Link: https://lkml.kernel.org/r/20250516193219.2987032-1-aliceryhl@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505071753.kldNHYVQ-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202505072116.eSYC8igT-lkp@intel.com/
Fixes: 5bb9ed6cdfeb ("mm: rust: add abstraction for struct mm_struct")
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/mm.rs             |   56 +-------------------------
 rust/kernel/mm/mmput_async.rs |   68 ++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 52 deletions(-)

diff --git a/rust/kernel/mm/mmput_async.rs a/rust/kernel/mm/mmput_async.rs
new file mode 100644
--- /dev/null
+++ a/rust/kernel/mm/mmput_async.rs
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+
+// Copyright (C) 2024 Google LLC.
+
+//! Version of `MmWithUser` using `mmput_async`.
+//!
+//! This is a separate file from `mm.rs` due to the dependency on `CONFIG_MMU=y`.
+#![cfg(CONFIG_MMU)]
+
+use crate::{
+    bindings,
+    mm::MmWithUser,
+    types::{ARef, AlwaysRefCounted},
+};
+use core::{ops::Deref, ptr::NonNull};
+
+/// A wrapper for the kernel's `struct mm_struct`.
+///
+/// This type is identical to `MmWithUser` except that it uses `mmput_async` when dropping a
+/// refcount. This means that the destructor of `ARef<MmWithUserAsync>` is safe to call in atomic
+/// context.
+///
+/// # Invariants
+///
+/// Values of this type are always refcounted using `mmget`. The value of `mm_users` is non-zero.
+#[repr(transparent)]
+pub struct MmWithUserAsync {
+    mm: MmWithUser,
+}
+
+// SAFETY: It is safe to call `mmput_async` on another thread than where `mmget` was called.
+unsafe impl Send for MmWithUserAsync {}
+// SAFETY: All methods on `MmWithUserAsync` can be called in parallel from several threads.
+unsafe impl Sync for MmWithUserAsync {}
+
+// SAFETY: By the type invariants, this type is always refcounted.
+unsafe impl AlwaysRefCounted for MmWithUserAsync {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: The pointer is valid since self is a reference.
+        unsafe { bindings::mmget(self.as_raw()) };
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The caller is giving up their refcount.
+        unsafe { bindings::mmput_async(obj.cast().as_ptr()) };
+    }
+}
+
+// Make all `MmWithUser` methods available on `MmWithUserAsync`.
+impl Deref for MmWithUserAsync {
+    type Target = MmWithUser;
+
+    #[inline]
+    fn deref(&self) -> &MmWithUser {
+        &self.mm
+    }
+}
+
+impl MmWithUser {
+    /// Use `mmput_async` when dropping this refcount.
+    #[inline]
+    pub fn into_mmput_async(me: ARef<MmWithUser>) -> ARef<MmWithUserAsync> {
+        // SAFETY: The layouts and invariants are compatible.
+        unsafe { ARef::from_raw(ARef::into_raw(me).cast()) }
+    }
+}
--- a/rust/kernel/mm.rs~mm-rust-make-config_mmu-ifdefs-more-narrow
+++ a/rust/kernel/mm.rs
@@ -10,7 +10,6 @@
 //! control what happens when userspace reads or writes to that region of memory.
 //!
 //! C header: [`include/linux/mm.h`](srctree/include/linux/mm.h)
-#![cfg(CONFIG_MMU)]
 
 use crate::{
     bindings,
@@ -21,6 +20,10 @@ use core::{ops::Deref, ptr::NonNull};
 pub mod virt;
 use virt::VmaRef;
 
+#[cfg(CONFIG_MMU)]
+pub use mmput_async::MmWithUserAsync;
+mod mmput_async;
+
 /// A wrapper for the kernel's `struct mm_struct`.
 ///
 /// This represents the address space of a userspace process, so each process has one `Mm`
@@ -111,50 +114,6 @@ impl Deref for MmWithUser {
     }
 }
 
-/// A wrapper for the kernel's `struct mm_struct`.
-///
-/// This type is identical to `MmWithUser` except that it uses `mmput_async` when dropping a
-/// refcount. This means that the destructor of `ARef<MmWithUserAsync>` is safe to call in atomic
-/// context.
-///
-/// # Invariants
-///
-/// Values of this type are always refcounted using `mmget`. The value of `mm_users` is non-zero.
-#[repr(transparent)]
-pub struct MmWithUserAsync {
-    mm: MmWithUser,
-}
-
-// SAFETY: It is safe to call `mmput_async` on another thread than where `mmget` was called.
-unsafe impl Send for MmWithUserAsync {}
-// SAFETY: All methods on `MmWithUserAsync` can be called in parallel from several threads.
-unsafe impl Sync for MmWithUserAsync {}
-
-// SAFETY: By the type invariants, this type is always refcounted.
-unsafe impl AlwaysRefCounted for MmWithUserAsync {
-    #[inline]
-    fn inc_ref(&self) {
-        // SAFETY: The pointer is valid since self is a reference.
-        unsafe { bindings::mmget(self.as_raw()) };
-    }
-
-    #[inline]
-    unsafe fn dec_ref(obj: NonNull<Self>) {
-        // SAFETY: The caller is giving up their refcount.
-        unsafe { bindings::mmput_async(obj.cast().as_ptr()) };
-    }
-}
-
-// Make all `MmWithUser` methods available on `MmWithUserAsync`.
-impl Deref for MmWithUserAsync {
-    type Target = MmWithUser;
-
-    #[inline]
-    fn deref(&self) -> &MmWithUser {
-        &self.mm
-    }
-}
-
 // These methods are safe to call even if `mm_users` is zero.
 impl Mm {
     /// Returns a raw pointer to the inner `mm_struct`.
@@ -206,13 +165,6 @@ impl MmWithUser {
         unsafe { &*ptr.cast() }
     }
 
-    /// Use `mmput_async` when dropping this refcount.
-    #[inline]
-    pub fn into_mmput_async(me: ARef<MmWithUser>) -> ARef<MmWithUserAsync> {
-        // SAFETY: The layouts and invariants are compatible.
-        unsafe { ARef::from_raw(ARef::into_raw(me).cast()) }
-    }
-
     /// Attempt to access a vma using the vma read lock.
     ///
     /// This is an optimistic trylock operation, so it may fail if there is contention. In that
_

Patches currently in -mm which might be from aliceryhl@google.com are

mm-rust-make-config_mmu-ifdefs-more-narrow.patch
kcov-rust-add-flags-for-kcov-with-rust.patch

