Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8162417C2
	for <mm-commits@vger.kernel.org>; Fri, 14 Nov 2025 22:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763158760; cv=none; b=aRdAYjt3FcQLQlLQi9wMV8xEuz0HVS5mQLwFDuK4qtDaRSh+e7du0yahKCDCVzGYyW+y5OWIJPr+DHcLxrP3Zcr8W3hVZ+sQwsCLZgete65Qp6ubnuRRggl1mL3JQLegRzdCVXYkp8ILdlH5KFBD12f4thwPcGuf6dEkbV2bwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763158760; c=relaxed/simple;
	bh=zpFcl0A/3l5E3tjm1nU3QzdTt+QDdTFyOhh2lrwvDJA=;
	h=Date:To:From:Subject:Message-Id; b=pcPuzohyGQqtLes1vE/5X10v/wzV6sNqaVD0gCJc8Ljt5oVWF4A5Mk6+1Yxzoduztu1r5/IMMPh7cvR9bW4uH/7sxXi08ZFYkV04f3ka7WgOOl05vTTbu9UvjOL2ortm6ZXv6wUZzq6dLij4a8ptCXLpL5a7mQwkvnnLPLhWucU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukx1R9Tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukx1R9Tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B7C19421;
	Fri, 14 Nov 2025 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763158759;
	bh=zpFcl0A/3l5E3tjm1nU3QzdTt+QDdTFyOhh2lrwvDJA=;
	h=Date:To:From:Subject:From;
	b=ukx1R9TgbiDd/8g/JOLeAB1IJFNjtcslFfOpgu1t8hx55pw/NlhsKByQ8JI4xwqI6
	 mRp+m6KKN6rFnWclRQ3fgGYuPcoyT3QLu+f8QLP32mVrBmjtVlTmE0SZIoPtihJmjF
	 lWMCc8NuTKMKzFjX3gio2vKurJAOCHxGbO275rXI=
Date: Fri, 14 Nov 2025 14:19:18 -0800
To: mm-commits@vger.kernel.org,pabeni@redhat.com,ncardwell@google.com,kuba@kernel.org,edumazet@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rbtree-inline-rb_first.patch added to mm-nonmm-unstable branch
Message-Id: <20251114221919.792B7C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rbtree: inline rb_first()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rbtree-inline-rb_first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rbtree-inline-rb_first.patch

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
Subject: rbtree: inline rb_first()
Date: Fri, 14 Nov 2025 14:06:45 +0000

Patch series "rbree: inline rb_first() and rb_last()".

Inline these two small helpers, heavily used in TCP and FQ packet scheduler,
and in many other places.

This reduces kernel text size, and brings an 1.5 % improvement on network
TCP stress test.


This patch (of 2):

This is a very small function, inlining it save cpu cycles
by reducing register pressure and removing call/ret overhead.

It also reduces vmlinux text size by 744 bytes on a typical x86_64 build.

Before:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34812525	22177365	5685248	62675138	3bc58c2	vmlinux

After:

size vmlinux
   text	   data	    bss	    dec	    hex	filename
34811781	22177365	5685248	62674394	3bc55da	vmlinux

Link: https://lkml.kernel.org/r/20251114140646.3817319-1-edumazet@google.com
Link: https://lkml.kernel.org/r/20251114140646.3817319-2-edumazet@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |   16 +++++++++++++++-
 lib/rbtree.c           |   16 ----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

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
_

Patches currently in -mm which might be from edumazet@google.com are

rbtree-inline-rb_first.patch
rbtree-inline-rb_last.patch

