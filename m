Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1A2AE89
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161269; cv=none; b=mRPN65tT9itdjKR6do0VBXUdTEA1yilYTFVaoMvUt7tG4PtNHBizUjGNRf1oMB4nbJCxV5AZWNdrikod5Em3ku9OcRf37DWDmnlImV9mMEjQbXM9CYgmr7orpwFAkukn21Ly6QDyj0tifLtxJyy7ZqyIzTa2ALpoDJ8fNeITdRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161269; c=relaxed/simple;
	bh=Mjrne1nMfXn7JaOApARUep7BU3sYZ6d6P/cDAnpEpoo=;
	h=Date:To:From:Subject:Message-Id; b=My2V3/9kXv1o60GcW/2yOT9326AmqkX1DqAZVr49JlmDOxQpx1UzEEHIzgAZarfzEt1C3knMkLBAes/H/PKW3ppo6akRPRED7/XlcpPiq3IW3CX6HtrCkykdO17UphiLX4nONc19SPQ7e6ghGVkbrtwVYX/VlHjRq32NMhTw+/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V17qxlTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V17qxlTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554F3C4CEE5;
	Wed,  9 Apr 2025 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161268;
	bh=Mjrne1nMfXn7JaOApARUep7BU3sYZ6d6P/cDAnpEpoo=;
	h=Date:To:From:Subject:From;
	b=V17qxlTev5+bjZTBdPHjNE5JHqlDyw/38PmuvAvIIUr9xQH2GpVgxZUh9M/i2Z63y
	 1MPnysHuRPU7SuAMWZslwG998pmbvmCsmK53lWsr9yO31O2uncmaecLeNRfJDPVtby
	 2jkZIcsVVRza2d2u9EmNShxWLSvliKkCSzI8CAws=
Date: Tue, 08 Apr 2025 18:14:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-add-mmput_async-support.patch added to mm-new branch
Message-Id: <20250409011428.554F3C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: add mmput_async support
has been added to the -mm mm-new branch.  Its filename is
     mm-rust-add-mmput_async-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-add-mmput_async-support.patch

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
Subject: mm: rust: add mmput_async support
Date: Tue, 08 Apr 2025 09:22:42 +0000

Adds an MmWithUserAsync type that uses mmput_async when dropped but is
otherwise identical to MmWithUser.  This has to be done using a separate
type because the thing we are changing is the destructor.

Rust Binder needs this to avoid a certain deadlock.  See commit
9a9ab0d96362 ("binder: fix race between mmput() and do_exit()") for
details.  It's also needed in the shrinker to avoid cleaning up the mm in
the shrinker's context.

Link: https://lkml.kernel.org/r/20250408-vma-v16-5-d8b446e885d9@google.com
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/mm.rs |   51 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/rust/kernel/mm.rs~mm-rust-add-mmput_async-support
+++ a/rust/kernel/mm.rs
@@ -111,6 +111,50 @@ impl Deref for MmWithUser {
     }
 }
 
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
 // These methods are safe to call even if `mm_users` is zero.
 impl Mm {
     /// Returns a raw pointer to the inner `mm_struct`.
@@ -162,6 +206,13 @@ impl MmWithUser {
         unsafe { &*ptr.cast() }
     }
 
+    /// Use `mmput_async` when dropping this refcount.
+    #[inline]
+    pub fn into_mmput_async(me: ARef<MmWithUser>) -> ARef<MmWithUserAsync> {
+        // SAFETY: The layouts and invariants are compatible.
+        unsafe { ARef::from_raw(ARef::into_raw(me).cast()) }
+    }
+
     /// Attempt to access a vma using the vma read lock.
     ///
     /// This is an optimistic trylock operation, so it may fail if there is contention. In that
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

