Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A720C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011094; cv=none; b=dhN8nMW1Fw2CK4EE4j+aOcD8x1LzXocmns6gMkz4Bldbo5iMTtm+RjjuWVnY4Trd1wC0wDNcxi2FI4jBxHFTgpAnFYmCQxeO2uM0DXFS4Ebg3qGtIC7Pkr0hNVk6eH6uwc+VXyXTaVMGLWLQIEJKsUlZJhRW87NUCYs30Nh2WyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011094; c=relaxed/simple;
	bh=4oblZsmQr+KfZbNYmjNHMHWjcEb9ERHMxuSP8uC1U6E=;
	h=Date:To:From:Subject:Message-Id; b=bkSlBlMGX51tY4ld+FCyhVffR174Nh53vo6mlVKz5SEjTxoYN10SEQaYG940jGUYoi1TwTmkLFwOyHtYKSVu1duvpYhjp6LLdAEwAqm3eLSmR8Lji0Vti9mHN7tGCdmnK3yD11gKcMvjTJ2WWaHuzl52QCLN0j1kD/2MDa0IeBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=usQAekzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="usQAekzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E626C4CEE4;
	Mon, 12 May 2025 00:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011094;
	bh=4oblZsmQr+KfZbNYmjNHMHWjcEb9ERHMxuSP8uC1U6E=;
	h=Date:To:From:Subject:From;
	b=usQAekzDdtnKAZVnE/PTPQK3gz1oRX/zCwKW3d/MguqpUT2JUvHpkEvenuXmWC2DE
	 WK82hvpwEll77F9Yx9IWhw16tx4BzfC79z2twEiMqvsZxGOmN4KmHiGvfsQ69WVAdk
	 vJcT6QvT6x7iphYbwZ+yd/F9Guzo+GhSWTeekEHY=
Date: Sun, 11 May 2025 17:51:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rust-add-vm_insert_page.patch removed from -mm tree
Message-Id: <20250512005134.1E626C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rust: add vm_insert_page
has been removed from the -mm tree.  Its filename was
     mm-rust-add-vm_insert_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm: rust: add vm_insert_page
Date: Tue, 08 Apr 2025 09:22:40 +0000

The vm_insert_page method is only usable on vmas with the VM_MIXEDMAP
flag, so we introduce a new type to keep track of such vmas.

The approach used in this patch assumes that we will not need to encode
many flag combinations in the type.  I don't think we need to encode more
than VM_MIXEDMAP and VM_PFNMAP as things are now.  However, if that
becomes necessary, using generic parameters in a single type would scale
better as the number of flags increases.

Link: https://lkml.kernel.org/r/20250408-vma-v16-3-d8b446e885d9@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/mm/virt.rs |   79 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

--- a/rust/kernel/mm/virt.rs~mm-rust-add-vm_insert_page
+++ a/rust/kernel/mm/virt.rs
@@ -14,7 +14,15 @@
 //! ensures that you can't, for example, accidentally call a function that requires holding the
 //! write lock when you only hold the read lock.
 
-use crate::{bindings, mm::MmWithUser, types::Opaque};
+use crate::{
+    bindings,
+    error::{to_result, Result},
+    mm::MmWithUser,
+    page::Page,
+    types::Opaque,
+};
+
+use core::ops::Deref;
 
 /// A wrapper for the kernel's `struct vm_area_struct` with read access.
 ///
@@ -119,6 +127,75 @@ impl VmaRef {
             bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
         };
     }
+
+    /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
+    /// returns `None`.
+    ///
+    /// This can be used to access methods that require [`VM_MIXEDMAP`] to be set.
+    ///
+    /// [`VM_MIXEDMAP`]: flags::MIXEDMAP
+    #[inline]
+    pub fn as_mixedmap_vma(&self) -> Option<&VmaMixedMap> {
+        if self.flags() & flags::MIXEDMAP != 0 {
+            // SAFETY: We just checked that `VM_MIXEDMAP` is set. All other requirements are
+            // satisfied by the type invariants of `VmaRef`.
+            Some(unsafe { VmaMixedMap::from_raw(self.as_ptr()) })
+        } else {
+            None
+        }
+    }
+}
+
+/// A wrapper for the kernel's `struct vm_area_struct` with read access and [`VM_MIXEDMAP`] set.
+///
+/// It represents an area of virtual memory.
+///
+/// This struct is identical to [`VmaRef`] except that it must only be used when the
+/// [`VM_MIXEDMAP`] flag is set on the vma.
+///
+/// # Invariants
+///
+/// The caller must hold the mmap read lock or the vma read lock. The `VM_MIXEDMAP` flag must be
+/// set.
+///
+/// [`VM_MIXEDMAP`]: flags::MIXEDMAP
+#[repr(transparent)]
+pub struct VmaMixedMap {
+    vma: VmaRef,
+}
+
+// Make all `VmaRef` methods available on `VmaMixedMap`.
+impl Deref for VmaMixedMap {
+    type Target = VmaRef;
+
+    #[inline]
+    fn deref(&self) -> &VmaRef {
+        &self.vma
+    }
+}
+
+impl VmaMixedMap {
+    /// Access a virtual memory area given a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that `vma` is valid for the duration of 'a, and that the mmap read lock
+    /// (or stronger) is held for at least the duration of 'a. The `VM_MIXEDMAP` flag must be set.
+    #[inline]
+    pub unsafe fn from_raw<'a>(vma: *const bindings::vm_area_struct) -> &'a Self {
+        // SAFETY: The caller ensures that the invariants are satisfied for the duration of 'a.
+        unsafe { &*vma.cast() }
+    }
+
+    /// Maps a single page at the given address within the virtual memory area.
+    ///
+    /// This operation does not take ownership of the page.
+    #[inline]
+    pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
+        // SAFETY: By the type invariant of `Self` caller has read access and has verified that
+        // `VM_MIXEDMAP` is set. By invariant on `Page` the page has order 0.
+        to_result(unsafe { bindings::vm_insert_page(self.as_ptr(), address, page.as_ptr()) })
+    }
 }
 
 /// The integer type used for vma flags.
_

Patches currently in -mm which might be from aliceryhl@google.com are


