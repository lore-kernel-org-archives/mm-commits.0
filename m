Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EB278C8A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103883; cv=none; b=heF+LrvfiIxwmBuRmFOHNPz4B6frxMK/oFvB1WPOZlJetCsuk4nRkJMxad9qHsovDEbXKhg+3chuCl6GQ5PjYzaaap/0Jj5IMDBIegyelhWNGpc1jjva9lbNJvrd49mv4c7uBiAz9B4KGJ46baRI8dMo/a0V60nqHLvwUabsQ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103883; c=relaxed/simple;
	bh=70ZOzbP8pm2k2yGyw+o+llxr+3NRTlDNrD15gH2M1qc=;
	h=Date:To:From:Subject:Message-Id; b=NoDkp8KZE/b499c0u/nsYQXd9gGSSF+YvUK5FA3ktq5KGHgZdklP589yAMaNhe2Ge4I78Kvq7E4sOMIsbw6hKbSnBqgwXYC++ShG7Zzkf7hYv19HKyP5as0/4UwGxoo6Hb+YSXF/PuxPEsg9rLidswDReB5/KVmLE1jeY5eR8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tis5hIoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tis5hIoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140EEC113CD;
	Fri, 26 Apr 2024 03:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103883;
	bh=70ZOzbP8pm2k2yGyw+o+llxr+3NRTlDNrD15gH2M1qc=;
	h=Date:To:From:Subject:From;
	b=Tis5hIoH3waE/TyzyQVuijfqRgeNjpqpi+9p3fCeGCCw2hCt1xoN77KNVkiRL5diZ
	 aSDWyv8eQKUalDkCrri+URTd/fthg/2jOhLEjIYUu35gos0wDVAREjTGseiOKbVMfn
	 4o4F+nJ+9hrGv8HfDNUDY8KGLELXncsZDXLGL/CA=
Date: Thu, 25 Apr 2024 20:58:02 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,surenb@google.com,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-convert-alloc_inode_sb-to-a-macro.patch removed from -mm tree
Message-Id: <20240426035803.140EEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: convert alloc_inode_sb() to a macro
has been removed from the -mm tree.  Its filename was
     fs-convert-alloc_inode_sb-to-a-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Kees Cook <keescook@chromium.org>
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
@@ -3085,11 +3085,7 @@ int setattr_should_drop_sgid(struct mnt_
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


