Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853D92F90D5
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 22:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763158763; cv=none; b=L4W3I2GCRJ8tV5yu+VZSumGc7E5Y6T/hSAMg3POHgQqZs/opqSHS2kQb5d03C5e6zfCkIjQUtX2Ur/shOa9VpM2vBMsFFFEeWG8c/NdnTd6U7Eqx4XnGu2YFVUFTxO2SC2l03oBfHOqHAD4AefC153ohQ3+tnmuzcoa8DbSbkZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763158763; c=relaxed/simple;
	bh=Gr6TzYwhzgS3xRNUOPaiuER8XZeNcuOaYrcaElamJho=;
	h=Date:To:From:Subject:Message-Id; b=VIvJ3RhVPpydJXoug8Gi4P4rAU+IL3I0jv695PcXvksyQlQNqR9HbTHgTmNzfg84ElbcFmvmzYVHW4GxZlpVLYgcbNSNLrZgQh52IBGGDLKC3G2D74j0ZMDCFMH+s8Zwe74ZmwNWmVqv+ENrhTyqBc+gpzGigDqGBoPd2yF3Xtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNE/I5Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNE/I5Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B92C4CEF1;
	Fri, 14 Nov 2025 22:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763158762;
	bh=Gr6TzYwhzgS3xRNUOPaiuER8XZeNcuOaYrcaElamJho=;
	h=Date:To:From:Subject:From;
	b=jNE/I5XhBIE9vdivbQ9Tw63vbEv3zOrumvikokfxmhXmfZZypTN7pGZJvw3CVvgLU
	 fHPPfu1ghXW638gRgbvBxyrT96pRrTOES6BzGeHWG+uF+jA5IQspixtSYHCmSSOLqp
	 nkz4IY4Yb00Ah5bsLQVOHUEzZmTrwSo3exypEHXc=
Date: Fri, 14 Nov 2025 14:19:21 -0800
To: mm-commits@vger.kernel.org,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-inline-rb_last.patch added to mm-nonmm-unstable branch
Message-Id: <20251114221921.F3B92C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rbtree: inline rb_last()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-inline-rb_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-inline-rb_last.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Eric Dumazet <edumazet@google.com>
Subject: rbtree: inline rb_last()
Date: Fri, 14 Nov 2025 14:06:46 +0000

This is a very small function, inlining it save cpu cycles in TCP
by reducing register pressure and removing call/ret overhead.

It also reduces vmlinux text size by 122 bytes on a typical x86_64 build.

Before:

size vmlinux
   text    data     bss     dec     hex filename
34811781        22177365        5685248 62674394        3bc55da vmlinux

After:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34811659	22177365	5685248	62674272	3bc5560	vmlinux

Link: https://lkml.kernel.org/r/20251114140646.3817319-3-edumazet@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   16 +++++++++++++++-
 lib/rbtree.c           |   13 -------------
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/rbtree.h~rbtree-inline-rb_last
+++ a/include/linux/rbtree.h
@@ -58,7 +58,21 @@ static inline struct rb_node *rb_first(c
 		n = n->rb_left;
 	return n;
 }
-extern struct rb_node *rb_last(const struct rb_root *);
+
+/*
+ * This function returns the last node (in sort order) of the tree.
+ */
+static inline struct rb_node *rb_last(const struct rb_root *root)
+{
+	struct rb_node	*n;
+
+	n = root->rb_node;
+	if (!n)
+		return NULL;
+	while (n->rb_right)
+		n = n->rb_right;
+	return n;
+}
 
 /* Postorder iteration - always visit the parent after its children */
 extern struct rb_node *rb_first_postorder(const struct rb_root *);
--- a/lib/rbtree.c~rbtree-inline-rb_last
+++ a/lib/rbtree.c
@@ -460,19 +460,6 @@ void __rb_insert_augmented(struct rb_nod
 }
 EXPORT_SYMBOL(__rb_insert_augmented);
 
-struct rb_node *rb_last(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_right)
-		n = n->rb_right;
-	return n;
-}
-EXPORT_SYMBOL(rb_last);
-
 struct rb_node *rb_next(const struct rb_node *node)
 {
 	struct rb_node *parent;
_

Patches currently in -mm which might be from edumazet@google.com are

rbtree-inline-rb_first.patch
rbtree-inline-rb_last.patch

