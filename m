Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56E7082D
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282351; cv=none; b=X/We28qAWluf9ePsB4kX1ZeLasHbTfQSXmPSWbgA8USrO8D+TcLEyQjdiEC8ZyMS6+vTeM0MTgXO96EQUxPIfF69zZaGTqAuoKD2KXzHapZqI6N+epw+2cBywfc0lkMbs4B+dKejoVBUv6BubxKrRXYYXWw79MLKjkps/Ti4P0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282351; c=relaxed/simple;
	bh=GUXbic6Sxz0ze/+lAcFuurttq0gKcHo0McUWQqv7jbU=;
	h=Date:To:From:Subject:Message-Id; b=TVjL1PnqFWMgEMh5Zp3VwEFUXWpZfmsfyeleuy0CEUvLUz22xD9NexLyymKZPsKkKqa2UXCQ/BcjK4x2gZN5uH0vv+2v9k0zrJkk5HQdFm3WJEOi1AMk4RPBwEXWX365atatgv1rgztdQk6PWZBNnaYhUfv/xHDItOM3J1/QnT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZ2zI+gJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZ2zI+gJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFCCC4CEF8;
	Thu, 27 Nov 2025 22:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282349;
	bh=GUXbic6Sxz0ze/+lAcFuurttq0gKcHo0McUWQqv7jbU=;
	h=Date:To:From:Subject:From;
	b=QZ2zI+gJTIlT5rqkBlcoipUb9uZNpMA1gbZSZaSg1tP/S7855a56NuP5mPTXP/A2o
	 a0kDfepWDj7eY/+2FpSvozL7bS2Gj5gtRkNuQqJYeM1zlnCnuYOZQ9cO3pIXajvnai
	 x//EIpnVT+rYZ7L42cs/VSnNlEQ3bWO7j2w4nK50=
Date: Thu, 27 Nov 2025 14:25:49 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,kuba@kernel.org,aliceryhl@google.com,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rbtree-inline-rb_last.patch removed from -mm tree
Message-Id: <20251127222549.9EFCCC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rbtree: inline rb_last()
has been removed from the -mm tree.  Its filename was
     rbtree-inline-rb_last.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: rbtree: inline rb_last()
Date: Fri, 14 Nov 2025 14:06:46 +0000

This is a very small function, inlining it saves cpu cycles in TCP by
reducing register pressure and removing call/ret overhead.

It also reduces vmlinux text size by 122 bytes on a typical x86_64 build.

Before:

size vmlinux
   text    data     bss     dec     hex filename
34811781        22177365        5685248 62674394        3bc55da vmlinux

After:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34811659	22177365	5685248	62674272	3bc5560	vmlinux

[ojeda@kernel.org: fix rust build]
  Link: https://lkml.kernel.org/r/20251120085518.1463498-1-ojeda@kernel.org
Link: https://lkml.kernel.org/r/20251114140646.3817319-3-edumazet@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   16 +++++++++++++++-
 lib/rbtree.c           |   13 -------------
 rust/helpers/rbtree.c  |    5 +++++
 3 files changed, 20 insertions(+), 14 deletions(-)

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
--- a/rust/helpers/rbtree.c~rbtree-inline-rb_last
+++ a/rust/helpers/rbtree.c
@@ -12,3 +12,8 @@ struct rb_node *rust_helper_rb_first(con
 {
 	return rb_first(root);
 }
+
+struct rb_node *rust_helper_rb_last(const struct rb_root *root)
+{
+	return rb_last(root);
+}
_

Patches currently in -mm which might be from edumazet@google.com are


