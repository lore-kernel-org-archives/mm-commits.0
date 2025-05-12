Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C26C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011102; cv=none; b=qXdIzxEOKsXUMjnidYeiaKnC/kaonlrfhLvGRq7xRH/tWdkFpj9O9XYl2GSj0DbK5FDNOncLnrI9K2sL2+D16aLpLmyjznNZA4qxpH4YMZzWoehj2PSLFUtsLPGA+XrbkJoGAPRhcGxAtzun/mFrAedykWpbvzuo7PhlIfLv0YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011102; c=relaxed/simple;
	bh=bDXAZrjr9b/uwbxC3aGN1b0uT6096iSs0Z+hlzf1g64=;
	h=Date:To:From:Subject:Message-Id; b=vGfIU9QmrNpHQuyxKsN3t9O9aAOvp54EAbCnEOYvtg0YGQKH3KPsslszBEvREEFBGMzR1FpA5Enw7HIe8Oi57t9d/dcvURjAZKBeYigyQ6pAJ/uIus0n05fgLaTSNXA1/6V2rLDW1mCSTQZFUidKU8Jym02sEaa6JwRer24hzFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GrmzjLE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GrmzjLE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4ABC4CEE4;
	Mon, 12 May 2025 00:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011102;
	bh=bDXAZrjr9b/uwbxC3aGN1b0uT6096iSs0Z+hlzf1g64=;
	h=Date:To:From:Subject:From;
	b=GrmzjLE/fMYcNf0NBPDYV5FNQG/IRCgjeON/pwPE2Hd54r0r9oKdjSg8eIw7qyWQK
	 lGSXVe4DsE38xgEafbYPzN9L9f9qNSzrSW/Crt/3sy/z3FAstCOLWSZ8Lf7E2szhGj
	 MmdL/VCKHgyM9BpLz2gCXcQ7oja4/8FyYlOjyxCo=
Date: Sun, 11 May 2025 17:51:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rust-add-memory-management.patch removed from -mm tree
Message-Id: <20250512005142.5B4ABC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rust: add MEMORY MANAGEMENT [RUST]
has been removed from the -mm tree.  Its filename was
     mm-rust-add-memory-management.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: mm: rust: add MEMORY MANAGEMENT [RUST]
Date: Tue, 08 Apr 2025 09:22:46 +0000

We have introduced Rust bindings for core mm abstractions as part of this
series, so add an entry in MAINTAINERS to be explicit about who maintains
this.

Patches are anticipated to be taken through the mm tree as usual with
other mm code.

Link: https://rust-for-linux.com/rust-kernel-policy#how-is-rust-introduced-in-a-subsystem
Link: https://lore.kernel.org/all/33e64b12-aa07-4e78-933a-b07c37ff1d84@lucifer.local/
Link: https://lkml.kernel.org/r/20250408-vma-v16-9-d8b446e885d9@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
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

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~mm-rust-add-memory-management
+++ a/MAINTAINERS
@@ -15637,6 +15637,19 @@ F:	include/uapi/linux/userfaultfd.h
 F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
 
+MEMORY MANAGEMENT - RUST
+M:	Alice Ryhl <aliceryhl@google.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+L:	linux-mm@kvack.org
+L:	rust-for-linux@vger.kernel.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	rust/helpers/mm.c
+F:	rust/kernel/mm.rs
+F:	rust/kernel/mm/
+
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
_

Patches currently in -mm which might be from aliceryhl@google.com are


