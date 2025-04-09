Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947D6153836
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744161277; cv=none; b=uYnCLTaK7ivFc1KWzj8kwY6j3pul4QFf982KcPBOFGN8AErTGjrvD2fadZGerKwdKdbQHz61514kaojuoH6Gz6OnVqc8x96KwlcSFFfh0x1rHjMmgAAyhF7FzADZWnBg0NpJ3swZ/Kmxq/+wmtgZRbSKaYOUZ+2uwJbMjE7zSuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744161277; c=relaxed/simple;
	bh=vizIcAEV4t3IAa+c+NObmGqrLFtj8YKDI0cKzyi/CK8=;
	h=Date:To:From:Subject:Message-Id; b=SK2DfTw6KQ9ZLA32hPqGdBZQWvvHvHpAzSaupVVt+ncyXOU3sMwnKXVy46exdjT/T09NMjGADlwwMCm7IdBx669KFW9yNFjgAsoiHs/D9lXzPoacaO/Li9SA0CMSfN76EunkrhPwNfLktfSSfkH8PvtJLw5w2pX4hHOTIoTDGn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DMb1o5/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DMb1o5/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B34C4CEE5;
	Wed,  9 Apr 2025 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744161277;
	bh=vizIcAEV4t3IAa+c+NObmGqrLFtj8YKDI0cKzyi/CK8=;
	h=Date:To:From:Subject:From;
	b=DMb1o5/aakb+jvaU1wHcLlmIMzclHNcCaQIBl85nziFm6XMu3LbB90N+lzOuuju2l
	 s7gI1OqcIe3B5y3WVZzSUng4Bbn86HiIvAXvfGWuIQI76YwByEyBxc+tNeIU6etvoI
	 frduQxpaA4sNU/W2i7tbblKriI1YnfGeO3uUe7Ek=
Date: Tue, 08 Apr 2025 18:14:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tmgross@umich.edu,surenb@google.com,ojeda@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jhubbard@nvidia.com,jannh@google.com,gregkh@linuxfoundation.org,gary@garyguo.net,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,balbirs@nvidia.com,arnd@arndb.de,alex.gaynor@gmail.com,a.hindborg@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rust-add-memory-management.patch added to mm-new branch
Message-Id: <20250409011436.F0B34C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rust: add MEMORY MANAGEMENT [RUST]
has been added to the -mm mm-new branch.  Its filename is
     mm-rust-add-memory-management.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rust-add-memory-management.patch

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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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
@@ -15532,6 +15532,19 @@ F:	include/uapi/linux/userfaultfd.h
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

mm-rust-add-abstraction-for-struct-mm_struct.patch
mm-rust-add-vm_area_struct-methods-that-require-read-access.patch
mm-rust-add-vm_insert_page.patch
mm-rust-add-lock_vma_under_rcu.patch
mm-rust-add-mmput_async-support.patch
mm-rust-add-vmanew-for-f_ops-mmap.patch
rust-miscdevice-add-mmap-support.patch
task-rust-rework-how-current-is-accessed.patch
mm-rust-add-memory-management.patch

