Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6ADC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011095; cv=none; b=hNqDLQicmt2XWI93XEBTtDPUag+Wlmdjg2zcgFVox3dAxGHRpLAwGUukSEbxUpzx7FKRiJhBWGkTWB1ld50VcyeGnPkSFr+NNxm/vkzbXzmrp19DzKnAbZTTUa24njRAOlmv2E/BE2bOkE3Rex34FKgbwrjjzVnXr4bjhl1HbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011095; c=relaxed/simple;
	bh=5dPMjoGjq63bNJe9+R/z3zysSg1+QirrFtVjy+ShBk8=;
	h=Date:To:From:Subject:Message-Id; b=m4IG3zbIJ0CgTezmK2D/Aq6BEk8qlvj96FO55cVrd4qK5S1B1RYqXzxAqKEk7No4/FYVgRG3unmuLSPBr66RQYHsJNBcMtraCbIV98ypb7pUD8jCPS1+J9yEbPuaLEdIwGhazzCCaPPn5J88ey7CM9AoVzEQ/diUZN8P4u20CPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pV1Y7eNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pV1Y7eNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752B6C4CEE4;
	Mon, 12 May 2025 00:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011095;
	bh=5dPMjoGjq63bNJe9+R/z3zysSg1+QirrFtVjy+ShBk8=;
	h=Date:To:From:Subject:From;
	b=pV1Y7eNeYOQ/fdfPEz8qnzBYS1mI/hdm/2XJ1T5ESulPwcFOjOzyuD9hpRc7jrSjg
	 k2DvzRNUqVT4BqYx1ly6fbl/8NAk5hmnu2KX898ZEdv0NTw7xy7KJAgZeBu4FJ+6ys
	 n42WRITdyI4ELwLUjXHdCWu7pEye66pPPZ3GKrtc=
Date: Sun, 11 May 2025 17:51:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rust-add-lock_vma_under_rcu.patch removed from -mm tree
Message-Id: <20250512005135.752B6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rust: add lock_vma_under_rcu
has been removed from the -mm tree.  Its filename was
     mm-rust-add-lock_vma_under_rcu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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


