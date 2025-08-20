Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E92280312
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 23:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755732171; cv=none; b=jyah4VhlOkNpQqBY9XGPzUL7UyHbqqWxoXv1B/LmxQUv+FMKJy3GpUZrV8Rw0TCUKRZua5zkNth0NCFdgEhJUco4ssc6t9USVlaelox2Ftg4ql1WLWGclhF9UawINkNA/EMgZOG4O5XbY/r1eGDtawxkNrYqD4wlRBxNcJsI6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755732171; c=relaxed/simple;
	bh=62w7V+Wqqr5VhnRBmH02pRcE5PLKQWhgkosBAF8VRmI=;
	h=Date:To:From:Subject:Message-Id; b=qLvTlI7xkR1ckGyqpk6DnHI73uejQWfWhYijmtF1CpyLykmidZ87pQNt+qcILnctWJVaiR2pJnXZlJUFYIhvc2C8l5M3mVDbB4DQZy2i//LX7MXWfu8TKN4/WzfDJAp/P4TLNFYSPUyb8QwSDNFx2lQrDZ7BRmZEmkcb0LdTwLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GOzzk48U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GOzzk48U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B1BC4CEE7;
	Wed, 20 Aug 2025 23:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755732170;
	bh=62w7V+Wqqr5VhnRBmH02pRcE5PLKQWhgkosBAF8VRmI=;
	h=Date:To:From:Subject:From;
	b=GOzzk48Udd1zwo9EHlPSiqLeT76/6M8r/wXuyxhCHCB7apv1A+XGjK1WpQlYll1UC
	 BthxbgCKsqFpNP1iWhJQ/lpT3Rr4NQ9t0RyinTuYZ4vl0oZr9eMk2cj92Xw58tkygX
	 NMMDrgOFfU+8DUXoD9NPZNt5c6b6kckfP7EbJLHI=
Date: Wed, 20 Aug 2025 16:22:49 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,baptiste.lepers@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rust-mm-mark-vmanew-as-transparent.patch added to mm-unstable branch
Message-Id: <20250820232250.41B1BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rust: mm: mark VmaNew as transparent
has been added to the -mm mm-unstable branch.  Its filename is
     rust-mm-mark-vmanew-as-transparent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rust-mm-mark-vmanew-as-transparent.patch

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
From: Baptiste Lepers <baptiste.lepers@gmail.com>
Subject: rust: mm: mark VmaNew as transparent
Date: Tue, 12 Aug 2025 15:26:56 +0200

Unsafe code in VmaNew's methods assumes that the type has the same layout
as the inner `bindings::vm_area_struct`.  This is not guaranteed by the
default struct representation in Rust, but requires specifying the
`transparent` representation.

Link: https://lkml.kernel.org/r/20250812132712.61007-1-baptiste.lepers@gmail.com
Fixes: dcb81aeab406e ("mm: rust: add VmaNew for f_ops->mmap()")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/mm/virt.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/kernel/mm/virt.rs~rust-mm-mark-vmanew-as-transparent
+++ a/rust/kernel/mm/virt.rs
@@ -209,6 +209,7 @@ impl VmaMixedMap {
 ///
 /// For the duration of 'a, the referenced vma must be undergoing initialization in an
 /// `f_ops->mmap()` hook.
+#[repr(transparent)]
 pub struct VmaNew {
     vma: VmaRef,
 }
_

Patches currently in -mm which might be from baptiste.lepers@gmail.com are

rust-mm-mark-vmanew-as-transparent.patch

