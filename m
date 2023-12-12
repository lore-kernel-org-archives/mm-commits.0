Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D660B7F55D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DYr5q4qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FCFC433C7;
	Tue, 12 Dec 2023 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407542;
	bh=vny/bq1xNVPvymkSJJepMYRe8aw4hSbVZWntoYrJkKA=;
	h=Date:To:From:Subject:From;
	b=DYr5q4qcJhSltSteXZ8wPX+Vo0MBDN0lpOX9LiEyU1Qbt8nqffMFUBmpxWCci+Ca1
	 SCgjZoMWKqHpyacV/enMh9lfk3aHRfJEV6YN1oHkR1YpRHSUFgJP+WfaVfb3lZIvrd
	 UvD157SjR+dzMDPb/5WizTjJEtrSrMiNxupByM1w=
Date: Tue, 12 Dec 2023 10:59:01 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-end-of-node-tracking-to-the-maple-state.patch removed from -mm tree
Message-Id: <20231212185902.57FCFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add end of node tracking to the maple state
has been removed from the -mm tree.  Its filename was
     maple_tree-add-end-of-node-tracking-to-the-maple-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add end of node tracking to the maple state
Date: Wed, 1 Nov 2023 13:16:21 -0400

Analysis of the mas_for_each() iteration showed that there is a
significant time spent finding the end of a node.  This time can be
greatly reduced if the end of the node is cached in the maple state.  Care
must be taken to update & invalidate as necessary.

Link: https://lkml.kernel.org/r/20231101171629.3612299-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h       |    1 +
 lib/maple_tree.c                 |    7 +++++++
 tools/testing/radix-tree/maple.c |    1 +
 3 files changed, 9 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/include/linux/maple_tree.h
@@ -393,6 +393,7 @@ struct ma_state {
 	unsigned char depth;		/* depth of tree descent during write */
 	unsigned char offset;
 	unsigned char mas_flags;
+	unsigned char end;		/* The end of the node */
 };
 
 struct ma_wr_state {
--- a/lib/maple_tree.c~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/lib/maple_tree.c
@@ -2841,6 +2841,7 @@ next:
 			goto dead_node;
 	} while (!ma_is_leaf(type));
 
+	mas->end = end;
 	mas->offset = offset;
 	mas->index = min;
 	mas->last = max;
@@ -3507,6 +3508,7 @@ static noinline_for_kasan int mas_commit
 	mas_replace_node(wr_mas->mas, old_enode);
 reuse_node:
 	mas_update_gap(wr_mas->mas);
+	wr_mas->mas->end = b_end;
 	return 1;
 }
 
@@ -4010,6 +4012,7 @@ done:
 	}
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
+	mas->end = new_end;
 	return true;
 }
 
@@ -4190,6 +4193,7 @@ static inline bool mas_wr_append(struct
 	if (!wr_mas->content || !wr_mas->entry)
 		mas_update_gap(mas);
 
+	mas->end = new_end;
 	trace_ma_write(__func__, mas, new_end, wr_mas->entry);
 	return  true;
 }
@@ -4428,6 +4432,7 @@ static inline int mas_prev_node(struct m
 	if (unlikely(mte_dead_node(mas->node)))
 		return 1;
 
+	mas->end = mas->offset;
 	return 0;
 
 no_entry:
@@ -5074,6 +5079,7 @@ int mas_empty_area(struct ma_state *mas,
 	if (mas->index < min)
 		mas->index = min;
 	mas->last = mas->index + size - 1;
+	mas->end = mas_data_end(mas);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_empty_area);
@@ -5134,6 +5140,7 @@ int mas_empty_area_rev(struct ma_state *
 		mas->last = max;
 
 	mas->index = mas->last - size + 1;
+	mas->end = mas_data_end(mas);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_empty_area_rev);
--- a/tools/testing/radix-tree/maple.c~maple_tree-add-end-of-node-tracking-to-the-maple-state
+++ a/tools/testing/radix-tree/maple.c
@@ -945,6 +945,7 @@ retry:
 		goto retry;
 	}
 
+	mas->end = mas_data_end(mas);
 	return ret;
 
 not_found:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


