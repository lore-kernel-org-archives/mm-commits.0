Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431332D77E2;
	Mon, 10 Nov 2025 05:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752033; cv=none; b=bEHSyNxMMbGVf9KGOG4Orcp5IxwAsBg57EqeU7RlafO2Zhpg92Hk3wAalryqHY27e89hkBOfP3cvuhYi/9TJlR2FOeTVv3nExJ7aemL+1xQwikH6yBL8IYGtC4fOR9Qdr0RTLgZ05kJyH6JXKcXXZ0/uZsEG2vcxs3Xrplgl7FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752033; c=relaxed/simple;
	bh=DBEfTkQm+hy3fCYMvSaqQ9zss0ath99Vs2sp7EkV8j4=;
	h=Date:To:From:Subject:Message-Id; b=M5B83XHRn59rHjow1NB5p9sNpw/LfO/cX3JZpGZcc7N8HuMwIISeATApSeGa42qPggpAXdi5OyQGe8kKP4QMxT+OeVNkZvykqKUG4gi/g7fJ4UwyA3La4m4guEHmPt6bWf4DWTUH2MceiBVPuhyCXMru9WpC6AXVRjSgD/yH6Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHeIPF2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHeIPF2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178BFC116B1;
	Mon, 10 Nov 2025 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752033;
	bh=DBEfTkQm+hy3fCYMvSaqQ9zss0ath99Vs2sp7EkV8j4=;
	h=Date:To:From:Subject:From;
	b=GHeIPF2V7Wrur6DSCyIOY5zM/tZtivfWMiz5ne/KE3Q1qBcGpIV+Kh4PZPFcfoRuW
	 l6Av/S9UcTmhKT49eOCz9fEPHdOA1MIoTPAbn0gB8KxBKjAr/fMacS3l2O1EoEdjCh
	 UosrU52TpqYMWeDS5KIvwVMRR6q37GXNlAwe2x+M=
Date: Sun, 09 Nov 2025 21:20:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-tracepoint-string-pointers.patch removed from -mm tree
Message-Id: <20251110052033.178BFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix tracepoint string pointers
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-tracepoint-string-pointers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kaiser <martin@kaiser.cx>
Subject: maple_tree: fix tracepoint string pointers
Date: Thu, 30 Oct 2025 16:55:05 +0100

maple_tree tracepoints contain pointers to function names. Such a pointer
is saved when a tracepoint logs an event. There's no guarantee that it's
still valid when the event is parsed later and the pointer is dereferenced.

The kernel warns about these unsafe pointers.

	event 'ma_read' has unsafe pointer field 'fn'
	WARNING: kernel/trace/trace.c:3779 at ignore_event+0x1da/0x1e4

Mark the function names as tracepoint_string() to fix the events.

One case that doesn't work without my patch would be trace-cmd record
to save the binary ringbuffer and trace-cmd report to parse it in
userspace.  The address of __func__ can't be dereferenced from
userspace but tracepoint_string will add an entry to
/sys/kernel/tracing/printk_formats

Link: https://lkml.kernel.org/r/20251030155537.87972-1-martin@kaiser.cx
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-tracepoint-string-pointers
+++ a/lib/maple_tree.c
@@ -64,6 +64,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/maple_tree.h>
 
+#define TP_FCT tracepoint_string(__func__)
+
 /*
  * Kernel pointer hashing renders much of the maple tree dump useless as tagged
  * pointers get hashed to arbitrary values.
@@ -2756,7 +2758,7 @@ static inline void mas_rebalance(struct
 	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	/*
 	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
@@ -2997,7 +2999,7 @@ static void mas_split(struct ma_state *m
 	MA_STATE(prev_l_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
 
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	mast.l = &l_mas;
 	mast.r = &r_mas;
@@ -3172,7 +3174,7 @@ static bool mas_is_span_wr(struct ma_wr_
 			return false;
 	}
 
-	trace_ma_write(__func__, wr_mas->mas, wr_mas->r_max, entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, wr_mas->r_max, entry);
 	return true;
 }
 
@@ -3416,7 +3418,7 @@ static noinline void mas_wr_spanning_sto
 	 * of data may happen.
 	 */
 	mas = wr_mas->mas;
-	trace_ma_op(__func__, mas);
+	trace_ma_op(TP_FCT, mas);
 
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return mas_new_root(mas, wr_mas->entry);
@@ -3552,7 +3554,7 @@ done:
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
 	return;
@@ -3596,7 +3598,7 @@ static inline void mas_wr_slot_store(str
 		mas->offset++; /* Keep mas accurate. */
 	}
 
-	trace_ma_write(__func__, mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	/*
 	 * Only update gap when the new entry is empty or there is an empty
 	 * entry in the original two ranges.
@@ -3717,7 +3719,7 @@ static inline void mas_wr_append(struct
 		mas_update_gap(mas);
 
 	mas->end = new_end;
-	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
+	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 	return;
 }
 
@@ -3731,7 +3733,7 @@ static void mas_wr_bnode(struct ma_wr_st
 {
 	struct maple_big_node b_node;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
 	mas_commit_b_node(wr_mas, &b_node);
@@ -5062,7 +5064,7 @@ void *mas_store(struct ma_state *mas, vo
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
 		pr_err("Error %lX > %lX " PTR_FMT "\n", mas->index, mas->last,
@@ -5163,7 +5165,7 @@ void mas_store_prealloc(struct ma_state
 	}
 
 store:
-	trace_ma_write(__func__, mas, 0, entry);
+	trace_ma_write(TP_FCT, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
 	mas_destroy(mas);
@@ -5882,7 +5884,7 @@ void *mtree_load(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	void *entry;
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 	rcu_read_lock();
 retry:
 	entry = mas_start(&mas);
@@ -5925,7 +5927,7 @@ int mtree_store_range(struct maple_tree
 	MA_STATE(mas, mt, index, last);
 	int ret = 0;
 
-	trace_ma_write(__func__, &mas, 0, entry);
+	trace_ma_write(TP_FCT, &mas, 0, entry);
 	if (WARN_ON_ONCE(xa_is_advanced(entry)))
 		return -EINVAL;
 
@@ -6148,7 +6150,7 @@ void *mtree_erase(struct maple_tree *mt,
 	void *entry = NULL;
 
 	MA_STATE(mas, mt, index, index);
-	trace_ma_op(__func__, &mas);
+	trace_ma_op(TP_FCT, &mas);
 
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
@@ -6485,7 +6487,7 @@ void *mt_find(struct maple_tree *mt, uns
 	unsigned long copy = *index;
 #endif
 
-	trace_ma_read(__func__, &mas);
+	trace_ma_read(TP_FCT, &mas);
 
 	if ((*index) > max)
 		return NULL;
_

Patches currently in -mm which might be from martin@kaiser.cx are


