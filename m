Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947512D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247826; cv=none; b=XRhygY469cl8R3x72/TTw4qqjp6zLTpdHC6aWBmvpbd7f3PdIkfPYqlTOWZNGbfIhPJS3FudW/oz3d2KQj+X/e6wSHseVi2VxPXayalwW11F2VXQ/zTDMGoGgapJQEY0ux3MS3Rhu7JeyizSjv30bBLNWWZdCKWq/eP27p7uJ28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247826; c=relaxed/simple;
	bh=ATigwcRZqQWGvN1ItvkNnp8aFjzuIUdqAB6ZK/yCd0s=;
	h=Date:To:From:Subject:Message-Id; b=GpyyUFWCfuvT1IDaus3n9spcPGmcCJ1fsRqDGV/rilXefDw85DO1n85xJrsVwIFrsOmAaN5SLg1z6WcilQfivakscOQkF/d4MsuEE+FAK6TZ0SFYVw/9s1F31Regq/3IwrlvHrB7911Btg+vOHt9WZHi82w9PbB974PTquDmqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vo3y646f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vo3y646f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2B7C4CEC2;
	Mon,  2 Sep 2024 03:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247826;
	bh=ATigwcRZqQWGvN1ItvkNnp8aFjzuIUdqAB6ZK/yCd0s=;
	h=Date:To:From:Subject:From;
	b=vo3y646fqgLZptFndSlCBa7NPYTnReP8IuMmhlRk5VLelC40QTVuHwyAbSX1fEmg4
	 wOa2AIt+6bXliJAe+sXFygSrILCq+AjBW3WCtbnXfClhnlXt83HTZjlrkfZDjLsfeD
	 nYjHi5yeuUxSpD92ITJlBff4X4uLhvBEtu0IuouE=
Date: Sun, 01 Sep 2024 20:30:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch removed from -mm tree
Message-Id: <20240902033026.6D2B7C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: move up mas_wr_store_setup() and mas_wr_prealloc_setup()
has been removed from the -mm tree.  Its filename was
     maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: move up mas_wr_store_setup() and mas_wr_prealloc_setup()
Date: Wed, 14 Aug 2024 12:19:30 -0400

Subsequent patches require these definitions to be higher, no functional
changes intended.

Link: https://lkml.kernel.org/r/20240814161944.55347-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   96 ++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

--- a/lib/maple_tree.c~maple_tree-move-up-mas_wr_store_setup-and-mas_wr_prealloc_setup
+++ a/lib/maple_tree.c
@@ -4227,6 +4227,54 @@ static inline void mas_wr_store_entry(st
 		mas_wr_modify(wr_mas);
 }
 
+static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
+{
+	if (!mas_is_active(wr_mas->mas)) {
+		if (mas_is_start(wr_mas->mas))
+			return;
+
+		if (unlikely(mas_is_paused(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_none(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_overflow(wr_mas->mas)))
+			goto reset;
+
+		if (unlikely(mas_is_underflow(wr_mas->mas)))
+			goto reset;
+	}
+
+	/*
+	 * A less strict version of mas_is_span_wr() where we allow spanning
+	 * writes within this node.  This is to stop partial walks in
+	 * mas_prealloc() from being reset.
+	 */
+	if (wr_mas->mas->last > wr_mas->mas->max)
+		goto reset;
+
+	if (wr_mas->entry)
+		return;
+
+	if (mte_is_leaf(wr_mas->mas->node) &&
+	    wr_mas->mas->last == wr_mas->mas->max)
+		goto reset;
+
+	return;
+
+reset:
+	mas_reset(wr_mas->mas);
+}
+
+static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_wr_store_setup(wr_mas);
+	wr_mas->content = mas_start(mas);
+}
+
 /**
  * mas_insert() - Internal call to insert a value
  * @mas: The maple state
@@ -5358,54 +5406,6 @@ static inline void mte_destroy_walk(stru
 		mt_destroy_walk(enode, mt, true);
 	}
 }
-
-static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
-{
-	if (!mas_is_active(wr_mas->mas)) {
-		if (mas_is_start(wr_mas->mas))
-			return;
-
-		if (unlikely(mas_is_paused(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_none(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_overflow(wr_mas->mas)))
-			goto reset;
-
-		if (unlikely(mas_is_underflow(wr_mas->mas)))
-			goto reset;
-	}
-
-	/*
-	 * A less strict version of mas_is_span_wr() where we allow spanning
-	 * writes within this node.  This is to stop partial walks in
-	 * mas_prealloc() from being reset.
-	 */
-	if (wr_mas->mas->last > wr_mas->mas->max)
-		goto reset;
-
-	if (wr_mas->entry)
-		return;
-
-	if (mte_is_leaf(wr_mas->mas->node) &&
-	    wr_mas->mas->last == wr_mas->mas->max)
-		goto reset;
-
-	return;
-
-reset:
-	mas_reset(wr_mas->mas);
-}
-
-static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
-{
-	struct ma_state *mas = wr_mas->mas;
-
-	mas_wr_store_setup(wr_mas);
-	wr_mas->content = mas_start(mas);
-}
 /* Interface */
 
 /**
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


