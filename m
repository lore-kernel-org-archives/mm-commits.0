Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5991134CD0
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053773; cv=none; b=S5Z8Qn0uCe38oKFCX+9obmjNBLQ/lY8J+JEL1celEHOY5jVb7vm9X0PbbFzmawzSjkRDn39oCReSOevkFvQB0cLVcY8j4HTJIehFoAYLzoChX2+2fN6LKh/WcjQl4rdK8ZlTvn/O72Zkr8QdMEIWzY3DOUb16sq3W6AZ/MBzO3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053773; c=relaxed/simple;
	bh=wuYCPbkhoU2L808vGlowl4Y1XoAewclm5llQiTuw4HA=;
	h=Date:To:From:Subject:Message-Id; b=J4TGMTeGYZC1ZsIIl4TK1+lREdmd0pmEwIXIFaoBOjcQrk1u6ZVe+GMlrg5JYZD6PByNviHWfnTiAIZ7r5Q6lYLOr2vdrGdKGe/hIE1F0nuLABvRz/hIoDASMwK1zMIH+Trj1OXinBOSyoVCK5hG/z51NWp5AuSKhmwWeecI3nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kGhmjKcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kGhmjKcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A579C433F1;
	Thu, 21 Mar 2024 20:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053773;
	bh=wuYCPbkhoU2L808vGlowl4Y1XoAewclm5llQiTuw4HA=;
	h=Date:To:From:Subject:From;
	b=kGhmjKcPQnl0bBREkQTmu34Y3f7AMdP7IGIA/gE+45TuUNPOpXf3vykwBOC3CwwFD
	 ZEAR6LSRPLM8dJqPGzkvgdRiCeyFwjPM84WkLBPgvRQZnBDuZy6HhwuhfNsk+z7TFA
	 hUCabC7thGJp/03wvFa+vS4yWJyNfwR/lv8FjAlA=
Date: Thu, 21 Mar 2024 13:42:52 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-slub-mark-slab_free_freelist_hook-__always_inline.patch added to mm-unstable branch
Message-Id: <20240321204253.5A579C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/slub: mark slab_free_freelist_hook() __always_inline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slub-mark-slab_free_freelist_hook-__always_inline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slub-mark-slab_free_freelist_hook-__always_inline.patch

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

fix-missing-vmalloch-includes.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

