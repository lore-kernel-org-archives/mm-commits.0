Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAEC272E57;
	Thu, 28 Aug 2025 05:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756359972; cv=none; b=Vhfk6/qhP4ijHGj09zKE1VBm4Zf2fO2IzlWRVApWF9gAyT6BKel7J55ihveImPGaeHDSOYYTSSwsYpGy9go5D993vu1CP4gVLNqtWj/5pSaoOz9al2TU8Tfom8GYUGGDXMaN9vIhSwJd8iRw362BD3nWUmk4jGZPoCdUr8uEFss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756359972; c=relaxed/simple;
	bh=msu132dyannCyafQMeiTNr8Qs3Glq3+VHcUQvdnt3Ic=;
	h=Date:To:From:Subject:Message-Id; b=Bq5zxbjb65oUQF39PMEya/kSJUgBbSnEvV36/2jplxVEKndOlttv2Q2pds67KbJkm4ZnElYO+lb9WeELUOmq9sVRUzzQGTe/ZVcqIQpAMsf+mikrYDxWPmAEtmLppufq4nJrZLzEEGBX+Pm1iDEyhsX++Lybv9lGCoJ7oYBxIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R8iHd/Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R8iHd/Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C7C4CEEB;
	Thu, 28 Aug 2025 05:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756359971;
	bh=msu132dyannCyafQMeiTNr8Qs3Glq3+VHcUQvdnt3Ic=;
	h=Date:To:From:Subject:From;
	b=R8iHd/Fh6n1GihW+9OzrXT5IIQ32bcF1eWaFguccMVANUt/5svL+j+tWiEE9J0cGF
	 5s+2/4PbUyWVZZbKaLqk1Ta+b773o6dICZH4fohvd09QktNdwl+QaUgpMXHTJu/PuA
	 zvMhiIRJOh6cPkLHAdACdNwAeN9UrubwKIBw0n1E=
Date: Wed, 27 Aug 2025 22:46:10 -0700
To: mm-commits@vger.kernel.org,tmgross@umich.edu,stable@vger.kernel.org,ojeda@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,gary@garyguo.net,dakr@kernel.org,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@kernel.org,baptiste.lepers@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] rust-mm-mark-vmanew-as-transparent.patch removed from -mm tree
Message-Id: <20250828054611.748C7C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rust: mm: mark VmaNew as transparent
has been removed from the -mm tree.  Its filename was
     rust-mm-mark-vmanew-as-transparent.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baptiste Lepers <baptiste.lepers@gmail.com>
Subject: rust: mm: mark VmaNew as transparent
Date: Tue, 12 Aug 2025 15:26:56 +0200

Unsafe code in VmaNew's methods assumes that the type has the same layout
as the inner `bindings::vm_area_struct`.  This is not guaranteed by the
default struct representation in Rust, but requires specifying the
`transparent` representation.

Link: https://lkml.kernel.org/r/20250812132712.61007-1-baptiste.lepers@gmail.com
Fixes: dcb81aeab406 ("mm: rust: add VmaNew for f_ops->mmap()")
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
Cc: <stable@vger.kernel.org>
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


