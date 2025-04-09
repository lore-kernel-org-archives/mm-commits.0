Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337262AE89
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161273; cv=none; b=BGdyFqESEIZP7CjhNSRuUg/GMQ02us0oEZXzzp6A8C3WU5YgJKKPhRkmt+WOtRxRLVoHOmIcpf/Cors0GPlFsEnSw3tyTN3cRCGV5+FkOwmRcuVjqJ+2SZzP7h98GNXraWJCzEbbYg2SLKnpbVQyHZB1hytSxlMiU61qUL4KBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161273; c=relaxed/simple;
	bh=AzjrOXArPAGXzgPNiz11YZ6qo7ktziPLUdSYBFFAf2E=;
	h=Date:To:From:Subject:Message-Id; b=INwkAM5DtmLtZR2oGQ1xUcyNPs1leCNK7pSRIUqf1/oy+MUtAmmEIRMCyn8O6QBom/iZi96SFuoWnIkbq3GixieoBBhSrZSS7DjKSS3FufeY2N8zQ6LGME/m66te5ze007QwXpMiZiQciDUonwT+rxRhoDUGOv8d/qb++aBb1tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ayVeIfAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayVeIfAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AEBC4CEE5;
	Wed,  9 Apr 2025 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161272;
	bh=AzjrOXArPAGXzgPNiz11YZ6qo7ktziPLUdSYBFFAf2E=;
	h=Date:To:From:Subject:From;
	b=ayVeIfAvDkbGH+FFdp9Gk77fk4N8L2m7meGOaT45oaJAIJ/CiS0n8vcIVmF8e5fTz
	 D5rmhjGrtw4TVOA4buvCq3WWp1FO+he8+kBIzygVAsmhPXuI+errPEICoAbAUJxdAZ
	 WR3OgGMwMUap5+iB6IBQjBlqXLjEs//mIS7tl9FM=
Date: Tue, 08 Apr 2025 18:14:32 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-miscdevice-add-mmap-support.patch added to mm-new branch
Message-Id: <20250409011432.91AEBC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: miscdevice: add mmap support
has been added to the -mm mm-new branch.  Its filename is
     rust-miscdevice-add-mmap-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-miscdevice-add-mmap-support.patch

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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-rust-add-abstraction-for-struct-mm_struct.patch
mm-rust-add-vm_area_struct-methods-that-require-read-access.patch
mm-rust-add-vm_insert_page.patch
mm-rust-add-lock_vma_under_rcu.patch
mm-rust-add-mmput_async-support.patch
mm-rust-add-vmanew-for-f_ops-mmap.patch
rust-miscdevice-add-mmap-support.patch
task-rust-rework-how-current-is-accessed.patch
mm-rust-add-memory-management.patch

