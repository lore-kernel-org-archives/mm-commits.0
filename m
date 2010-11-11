From: akpm@linux-foundation.org
Subject: + radix-tree-fix-rcu-bug.patch added to -mm tree
Date: Wed, 10 Nov 2010 16:08:32 -0800
Message-ID: <201011110008.oAB08WLK014090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab0KKAJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Nov 2010 19:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@kernel.dk, sqazi@google.com, stable@kernel.org


The patch titled
     radix-tree: fix RCU bug
has been added to the -mm tree.  Its filename is
     radix-tree-fix-rcu-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: radix-tree: fix RCU bug
=46rom: Nick Piggin <npiggin@kernel.dk>

Salman Qazi describes the following radix-tree bug:

In the following case, we get can get a deadlock:

0. =A0The radix tree contains two items, one has the index 0.
1. =A0The reader (in this case find_get_pages) takes the rcu_read_lock.
2. =A0The reader acquires slot(s) for item(s) including the index 0 ite=
m.
3. =A0The non-zero index item is deleted, and as a consequence the othe=
r item is
    moved to the root of the tree. The place where it used to be is que=
ued for
    deletion after the readers finish.
3b. The zero item is deleted, removing it from the direct slot, it rema=
ins in
    the rcu-delayed indirect node.
4. =A0The reader looks at the index 0 slot, and finds that the page has=
 0 ref
    count
5. =A0The reader looks at it again, hoping that the item will either be=
 freed or
    the ref count will increase. This never happens, as the slot it is =
looking
    at will never be updated. Also, this slot can never be reclaimed be=
cause
    the reader is holding rcu_read_lock and is in an infinite loop.

The fix is to re-use the same "indirect" pointer case that requires a s=
lot
lookup retry into a general "retry the lookup" bit.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
Reported-by: Salman Qazi <sqazi@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   39 +++++++++-------
 lib/radix-tree.c           |   83 ++++++++++++++++++++++++-----------
 mm/filemap.c               |   26 ++++------
 3 files changed, 91 insertions(+), 57 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-rcu-bug include/lin=
ux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-rcu-bug
+++ a/include/linux/radix-tree.h
@@ -34,19 +34,13 @@
  * needed for RCU lookups (because root->height is unreliable). The on=
ly
  * time callers need worry about this is when doing a lookup_slot unde=
r
  * RCU.
+ *
+ * Indirect pointer in fact is also used to tag the last pointer of a =
node
+ * when it is shrunk, before we rcu free the node. See shrink code for
+ * details.
  */
 #define RADIX_TREE_INDIRECT_PTR	1
-#define RADIX_TREE_RETRY ((void *)-1UL)
-
-static inline void *radix_tree_ptr_to_indirect(void *ptr)
-{
-	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
-}
=20
-static inline void *radix_tree_indirect_to_ptr(void *ptr)
-{
-	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
-}
 #define radix_tree_indirect_to_ptr(ptr) \
 	radix_tree_indirect_to_ptr((void __force *)(ptr))
=20
@@ -140,16 +134,29 @@ do {									\
  *		removed.
  *
  * For use with radix_tree_lookup_slot().  Caller must hold tree at le=
ast read
- * locked across slot lookup and dereference.  More likely, will be us=
ed with
- * radix_tree_replace_slot(), as well, so caller will hold tree write =
locked.
+ * locked across slot lookup and dereference. Not required if write lo=
ck is
+ * held (ie. items cannot be concurrently inserted).
+ *
+ * radix_tree_deref_retry must be used to confirm validity of the poin=
ter if
+ * only the read lock is held.
  */
 static inline void *radix_tree_deref_slot(void **pslot)
 {
-	void *ret =3D rcu_dereference(*pslot);
-	if (unlikely(radix_tree_is_indirect_ptr(ret)))
-		ret =3D RADIX_TREE_RETRY;
-	return ret;
+	return rcu_dereference(*pslot);
 }
+
+/**
+ * radix_tree_deref_retry	- check radix_tree_deref_slot
+ * @arg:	pointer returned by radix_tree_deref_slot
+ * Returns:	0 if retry is not required, otherwise retry is required
+ *
+ * radix_tree_deref_retry must be used with radix_tree_deref_slot.
+ */
+static inline int radix_tree_deref_retry(void *arg)
+{
+	return unlikely((unsigned long)arg & RADIX_TREE_INDIRECT_PTR);
+}
+
 /**
  * radix_tree_replace_slot	- replace item in a slot
  * @pslot:	pointer to slot, returned by radix_tree_lookup_slot
diff -puN lib/radix-tree.c~radix-tree-fix-rcu-bug lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-rcu-bug
+++ a/lib/radix-tree.c
@@ -82,6 +82,16 @@ struct radix_tree_preload {
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) =
=3D { 0, };
=20
+static inline void *ptr_to_indirect(void *ptr)
+{
+	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
+}
+
+static inline void *indirect_to_ptr(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
+}
+
 static inline gfp_t root_gfp_mask(struct radix_tree_root *root)
 {
 	return root->gfp_mask & __GFP_BITS_MASK;
@@ -265,7 +275,7 @@ static int radix_tree_extend(struct radi
 			return -ENOMEM;
=20
 		/* Increase the height.  */
-		node->slots[0] =3D radix_tree_indirect_to_ptr(root->rnode);
+		node->slots[0] =3D indirect_to_ptr(root->rnode);
=20
 		/* Propagate the aggregated tag info into the new root */
 		for (tag =3D 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
@@ -276,7 +286,7 @@ static int radix_tree_extend(struct radi
 		newheight =3D root->height+1;
 		node->height =3D newheight;
 		node->count =3D 1;
-		node =3D radix_tree_ptr_to_indirect(node);
+		node =3D ptr_to_indirect(node);
 		rcu_assign_pointer(root->rnode, node);
 		root->height =3D newheight;
 	} while (height > root->height);
@@ -309,7 +319,7 @@ int radix_tree_insert(struct radix_tree_
 			return error;
 	}
=20
-	slot =3D radix_tree_indirect_to_ptr(root->rnode);
+	slot =3D indirect_to_ptr(root->rnode);
=20
 	height =3D root->height;
 	shift =3D (height-1) * RADIX_TREE_MAP_SHIFT;
@@ -325,8 +335,7 @@ int radix_tree_insert(struct radix_tree_
 				rcu_assign_pointer(node->slots[offset], slot);
 				node->count++;
 			} else
-				rcu_assign_pointer(root->rnode,
-					radix_tree_ptr_to_indirect(slot));
+				rcu_assign_pointer(root->rnode, ptr_to_indirect(slot));
 		}
=20
 		/* Go a level down */
@@ -374,7 +383,7 @@ static void *radix_tree_lookup_element(s
 			return NULL;
 		return is_slot ? (void *)&root->rnode : node;
 	}
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	height =3D node->height;
 	if (index > radix_tree_maxindex(height))
@@ -393,7 +402,7 @@ static void *radix_tree_lookup_element(s
 		height--;
 	} while (height > 0);
=20
-	return is_slot ? (void *)slot:node;
+	return is_slot ? (void *)slot : indirect_to_ptr(node);
 }
=20
 /**
@@ -455,7 +464,7 @@ void *radix_tree_tag_set(struct radix_tr
 	height =3D root->height;
 	BUG_ON(index > radix_tree_maxindex(height));
=20
-	slot =3D radix_tree_indirect_to_ptr(root->rnode);
+	slot =3D indirect_to_ptr(root->rnode);
 	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
=20
 	while (height > 0) {
@@ -509,7 +518,7 @@ void *radix_tree_tag_clear(struct radix_
=20
 	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node =3D NULL;
-	slot =3D radix_tree_indirect_to_ptr(root->rnode);
+	slot =3D indirect_to_ptr(root->rnode);
=20
 	while (height > 0) {
 		int offset;
@@ -579,7 +588,7 @@ int radix_tree_tag_get(struct radix_tree
=20
 	if (!radix_tree_is_indirect_ptr(node))
 		return (index =3D=3D 0);
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	height =3D node->height;
 	if (index > radix_tree_maxindex(height))
@@ -666,7 +675,7 @@ unsigned long radix_tree_range_tag_if_ta
 	}
=20
 	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
-	slot =3D radix_tree_indirect_to_ptr(root->rnode);
+	slot =3D indirect_to_ptr(root->rnode);
=20
 	/*
 	 * we fill the path from (root->height - 2) to 0, leaving the index a=
t
@@ -897,7 +906,7 @@ radix_tree_gang_lookup(struct radix_tree
 		results[0] =3D node;
 		return 1;
 	}
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	max_index =3D radix_tree_maxindex(node->height);
=20
@@ -916,7 +925,8 @@ radix_tree_gang_lookup(struct radix_tree
 			slot =3D *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] =3D rcu_dereference_raw(slot);
+			results[ret + nr_found] =3D
+				indirect_to_ptr(rcu_dereference_raw(slot));
 			nr_found++;
 		}
 		ret +=3D nr_found;
@@ -965,7 +975,7 @@ radix_tree_gang_lookup_slot(struct radix
 		results[0] =3D (void **)&root->rnode;
 		return 1;
 	}
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	max_index =3D radix_tree_maxindex(node->height);
=20
@@ -1090,7 +1100,7 @@ radix_tree_gang_lookup_tag(struct radix_
 		results[0] =3D node;
 		return 1;
 	}
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	max_index =3D radix_tree_maxindex(node->height);
=20
@@ -1109,7 +1119,8 @@ radix_tree_gang_lookup_tag(struct radix_
 			slot =3D *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] =3D rcu_dereference_raw(slot);
+			results[ret + nr_found] =3D
+				indirect_to_ptr(rcu_dereference_raw(slot));
 			nr_found++;
 		}
 		ret +=3D nr_found;
@@ -1159,7 +1170,7 @@ radix_tree_gang_lookup_tag_slot(struct r
 		results[0] =3D (void **)&root->rnode;
 		return 1;
 	}
-	node =3D radix_tree_indirect_to_ptr(node);
+	node =3D indirect_to_ptr(node);
=20
 	max_index =3D radix_tree_maxindex(node->height);
=20
@@ -1195,7 +1206,7 @@ static inline void radix_tree_shrink(str
 		void *newptr;
=20
 		BUG_ON(!radix_tree_is_indirect_ptr(to_free));
-		to_free =3D radix_tree_indirect_to_ptr(to_free);
+		to_free =3D indirect_to_ptr(to_free);
=20
 		/*
 		 * The candidate node has more than one child, or its child
@@ -1208,16 +1219,39 @@ static inline void radix_tree_shrink(str
=20
 		/*
 		 * We don't need rcu_assign_pointer(), since we are simply
-		 * moving the node from one part of the tree to another. If
-		 * it was safe to dereference the old pointer to it
+		 * moving the node from one part of the tree to another: if it
+		 * was safe to dereference the old pointer to it
 		 * (to_free->slots[0]), it will be safe to dereference the new
-		 * one (root->rnode).
+		 * one (root->rnode) as far as dependent read barriers go.
 		 */
 		newptr =3D to_free->slots[0];
 		if (root->height > 1)
-			newptr =3D radix_tree_ptr_to_indirect(newptr);
+			newptr =3D ptr_to_indirect(newptr);
 		root->rnode =3D newptr;
 		root->height--;
+
+		/*
+		 * We have a dilemma here. The node's slot[0] must not be
+		 * NULLed in case there are concurrent lookups expecting to
+		 * find the item. However if this was a bottom-level node,
+		 * then it may be subject to the slot pointer being visible
+		 * to callers dereferencing it. If item corresponding to
+		 * slot[0] is subsequently deleted, these callers would expect
+		 * their slot to become empty sooner or later.
+		 *
+		 * For example, lockless pagecache will look up a slot, deref
+		 * the page pointer, and if the page is 0 refcount it means it
+		 * was concurrently deleted from pagecache so try the deref
+		 * again. Fortunately there is already a requirement for logic
+		 * to retry the entire slot lookup -- the indirect pointer
+		 * problem (replacing direct root node with an indirect pointer
+		 * also results in a stale slot). So tag the slot as indirect
+		 * to force callers to retry.
+		 */
+		if (root->height =3D=3D 0)
+			*((unsigned long *)&to_free->slots[0]) |=3D
+						RADIX_TREE_INDIRECT_PTR;
+
 		radix_tree_node_free(to_free);
 	}
 }
@@ -1254,7 +1288,7 @@ void *radix_tree_delete(struct radix_tre
 		root->rnode =3D NULL;
 		goto out;
 	}
-	slot =3D radix_tree_indirect_to_ptr(slot);
+	slot =3D indirect_to_ptr(slot);
=20
 	shift =3D (height - 1) * RADIX_TREE_MAP_SHIFT;
 	pathp->node =3D NULL;
@@ -1296,8 +1330,7 @@ void *radix_tree_delete(struct radix_tre
 			radix_tree_node_free(to_free);
=20
 		if (pathp->node->count) {
-			if (pathp->node =3D=3D
-					radix_tree_indirect_to_ptr(root->rnode))
+			if (pathp->node =3D=3D indirect_to_ptr(root->rnode))
 				radix_tree_shrink(root);
 			goto out;
 		}
diff -puN mm/filemap.c~radix-tree-fix-rcu-bug mm/filemap.c
--- a/mm/filemap.c~radix-tree-fix-rcu-bug
+++ a/mm/filemap.c
@@ -655,7 +655,9 @@ repeat:
 	pagep =3D radix_tree_lookup_slot(&mapping->page_tree, offset);
 	if (pagep) {
 		page =3D radix_tree_deref_slot(pagep);
-		if (unlikely(!page || page =3D=3D RADIX_TREE_RETRY))
+		if (unlikely(!page))
+			goto out;
+		if (radix_tree_deref_retry(page))
 			goto repeat;
=20
 		if (!page_cache_get_speculative(page))
@@ -671,6 +673,7 @@ repeat:
 			goto repeat;
 		}
 	}
+out:
 	rcu_read_unlock();
=20
 	return page;
@@ -788,12 +791,11 @@ repeat:
 		page =3D radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found =3D=3D 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page =3D=3D RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page)) {
+			if (ret)
+				start =3D pages[ret-1]->index;
 			goto restart;
+		}
=20
 		if (!page_cache_get_speculative(page))
 			goto repeat;
@@ -841,11 +843,7 @@ repeat:
 		page =3D radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found =3D=3D 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page =3D=3D RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page))
 			goto restart;
=20
 		if (page->mapping =3D=3D NULL || page->index !=3D index)
@@ -898,11 +896,7 @@ repeat:
 		page =3D radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
-		/*
-		 * this can only trigger if nr_found =3D=3D 1, making livelock
-		 * a non issue.
-		 */
-		if (unlikely(page =3D=3D RADIX_TREE_RETRY))
+		if (radix_tree_deref_retry(page))
 			goto restart;
=20
 		if (!page_cache_get_speculative(page))
_

Patches currently in -mm which might be from npiggin@kernel.dk are

atomic-add-atomic_inc_not_zero_hint.patch
linux-next.patch
radix-tree-fix-rcu-bug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
