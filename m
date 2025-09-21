Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEA519F12D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 17:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758474159; cv=none; b=uEirPeLHd3xI9GeOED5oznFC6RGUpkEi1fguGbvsMbyBaCer+l2D6s+pPqU/7fN2U0MGMXGiWjS5rhXgx0aeaMp3rO/xoYvPCl54hNrggAxcAhOqoB8l+N4gsmkelEwj2GX8HVAor7Z7r0e2cXC2dpQAiLtAIEGfMRS6zAPqwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758474159; c=relaxed/simple;
	bh=0d2Bg6QquH4xEpyyc9X5IJxoefzQ1jVc2XiCq9BVMSo=;
	h=Date:To:From:Subject:Message-Id; b=gAxXqWJvl/+dbBAyV8cQB/eBG9s6UacxOgQuxiQvU6W8sdkgPncwf18ylwPu6z8EVkOHeQHGnfFxTKLVDnpuwjEK9l3C0DORCC61i7CW1wZn6rNqRfEErJS1mZ15kdtvtkf1wg6uzswLr7GrHxY7a2+sSIMTAI88M/ysq854XXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDMmMhRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDMmMhRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72085C4CEE7;
	Sun, 21 Sep 2025 17:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758474158;
	bh=0d2Bg6QquH4xEpyyc9X5IJxoefzQ1jVc2XiCq9BVMSo=;
	h=Date:To:From:Subject:From;
	b=LDMmMhRfYXrAJq8o4fUTAv97P/vXK1CmN0pZvoCFcI9tw1wdWNBeXczg4rDxK0ktz
	 NVVN4i3R6GdvG8lyDz4j5cSfTL/jk1UykfDx0/qWvn39BHT1TBi+5daUXo/2WJO/j4
	 +wbxe1tmhd8Dv2KFmXi82KYj0HU1h/w0X5nl3wMY=
Date: Sun, 21 Sep 2025 10:02:37 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,liam.howlett@oracle.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-maple_tree-add-mapletree-fix.patch added to mm-unstable branch
Message-Id: <20250921170238.72085C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: maple_tree: fix intra-doc link
has been added to the -mm mm-unstable branch.  Its filename is
     rust-maple_tree-add-mapletree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-maple_tree-add-mapletree-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Miguel Ojeda <ojeda@kernel.org>
Subject: rust: maple_tree: fix intra-doc link
Date: Wed, 10 Sep 2025 16:02:12 +0200

A couple `Occupied` intra-doc links are broken:

    error: unresolved link to `Occupied`
      --> rust/kernel/maple_tree.rs:96:46
       |
    96 |     /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
       |                                              ^^^^^^^^ no item named `Occupied` in scope
       |
       = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`
       = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

    error: unresolved link to `Occupied`
       --> rust/kernel/maple_tree.rs:135:36
        |
    135 |     /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
        |                                    ^^^^^^^^ no item named `Occupied` in scope
        |
        = help: to escape `[` and `]` characters, add '\' before them like `\[` or `\]`

Thus fix them.

Link: https://lkml.kernel.org/r/20250910140212.997771-1-ojeda@kernel.org
Fixes: 7f51d867d2ed ("rust: maple_tree: add MapleTree")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/maple_tree.rs |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/rust/kernel/maple_tree.rs~rust-maple_tree-add-mapletree-fix
+++ a/rust/kernel/maple_tree.rs
@@ -73,8 +73,7 @@ impl<T: ForeignOwnable> MapleTree<T> {
     /// # Errors
     ///
     /// If the maple tree already contains a range using the given index, then this call will
-    /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
-    /// allocation fails.
+    /// return an [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails.
     ///
     /// # Examples
     ///
@@ -112,8 +111,8 @@ impl<T: ForeignOwnable> MapleTree<T> {
     /// # Errors
     ///
     /// If the maple tree already contains an overlapping range, then this call will return an
-    /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
-    /// or if the requested range is invalid (e.g. empty).
+    /// [`InsertErrorKind::Occupied`]. It may also fail if memory allocation fails or if the
+    /// requested range is invalid (e.g. empty).
     ///
     /// # Examples
     ///
_

Patches currently in -mm which might be from ojeda@kernel.org are

rust-maple_tree-add-mapletree-fix.patch

