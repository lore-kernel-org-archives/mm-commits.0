Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C078C84
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103885; cv=none; b=X1pBtTKI6HqUzusPlSvV/+DsB0Kt7dDOTAxSf93zlq+qQdIa0VDMOEY3TO8BuT4s0wbSQB7RTuEfMO5Ye19nV6YQ6xK+8n6+jA/wf8TmGCIi0uFneZdCkYX0jbGCLdegc+e7lkVld79kHveT0iWTnwX7DiDJiaFPUe0iTjw45lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103885; c=relaxed/simple;
	bh=2Cw+1OFybB7VJ5PSUApLf2P+VGBCccUZLU03kwxNl5k=;
	h=Date:To:From:Subject:Message-Id; b=Nre57uHtpqjbgD+kvh1n0Q48bjVSvRLhLF/AIUZScvvKxAMnIx+5Fi+ZPYCh/sw6Uc5Dr5ta3uE3mCAFPn0NGMUScFm9o8fHGvwhBoZjlfZT42SPIyCRwW7p+X3bJwHamMH2jH1TgGVEpe0FHAbfgkEwc5zcRyD0JFSttAPc32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BqLCd9D/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BqLCd9D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82835C113CD;
	Fri, 26 Apr 2024 03:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103885;
	bh=2Cw+1OFybB7VJ5PSUApLf2P+VGBCccUZLU03kwxNl5k=;
	h=Date:To:From:Subject:From;
	b=BqLCd9D/YhGsaIC++w0OE/yDd6mgmu33lwsi2f3+KAvHFCYsqg6xEQkD3lA27hJIj
	 it5WTxlHKr+PvEREF3LCJ7SW3sj3/VtVnfPlsAkMF2V2DBM8MRuM468RsaL6UyFb1o
	 HdWF/lQGsvy1rkwhsI4LycQIjRsVqpRTBnM7Kxvw=
Date: Thu, 25 Apr 2024 20:58:05 -0700
To: mm-commits@vger.kernel.org,wedsonaf@gmail.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,peterz@infradead.org,pasha.tatashin@soleen.com,ojeda@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,gary@garyguo.net,dennis@kernel.org,cl@linux.com,boqun.feng@gmail.com,bjorn3_gh@protonmail.com,benno.lossin@proton.me,aliceryhl@google.com,alex.gaynor@gmail.com,a.hindborg@samsung.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch removed from -mm tree
Message-Id: <20240426035805.82835C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce __GFP_NO_OBJ_EXT flag to selectively prevent slabobj_ext creation
has been removed from the -mm tree.  Its filename was
     mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce __GFP_NO_OBJ_EXT flag to selectively prevent slabobj_ext creation
Date: Thu, 21 Mar 2024 09:36:29 -0700

Introduce __GFP_NO_OBJ_EXT flag in order to prevent recursive allocations
when allocating slabobj_ext on a slab.

Link: https://lkml.kernel.org/r/20240321163705.3067592-8-surenb@google.com
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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |   11 +++++++++++
 mm/slub.c                 |    2 ++
 2 files changed, 13 insertions(+)

--- a/include/linux/gfp_types.h~mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation
+++ a/include/linux/gfp_types.h
@@ -55,6 +55,9 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
+#ifdef CONFIG_SLAB_OBJ_EXT
+	___GFP_NO_OBJ_EXT_BIT,
+#endif
 	___GFP_LAST_BIT
 };
 
@@ -95,6 +98,11 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
+#ifdef CONFIG_SLAB_OBJ_EXT
+#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
+#else
+#define ___GFP_NO_OBJ_EXT       0
+#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -135,12 +143,15 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
+ *
+ * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
+#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers
--- a/mm/slub.c~mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation
+++ a/mm/slub.c
@@ -1889,6 +1889,8 @@ static int alloc_slab_obj_exts(struct sl
 	void *vec;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
+	/* Prevent recursive extension vector allocation */
+	gfp |= __GFP_NO_OBJ_EXT;
 	vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 			   slab_nid(slab));
 	if (!vec)
_

Patches currently in -mm which might be from surenb@google.com are

userfaultfd-remove-write_once-when-setting-folio-index-during-uffdio_move.patch

