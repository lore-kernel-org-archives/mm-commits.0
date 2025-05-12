Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3358C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011099; cv=none; b=VD4ZyuRQa2lNvaO99tYz+awaoVZ+Do3TwCf3uxRuYMFlnhm+LabynLWPrcpr4xOWib0w5PFceembjllq59RR/ypNTqwOv0dr0wnGRJrWHgdiMXEts8wE14NraLykptU/wu0DwNGG+9lU5J+BpEffvpbSXPaiPbwSz3TAj4DQsrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011099; c=relaxed/simple;
	bh=Sg3E3deoNIGurG1vea16vn78D7jYqXk+gDSDSflJL28=;
	h=Date:To:From:Subject:Message-Id; b=SfBe2+LPD4hx9w2NKVpltjDVWw/yV6hR87cG5uEPV6iYlDBmQvM3xdhuTJoVDfYKa/UP6ptedLIjqEplepKTUapYKe/7gGZcVLZR+YuV300CNE2k+PSYkcS+4KsIehm/FLouqs0RPfn2Nl2fVXv8hZc05+nj0643Pc74Q1+3yow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qJ+I0iNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qJ+I0iNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD94C4CEE4;
	Mon, 12 May 2025 00:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011099;
	bh=Sg3E3deoNIGurG1vea16vn78D7jYqXk+gDSDSflJL28=;
	h=Date:To:From:Subject:From;
	b=qJ+I0iNsuslStRO6UZsU9Zk0utnvVnEfrJixMnZSUjX1nJ40ArHWGLPbIf+bBTznL
	 GOiB8v0IM/CyKqNx2jXlLrFlrQUR7vpRWvgVw36I2wKudhqBPYRsCzwH8Rf+difcRY
	 IEKuE/+He4RU2ste3EB2CeZxYWoqy5GULb/YJJgg=
Date: Sun, 11 May 2025 17:51:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rust-miscdevice-add-mmap-support.patch removed from -mm tree
Message-Id: <20250512005139.7DD94C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: miscdevice: add mmap support
has been removed from the -mm tree.  Its filename was
     rust-miscdevice-add-mmap-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: rust: miscdevice: add mmap support
Date: Tue, 08 Apr 2025 09:22:44 +0000

Add the ability to write a file_operations->mmap hook in Rust when using
the miscdevice abstraction.  The `vma` argument to the `mmap` hook uses
the `VmaNew` type from the previous commit; this type provides the correct
set of operations for a file_operations->mmap hook.

Link: https://lkml.kernel.org/r/20250408-vma-v16-7-d8b446e885d9@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Cc: Jann Horn <jannh@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/miscdevice.rs |   45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/rust/kernel/miscdevice.rs~rust-miscdevice-add-mmap-support
+++ a/rust/kernel/miscdevice.rs
@@ -14,6 +14,7 @@ use crate::{
     error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
     ffi::{c_int, c_long, c_uint, c_ulong},
     fs::File,
+    mm::virt::VmaNew,
     prelude::*,
     seq_file::SeqFile,
     str::CStr,
@@ -119,6 +120,22 @@ pub trait MiscDevice: Sized {
         drop(device);
     }
 
+    /// Handle for mmap.
+    ///
+    /// This function is invoked when a user space process invokes the `mmap` system call on
+    /// `file`. The function is a callback that is part of the VMA initializer. The kernel will do
+    /// initial setup of the VMA before calling this function. The function can then interact with
+    /// the VMA initialization by calling methods of `vma`. If the function does not return an
+    /// error, the kernel will complete initialization of the VMA according to the properties of
+    /// `vma`.
+    fn mmap(
+        _device: <Self::Ptr as ForeignOwnable>::Borrowed<'_>,
+        _file: &File,
+        _vma: &VmaNew,
+    ) -> Result {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
+
     /// Handler for ioctls.
     ///
     /// The `cmd` argument is usually manipulated using the utilties in [`kernel::ioctl`].
@@ -226,6 +243,33 @@ impl<T: MiscDevice> MiscdeviceVTable<T>
     /// # Safety
     ///
     /// `file` must be a valid file that is associated with a `MiscDeviceRegistration<T>`.
+    /// `vma` must be a vma that is currently being mmap'ed with this file.
+    unsafe extern "C" fn mmap(
+        file: *mut bindings::file,
+        vma: *mut bindings::vm_area_struct,
+    ) -> c_int {
+        // SAFETY: The mmap call of a file can access the private data.
+        let private = unsafe { (*file).private_data };
+        // SAFETY: This is a Rust Miscdevice, so we call `into_foreign` in `open` and
+        // `from_foreign` in `release`, and `fops_mmap` is guaranteed to be called between those
+        // two operations.
+        let device = unsafe { <T::Ptr as ForeignOwnable>::borrow(private) };
+        // SAFETY: The caller provides a vma that is undergoing initial VMA setup.
+        let area = unsafe { VmaNew::from_raw(vma) };
+        // SAFETY:
+        // * The file is valid for the duration of this call.
+        // * There is no active fdget_pos region on the file on this thread.
+        let file = unsafe { File::from_raw_file(file) };
+
+        match T::mmap(device, file, area) {
+            Ok(()) => 0,
+            Err(err) => err.to_errno(),
+        }
+    }
+
+    /// # Safety
+    ///
+    /// `file` must be a valid file that is associated with a `MiscDeviceRegistration<T>`.
     unsafe extern "C" fn ioctl(file: *mut bindings::file, cmd: c_uint, arg: c_ulong) -> c_long {
         // SAFETY: The ioctl call of a file can access the private data.
         let private = unsafe { (*file).private_data };
@@ -291,6 +335,7 @@ impl<T: MiscDevice> MiscdeviceVTable<T>
     const VTABLE: bindings::file_operations = bindings::file_operations {
         open: Some(Self::open),
         release: Some(Self::release),
+        mmap: if T::HAS_MMAP { Some(Self::mmap) } else { None },
         unlocked_ioctl: if T::HAS_IOCTL {
             Some(Self::ioctl)
         } else {
_

Patches currently in -mm which might be from aliceryhl@google.com are


