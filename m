Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577D7082D
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282348; cv=none; b=pnMPAA9asDgCgYC+5F6Tvbw3h4f1ONRlC2BZ0+qutnmn3LxCGZCvv7l+9Nwz+ubhoTr0VbqVRhFu1rtXf2ewU0Bf0azpDGyR7mNB3Tm5vpJiKEJ9CfmcgCH4cfvRLJac/8sHK5pw0Qfen7T9Bz2sRizNOeoS+y/UmjbG73ofbC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282348; c=relaxed/simple;
	bh=OwJbY6EXb75leTCDntF+Pjktm8jVGeMiEbWfGHBcfiY=;
	h=Date:To:From:Subject:Message-Id; b=cYgdVQeQBjPgRLRkRE+RIIyM1WNXXZgM8KijVi4N/6t+C0eXC+OgRl6E8S35Jwj0FXJQ1+GC05cAVymrImk42EH/pJrA2njlQKGBaQtYk9LENq49qbR5cg764HkLDtt8Zak2hAhR4/BQyK78TN6pBWwFL/TUMwQ7F3KNObSWmPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Piyz4M5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Piyz4M5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BAAC4CEF8;
	Thu, 27 Nov 2025 22:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282348;
	bh=OwJbY6EXb75leTCDntF+Pjktm8jVGeMiEbWfGHBcfiY=;
	h=Date:To:From:Subject:From;
	b=Piyz4M5KezEgAAjjoM96c/jHvbtOzk22uUrLE0MTu0IzlMT+SVCbGrScs0uIAn92+
	 Sn8yz8AtKkjDRmEOGEM61vPFMfWkGaBLz/d3tUWz1FhiAO1rBdTelhTOlbctNx6L2K
	 oaNLHLsYtT7E91rPj+GfSdq3MEECKXzsjtkDEI4Q=
Date: Thu, 27 Nov 2025 14:25:47 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,sfr@canb.auug.org.au,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,kuba@kernel.org,aliceryhl@google.com,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rbtree-inline-rb_first.patch removed from -mm tree
Message-Id: <20251127222548.59BAAC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rbtree: inline rb_first()
has been removed from the -mm tree.  Its filename was
     rbtree-inline-rb_first.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: rbtree: inline rb_first()
Date: Fri, 14 Nov 2025 14:06:45 +0000

Patch series "rbree: inline rb_first() and rb_last()".

Inline these two small helpers, heavily used in TCP and FQ packet scheduler,
and in many other places.

This reduces kernel text size, and brings an 1.5 % improvement on network
TCP stress test.


This patch (of 2):

This is a very small function, inlining it saves cpu cycles by reducing
register pressure and removing call/ret overhead.

It also reduces vmlinux text size by 744 bytes on a typical x86_64 build.

Before:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34812525	22177365	5685248	62675138	3bc58c2	vmlinux

After:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34811781	22177365	5685248	62674394	3bc55da	vmlinux

[ojeda@kernel.org: fix rust build]
  Link: https://lkml.kernel.org/r/20251120085518.1463498-1-ojeda@kernel.org
Link: https://lkml.kernel.org/r/20251114140646.3817319-1-edumazet@google.com
Link: https://lkml.kernel.org/r/20251114140646.3817319-2-edumazet@google.com
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
 lib/rbtree.c           |   16 ----------------
 rust/helpers/rbtree.c  |    5 +++++
 3 files changed, 20 insertions(+), 17 deletions(-)

--- a/include/linux/rbtree.h~rbtree-inline-rb_first
+++ a/include/linux/rbtree.h
@@ -43,7 +43,21 @@ extern void rb_erase(struct rb_node *, s
 /* Find logical next and previous nodes in a tree */
 extern struct rb_node *rb_next(const struct rb_node *);
 extern struct rb_node *rb_prev(const struct rb_node *);
-extern struct rb_node *rb_first(const struct rb_root *);
+
+/*
+ * This function returns the first node (in sort order) of the tree.
+ */
+static inline struct rb_node *rb_first(const struct rb_root *root)
+{
+	struct rb_node	*n;
+
+	n = root->rb_node;
+	if (!n)
+		return NULL;
+	while (n->rb_left)
+		n = n->rb_left;
+	return n;
+}
 extern struct rb_node *rb_last(const struct rb_root *);
 
 /* Postorder iteration - always visit the parent after its children */
--- a/lib/rbtree.c~rbtree-inline-rb_first
+++ a/lib/rbtree.c
@@ -460,22 +460,6 @@ void __rb_insert_augmented(struct rb_nod
 }
 EXPORT_SYMBOL(__rb_insert_augmented);
 
-/*
- * This function returns the first node (in sort order) of the tree.
- */
-struct rb_node *rb_first(const struct rb_root *root)
-{
-	struct rb_node	*n;
-
-	n = root->rb_node;
-	if (!n)
-		return NULL;
-	while (n->rb_left)
-		n = n->rb_left;
-	return n;
-}
-EXPORT_SYMBOL(rb_first);
-
 struct rb_node *rb_last(const struct rb_root *root)
 {
 	struct rb_node	*n;
--- a/rust/helpers/rbtree.c~rbtree-inline-rb_first
+++ a/rust/helpers/rbtree.c
@@ -7,3 +7,8 @@ void rust_helper_rb_link_node(struct rb_
 {
 	rb_link_node(node, parent, rb_link);
 }
+
+struct rb_node *rust_helper_rb_first(const struct rb_root *root)
+{
+	return rb_first(root);
+}
_

Patches currently in -mm which might be from edumazet@google.com are


