Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07775C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011097; cv=none; b=RGQdFEsohyY3F+i+VdPBZdgba/hDYYgq/N15ujyqxBRkfiGMxukrXxbdQvYynOvD1SXLqMLfVhFWkgbUZwcTn/mjtsJSaAZkKaKVhbaxJNiwb/9irn2KqkV8Rg9jKVadv9A0chYnNjqPN2OEDr+UdpXwt2vTQIqnRMh6iTj1uIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011097; c=relaxed/simple;
	bh=0HuIxe7i3Q96BIDE3hG967fOwn0Tul8uCcE0BOhorYs=;
	h=Date:To:From:Subject:Message-Id; b=DXXhmXrRHp05juhJkQ0NLX6zy9nmhFpNp5nQwpNlAxbfSsLWG8TxSM/BybuFeH5SoB6sNHgL9Vzd3i7V5/lEnIRU5d1chQDzEhCXYWNYuwdkVtJ/5sdVHlxFno99IKbjgMTvaSK8U7FFxfDYn6MseP/Y5OAi0r8HehEseqTYih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ry6iQ3Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ry6iQ3Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF267C4CEE4;
	Mon, 12 May 2025 00:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011096;
	bh=0HuIxe7i3Q96BIDE3hG967fOwn0Tul8uCcE0BOhorYs=;
	h=Date:To:From:Subject:From;
	b=Ry6iQ3ZuvtsUu31OThySXyErAYRTBOOstfUX8LSPEbQUeDxhz7r5MOJISMZI9r3jR
	 Jhj//JxSYGClcub5AEtrMKQCcGDynGGsGUS1e4rTEXYWqGtUN9jwMADDJyRedYJd3y
	 0NUIrZgFpPQGGMfHYHtuZ55UxH3vxEPRrQP01H0U=
Date: Sun, 11 May 2025 17:51:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rust-add-mmput_async-support.patch removed from -mm tree
Message-Id: <20250512005136.CF267C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rust: add mmput_async support
has been removed from the -mm tree.  Its filename was
     mm-rust-add-mmput_async-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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


