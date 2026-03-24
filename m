Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD17317160
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388514; cv=none; b=h+fER8yG9R365kdPNf90gvtKCbSW4ibpYVAgNb6T15QTuc1/rnnYLiI59H/om0Z8DshM5LMwoMrlSgyp3MmGbVrM70YbmWmb+X1SHPWGcbn+VM3X7G4nL71FcyWrfkjQoA5jaOIK238etkNGB9EYj7JfH0+FYvcYmCPxQzIAd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388514; c=relaxed/simple;
	bh=hQPcgnGRnA5+k0d3Uahnq+/apFIuqJyeamKaTIhL0HQ=;
	h=Date:To:From:Subject:Message-Id; b=pH4tfYnog4Pr90t3Jx6aeBujy8l6AlNqO8TlPbsnVvn7sHneWhbYvw4qCoH0bWbv3hhMpXEYn+MX9LyNu70RuwCevIm6lD2bUrXAqhnC+k02lRQ8wqIuLw0Uny0e6KP3f5XrhucfIQF+cgtH7VRp5hCzfrjrocVp+pEFXjpcYzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDX5DrcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDX5DrcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31FC19424;
	Tue, 24 Mar 2026 21:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388514;
	bh=hQPcgnGRnA5+k0d3Uahnq+/apFIuqJyeamKaTIhL0HQ=;
	h=Date:To:From:Subject:From;
	b=fDX5DrcId7J+5ygeU7w5dzbUw+rhXOS0yxatuVcHyqxbfFuox1qfyZBmrUR7MgPNC
	 kCxxnlrQ+dyPFU8rguQktMDYh7JxV6w09SByQsBREwAQMhUVJZGbVFUOV5tq+q6+H6
	 MVlW6ibfE5C77p/vDRp5icW/JnQpEbS7GdL8/c30=
Date: Tue, 24 Mar 2026 14:41:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unnecessary-return-statements.patch removed from -mm tree
Message-Id: <20260324214154.3A31FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove unnecessary return statements
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unnecessary-return-statements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: remove unnecessary return statements
Date: Fri, 30 Jan 2026 15:59:24 -0500

Functions do not need to state return at the end, unless skipping unwind. 
These can safely be dropped.

Link: https://lkml.kernel.org/r/20260130205935.2559335-20-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unnecessary-return-statements
+++ a/lib/maple_tree.c
@@ -3294,7 +3294,6 @@ new_root:
 	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3718,7 +3717,6 @@ static void mas_split(struct ma_state *m
 	mas->node = l_mas.node;
 	mas_wmb_replace(mas, old, height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3779,7 +3777,6 @@ static inline void mas_root_expand(struc
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return;
 }
 
 /*
@@ -4051,8 +4048,6 @@ static inline void mas_new_root(struct m
 done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
-
-	return;
 }
 /*
  * mas_wr_spanning_store() - Create a subtree with the store operation completed
@@ -4215,7 +4210,6 @@ done:
 	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
-	return;
 }
 
 /*
@@ -4263,8 +4257,6 @@ static inline void mas_wr_slot_store(str
 	 */
 	if (!wr_mas->entry || gap)
 		mas_update_gap(mas);
-
-	return;
 }
 
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
@@ -4378,7 +4370,6 @@ static inline void mas_wr_append(struct
 
 	mas->end = new_end;
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
-	return;
 }
 
 /*
@@ -4437,8 +4428,6 @@ static inline void mas_wr_store_entry(st
 	case wr_invalid:
 		MT_BUG_ON(mas->tree, 1);
 	}
-
-	return;
 }
 
 static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


