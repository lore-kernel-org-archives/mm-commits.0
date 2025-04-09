Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044E72AE89
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161266; cv=none; b=WLJ2z3kTZtoo82b/Km4tIfZqWRXoNhvELWsyeBmYPappMVfyQgKzZ2nc2k4mzGjlWBe5fZ8wB0v6kBj1Cs1rdMCfvpefJjgiYGUCJ/jNJ/jc4TPU6ngeZnUBKStxOEQ1Rxm2lrMyPU2YAe+s/Zy3BZuFEtrKEVfCR0O7i/bnIO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161266; c=relaxed/simple;
	bh=NR2sOIo+RStdGIU4qvtGRkYFyVrJ08aPskDiSC93b6g=;
	h=Date:To:From:Subject:Message-Id; b=V150mvyYGZxzv+udW5Wv5dGhbqgHGNOFaPDY8yd734uRxQQmnSHmFCzmQWBUgX1ETLljMi1ohwpktFmM9oMnQMCYOSpa0myVlKieC5cEu4dRIR8TLY22OuPWpcI0AxsoKPkz4XdnFRVYDn8S/sm8CVI/9XOp8axygEq1Cp7cXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZB28XVDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZB28XVDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E59C4CEE5;
	Wed,  9 Apr 2025 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161265;
	bh=NR2sOIo+RStdGIU4qvtGRkYFyVrJ08aPskDiSC93b6g=;
	h=Date:To:From:Subject:From;
	b=ZB28XVDxekB/e6qlj81I+VnaHprQY0exep9hMQfvfqAc1xomh7zfR2peRsl35O04/
	 hwRuUKichqAdmdiaJZEK+nV6iI+KaXz+xXShUjBW81AFfR9C3e+2dAL70mjp2UBlKD
	 mY/wvfO083XUfv7gD4RqY7oaEgFUFSGnhuZoASGs=
Date: Tue, 08 Apr 2025 18:14:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-add-lock_vma_under_rcu.patch added to mm-new branch
Message-Id: <20250409011425.C3E59C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: add lock_vma_under_rcu
has been added to the -mm mm-new branch.  Its filename is
     mm-rust-add-lock_vma_under_rcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-add-lock_vma_under_rcu.patch

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
Subject: mm: rust: add lock_vma_under_rcu
Date: Tue, 08 Apr 2025 09:22:41 +0000

Currently, the binder driver always uses the mmap lock to make changes to
its vma.  Because the mmap lock is global to the process, this can involve
significant contention.  However, the kernel has a feature called per-vma
locks, which can significantly reduce contention.  For example, you can
take a vma lock in parallel with an mmap write lock.  This is important
because contention on the mmap lock has been a long-term recurring
challenge for the Binder driver.

This patch introduces support for using `lock_vma_under_rcu` from Rust. 
The Rust Binder driver will be able to use this to reduce contention on
the mmap lock.

Link: https://lkml.kernel.org/r/20250408-vma-v16-4-d8b446e885d9@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/helpers/mm.c |    5 +++
 rust/kernel/mm.rs |   60 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

--- a/rust/helpers/mm.c~mm-rust-add-lock_vma_under_rcu
+++ a/rust/helpers/mm.c
@@ -43,3 +43,8 @@ struct vm_area_struct *rust_helper_vma_l
 {
 	return vma_lookup(mm, addr);
 }
+
+void rust_helper_vma_end_read(struct vm_area_struct *vma)
+{
+	vma_end_read(vma);
+}
--- a/rust/kernel/mm.rs~mm-rust-add-lock_vma_under_rcu
+++ a/rust/kernel/mm.rs
@@ -19,6 +19,7 @@ use crate::{
 use core::{ops::Deref, ptr::NonNull};
 
 pub mod virt;
+use virt::VmaRef;
 
 /// A wrapper for the kernel's `struct mm_struct`.
 ///
@@ -161,6 +162,36 @@ impl MmWithUser {
         unsafe { &*ptr.cast() }
     }
 
+    /// Attempt to access a vma using the vma read lock.
+    ///
+    /// This is an optimistic trylock operation, so it may fail if there is contention. In that
+    /// case, you should fall back to taking the mmap read lock.
+    ///
+    /// When per-vma locks are disabled, this always returns `None`.
+    #[inline]
+    pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadGuard<'_>> {
+        #[cfg(CONFIG_PER_VMA_LOCK)]
+        {
+            // SAFETY: Calling `bindings::lock_vma_under_rcu` is always okay given an mm where
+            // `mm_users` is non-zero.
+            let vma = unsafe { bindings::lock_vma_under_rcu(self.as_raw(), vma_addr) };
+            if !vma.is_null() {
+                return Some(VmaReadGuard {
+                    // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr, then it points at a
+                    // valid vma. The vma is stable for as long as the vma read lock is held.
+                    vma: unsafe { VmaRef::from_raw(vma) },
+                    _nts: NotThreadSafe,
+                });
+            }
+        }
+
+        // Silence warnings about unused variables.
+        #[cfg(not(CONFIG_PER_VMA_LOCK))]
+        let _ = vma_addr;
+
+        None
+    }
+
     /// Lock the mmap read lock.
     #[inline]
     pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
@@ -231,3 +262,32 @@ impl Drop for MmapReadGuard<'_> {
         unsafe { bindings::mmap_read_unlock(self.mm.as_raw()) };
     }
 }
+
+/// A guard for the vma read lock.
+///
+/// # Invariants
+///
+/// This `VmaReadGuard` guard owns the vma read lock.
+pub struct VmaReadGuard<'a> {
+    vma: &'a VmaRef,
+    // `vma_end_read` must be called on the same thread as where the lock was taken
+    _nts: NotThreadSafe,
+}
+
+// Make all `VmaRef` methods available on `VmaReadGuard`.
+impl Deref for VmaReadGuard<'_> {
+    type Target = VmaRef;
+
+    #[inline]
+    fn deref(&self) -> &VmaRef {
+        self.vma
+    }
+}
+
+impl Drop for VmaReadGuard<'_> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: We hold the read lock by the type invariants.
+        unsafe { bindings::vma_end_read(self.vma.as_ptr()) };
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

