Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B962F7EEE
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968163; cv=none; b=kt++W6Kky+1Y6lmlNFOQzikJn4wRcnoj/bowfRR9BlZzkSFTvpTJCdsSxxa5feaWQhzCJPIPrVlmxuPFKg4oyguPfGTpoQebq4m3d6AFl9lBCASN7Ab9uF4GrOjEfpfyzIKfz/RlyvXGGUpst0c4JzJ8ZO6DMECvUS8p29jm034=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968163; c=relaxed/simple;
	bh=Ltnp74wkyq9vb5Y9KMO2wZlLX5I/lcm5cG2HMs4FiKc=;
	h=Date:To:From:Subject:Message-Id; b=pz0hGlgAlztEvI6Tx7XA7Ne09l2MxG/nnCctuSA2/lpf7XloNUTPBqWPP+xL2WjvwGKYn1FeqsOdBFcXO7EBnWzsK+pa8GVENngj6awO/Lo51NouOpoVtlhOTVQ9MN3GTFEZNsrt6Sl2YQ7zQP8OL+5ewdQ41wYitnqhPP1Wwb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2pSaul9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2pSaul9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8CD1F00893;
	Tue,  9 Jun 2026 01:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968162;
	bh=ogB3oX2BFFFfx+wqhTUyWnGn+L/8DdPiAQ8f/FUtykg=;
	h=Date:To:From:Subject;
	b=2pSaul9bm5frltkN/OUwbW2F8+vlYgcaAJM7bLraSISG7PXlNq8+g6QeF+P5Pktip
	 2OPR/Bjg/qzGSK13DCHtqk83CxOQ61ZBluSO+nVnPS75n9cA4hFqR2ToRpiaHnbwDY
	 pX0ykC364vMy+xt7fLPPz6JqpdzCoOzVXAEGiEbU=
Date: Mon, 08 Jun 2026 18:22:41 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,ojeda@kernel.org,ljs@kernel.org,liam@infradead.org,gary@garyguo.net,dakr@kernel.org,bjorn3_gh@protonmail.com,aliceryhl@google.com,a.hindborg@kernel.org,nakamura.shuta@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rust-page-mark-page-nid-as-inline.patch removed from -mm tree
Message-Id: <20260609012242.3B8CD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: page: mark Page::nid as inline
has been removed from the -mm tree.  Its filename was
     rust-page-mark-page-nid-as-inline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nakamura Shuta <nakamura.shuta@gmail.com>
Subject: rust: page: mark Page::nid as inline
Date: Fri, 29 May 2026 17:53:16 +0900

When building the kernel, the following Rust symbol is generated:

  $ nm vmlinux | grep ' _R'.*Page | rustfilt
  <kernel::page::Page>::nid

`Page::nid` is a trivial wrapper around the C function `page_to_nid`.  It
does not make sense to go through a trivial wrapper for this function, so
mark it inline.

This follows commit 878620c5a93a ("rust: page: optimize rust symbol
generation for Page"), which did the same for `alloc_page` and `drop`.

Link: https://github.com/Rust-for-Linux/linux/issues/1145
Link: https://lore.kernel.org/20260529085316.27432-1-nakamura.shuta@gmail.com
Signed-off-by: Nakamura Shuta <nakamura.shuta@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 rust/kernel/page.rs |    1 +
 1 file changed, 1 insertion(+)

--- a/rust/kernel/page.rs~rust-page-mark-page-nid-as-inline
+++ a/rust/kernel/page.rs
@@ -193,6 +193,7 @@ impl Page {
     }
 
     /// Get the node id containing this page.
+    #[inline]
     pub fn nid(&self) -> i32 {
         // SAFETY: Always safe to call with a valid page.
         unsafe { bindings::page_to_nid(self.as_ptr()) }
_

Patches currently in -mm which might be from nakamura.shuta@gmail.com are


