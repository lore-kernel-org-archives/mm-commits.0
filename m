Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF12178C9B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103880; cv=none; b=fToeu9SdPy8dBnINGw9otxHepftB1cRJ8pK35VS9u34riyhpGvQWYvC69VesICN5TYA1Gv5FdqPl/Zd5Pu53y8BWTK8OGG5HIpwpjGYj0j0k+l8QwYazNERfu+UMKlf8DfNrCMm7vQVIF5U0C7GmVTa8SE+eTRcKkwo/bGbMOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103880; c=relaxed/simple;
	bh=Wnt0F+UssyNnpv/Tc1thDLGXkbQSdPXL0Y0R80+X7ys=;
	h=Date:To:From:Subject:Message-Id; b=kBERrK7Kv/c77iEZr65vXjZcDSjmxUOKOJUfqEvQinduoZY6QP7nSSYfR6De8Ra6VqOsorAOsIgMqX7j/U/RSW6fSqkgc7nBoySNXH2irWDyA3hcERXkbGdRwMNQNOvmaClqwcOh/F3UNW71Bmwv7BWzfBcp5P7PnAwrgo0h72o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pyex4own; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pyex4own"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C61AC113CD;
	Fri, 26 Apr 2024 03:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103880;
	bh=Wnt0F+UssyNnpv/Tc1thDLGXkbQSdPXL0Y0R80+X7ys=;
	h=Date:To:From:Subject:From;
	b=pyex4ownK3KoTU4BJ+ZlKk9tA9Kf5Vq5UxHibhJE7J4tqh301Bt48sskP0ooYLQeT
	 HKYwUKIv6z9G+sXbhJBSUC0Xm7+r12qDTxddch0Er77UcDTUxzRdUCbKcKuIVLVI8p
	 3Bk/QgiWCXH6g/dp7LMXYEbQYEmaZlOAoTBhS8Ls=
Date: Thu, 25 Apr 2024 20:58:00 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slub-mark-slab_free_freelist_hook-__always_inline.patch removed from -mm tree
Message-Id: <20240426035800.9C61AC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slub: mark slab_free_freelist_hook() __always_inline
has been removed from the -mm tree.  Its filename was
     mm-slub-mark-slab_free_freelist_hook-__always_inline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: mm/slub: mark slab_free_freelist_hook() __always_inline
Date: Thu, 21 Mar 2024 09:36:25 -0700

It seems we need to be more forceful with the compiler on this one.  This
is done for performance reasons only.

Link: https://lkml.kernel.org/r/20240321163705.3067592-4-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: "Björn Roy Baron" <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-mark-slab_free_freelist_hook-__always_inline
+++ a/mm/slub.c
@@ -2106,9 +2106,9 @@ bool slab_free_hook(struct kmem_cache *s
 	return !kasan_slab_free(s, x, init);
 }
 
-static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail,
-					   int *cnt)
+static __fastpath_inline
+bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
+			     int *cnt)
 {
 
 	void *object;
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are


