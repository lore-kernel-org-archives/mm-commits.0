Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4885870814
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758485269; cv=none; b=c/KTpyNRDYJUgpadmImW4KYXBmFu7qesLtY1pqOFGobve900ZeP+swiYXJW8Bxp3dK5yQlBC61scObwg9IWh2FmbQXI7UYy1QRUG6+g49Xf2wtQPCCpC01pKfiPzN4RYQDEF5v+QZ/NCHcpB/bBp6otl4u9bXW8fRRTCOYMtqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758485269; c=relaxed/simple;
	bh=Vzi04e5i2s8V6lXY6IK2TEvKFYkI5PrjGmH+Po7f4/s=;
	h=Date:To:From:Subject:Message-Id; b=ck0V9npanTEA5Z0DA4UIFD3LtXAeNaCBPn3j2yfRz31hXifEF4shwTc6jTZzeiKxLWLw+R4RpdNhf0H6jYwxHyyMuKpTz5SLI5cYgOIegTeVrDQIRO0hADQz74y3njC5OyV0YMC01awiFcn3H2QqqSct3w/tuTuEawbjM3p3Mas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B3VmM0Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B3VmM0Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF338C4CEE7;
	Sun, 21 Sep 2025 20:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758485268;
	bh=Vzi04e5i2s8V6lXY6IK2TEvKFYkI5PrjGmH+Po7f4/s=;
	h=Date:To:From:Subject:From;
	b=B3VmM0KutKbXSiYCSuYdgsUeQ4y5F/Yl3EvHdv8Y7HoUgITfCwQV8UQCEUtRM4Ts5
	 k4SyecoDurWVqnHVYa7IHNbAR04t1c5tAIgcS/xVj3dVuwwbwMRcGvOO8IU44gVO9o
	 Acv1T9LQ4QA41JQgurjoc4hIiGZgaPzeDY0bWU/E=
Date: Sun, 21 Sep 2025 13:07:48 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,liam.howlett@oracle.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,andrewjballance@gmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,ojeda@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] rust-maple_tree-add-mapletree-fix.patch removed from -mm tree
Message-Id: <20250921200748.AF338C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: maple_tree: fix intra-doc link
has been removed from the -mm tree.  Its filename was
     rust-maple_tree-add-mapletree-fix.patch

This patch was dropped because it was folded into rust-maple_tree-add-mapletree.patch

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

rust-maple_tree-add-mapletree.patch

