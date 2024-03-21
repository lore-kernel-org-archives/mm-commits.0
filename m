Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817E4133416
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053777; cv=none; b=QqJJNic2b/9lIGYVrctBBGYIbesY6epPWsEq2byvKXfkRuId6o/cw771puDunzo7EwE4bMMhWPLOFsYNtkmY2NPde8UGHY6R+GXUZMuHR7I7WUkdG1m+mWm5vm2gCLDFTSdqBtZiBe7CEYooNVSyFjNDTzQDfg5spqjgU54kGGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053777; c=relaxed/simple;
	bh=ZWAAH9m/dHcjfYzYEYnD9xLA2x1+ZFIm2I3wsVtPnlk=;
	h=Date:To:From:Subject:Message-Id; b=NuO9VUWHA7L2eTWvHZqGWFStzE41lA1Urdh6XIn0pam3qQFR3Qh/O1OahZ7bwqW3nF8eF2FZJe3agFoUa5Pc/tksoykw0q/xWftNl+jowYP9kxGofxi3KEDZXKDd7+aaIxaTw/txdPZOfFH23C1HyvrIKfuzso6N3BV+SzqDSos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKTY5EZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKTY5EZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558ADC433F1;
	Thu, 21 Mar 2024 20:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711053777;
	bh=ZWAAH9m/dHcjfYzYEYnD9xLA2x1+ZFIm2I3wsVtPnlk=;
	h=Date:To:From:Subject:From;
	b=TKTY5EZq/oLSOe44s5buWBO9rsjHL7ERqfnSbMLQ1c0xr4A/lpYQL1eGwsd9yu4XD
	 fv7/zYy8YJL4nJFkIPCnwGYGxJkTUU7T9YlTkE1qdPfH01UpxQk5RtF4RDp8kgqGm4
	 0S6gKqa+qyq71914ycm/7xmLF6MmVrP4OmiYchGY=
Date: Thu, 21 Mar 2024 13:42:56 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-alloc_inode_sb-to-a-macro.patch added to mm-unstable branch
Message-Id: <20240321204257.558ADC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: convert alloc_inode_sb() to a macro
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-alloc_inode_sb-to-a-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-alloc_inode_sb-to-a-macro.patch

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
Subject: fs: convert alloc_inode_sb() to a macro
Date: Thu, 21 Mar 2024 09:36:27 -0700

We're introducing alloc tagging, which tracks memory allocations by
callsite.  Converting alloc_inode_sb() to a macro means allocations will
be tracked by its caller, which is a bit more useful.

Link: https://lkml.kernel.org/r/20240321163705.3067592-6-surenb@google.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/fs.h~fs-convert-alloc_inode_sb-to-a-macro
+++ a/include/linux/fs.h
@@ -3083,11 +3083,7 @@ int setattr_should_drop_sgid(struct mnt_
  * This must be used for allocating filesystems specific inodes to set
  * up the inode reclaim context correctly.
  */
-static inline void *
-alloc_inode_sb(struct super_block *sb, struct kmem_cache *cache, gfp_t gfp)
-{
-	return kmem_cache_alloc_lru(cache, &sb->s_inode_lru, gfp);
-}
+#define alloc_inode_sb(_sb, _cache, _gfp) kmem_cache_alloc_lru(_cache, &_sb->s_inode_lru, _gfp)
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
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

