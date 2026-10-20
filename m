Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533789;
	b=fkkYc2qLjnsrT8wCUcq/ouRl7f5nNnTLa3I/RcauiYQKbTOOr1mylLqnpbXCC39wt8zF
	 hiE/pfE/ySZLEnDJEXC263jwY0JnvBOhiIbL514QSA49tKnywN4khUqXr4AgUYXKCejw3
	 E5tqBjEKxkydnuvysVe3PNu/kh4hvR3dThpGI78IJDLWn03bZLcOO52OyA7msph07YDMg
	 nuvkA2FfNLn3hXEQOQADKFmtueSpfcTTuPpRZw8ZdQkzY7EeNGmK+SoHHM7zA4QncQSTm
	 Dqf2eMk7hRW6IR6oTTA+1BdWSkbtn7rcO93d3znhNDA3cXBL9NcsvU73QRng8PUuoqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533789;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UTggzp4u8DrFf+r1UE5uMJfHv41zWk6T/BfyyxI+s4w=;
	b=zr6UgNI5Qcxdexh8j2F7SGCSO7BR6tVZfmyTWqx17enyybpISndaoNwrPocX3hiCu1TF
	 jlqLWd9DkeoKk4fhGscbWK5Ph47eHIp/57U7kKrKo+ui9Mv6TGqLQUR474yFoIKo+MFPZ
	 r0bm94gc9U5IgtBolL12UOKWGLA8MsfWZKQstFzBE2MWLurfXnwv6UmYKdgy7SFb6T09R
	 aDCPm8LGw7moX/fMJoEF5eK6njv/Ggw5LeyHCqNQJDfYrPD1LIMOOfcEnvoXsMhrhaNqY
	 BD9Q+BBjmL+B3bUt74v7jqAjyL9vrqSkhGXs+ZoevRuzySdboOsLHeFkT3CbU6FQp5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jr5cOxAq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597F3606A31B
	for <mm-commits@vger.kernel.org>; Tue, 20 Oct 2026 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jr5cOxAq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCCC1F000CB;
	Tue, 20 Oct 2026 22:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792533789;
	bh=UTggzp4u8DrFf+r1UE5uMJfHv41zWk6T/BfyyxI+s4w=;
	h=Date:To:From:Subject;
	b=jr5cOxAqlmFmMsGCqXTZ3AwdAJVwKdMwCDPY9ZBa7xcwnN0XftwVEcYcb8ZkFckwd
	 1+UQbc1OzBFONVtFCUL9YI/DkMKC3iczZHM+SpZnbfzRVOoofbkFsAr9SHN6ZAdIsp
	 gn+t6cGDNcDb6b3GW4fbL7l20XtT45Pcx21JrN9I=
Date: Tue, 20 Oct 2026 15:03:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,dchar@cslab.ece.ntua.gr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-maple_range_64-crashes-in-rcu-mode.patch added to mm-unstable branch
Message-Id: <20261020220308.DDCCC1F000CB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: maple_tree: fix maple_range_64 crashes in RCU mode
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-maple_range_64-crashes-in-rcu-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-maple_range_64-crashes-in-rcu-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Subject: maple_tree: fix maple_range_64 crashes in RCU mode
Date: Mon, 05 Oct 2026 12:47:27 +0000

Patch series "maple_tree: fix maple_range_64 crashes in RCU mode", v3.

The patch series fixes two RCU destroy path issues on maple_range_64
nodes.  Both arising from the fact that a maple_range_64 node repurposes
the last slot to hold metadata when the node is not full.  Patch 1
addresses the issues, and patch 2 adds a test used to catch them.

Currently there is no in-tree user of maple_range_64 nodes in RCU mode. 
All in-tree users of MT_FLAGS_USE_RCU also set MT_FLAGS_ALLOC_RANGE which
makes the internal nodes maple_arange_64.

Below is the minimal reproducer used during debugging:

static DEFINE_MTREE(tree);
static int __init maple_fix_init(void)
{
        unsigned long i, j;

        for (i = 10; i < 4000; i++) {
                mt_init_flags(&tree, MT_FLAGS_USE_RCU);

                for (j = 0; j < i; j++) {
                        mtree_insert_range(&tree, j * 10, j * 10 + 9,
                                        xa_mk_value(j), GFP_KERNEL);
                }

                mtree_destroy(&tree);
                rcu_barrier();
        }
        return 0;
}

The splat for the first issue addressed by the first patch is shown below.
mt_clear_meta() runs after the slots have been rewritten with raw
pointers by mte_dead_leaves(), so it cannot recognize a valid last pointer
because the type information is stripped.  On my 64-bit LE machine, it
clears bytes 248 and 249 of the maple_range_64 which are the two least
significant bytes of the last pointer.  The lowest byte is already zero,
since nodes are 256-byte aligned, but zeroing byte 249 corrupts the
pointer.

KASAN catches it as a double-free, because that corrupted pointer happens
to land on a node that was freed previously.  The splat appears at 226
insertions in the reproducer.  This is when the tree has a full root node
on a 64-bit build.

  ==================================================================
  BUG: KASAN: double-free in mt_free_walk+0x138/0x3a0
  Free of addr ffff0000f3d40000 by task swapper/2/0
  [...]
  Call trace:
   [...]
   kmem_cache_free_bulk+0x5b8/0xc18
   mt_free_walk+0x138/0x3a0
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [...]

  Allocated by task 1218:
   [...]
   kmem_cache_alloc_from_sheaf_noprof+0xa8/0x2f0
   dst_setup+0x210/0x630
   mas_wr_split+0x568/0x26e0
   mas_wr_store_entry+0x98c/0x1de0
   mas_insert.isra.0+0x3d0/0x5d8
   mtree_insert_range+0xec/0x1c8
   maple_fix_init+0x94/0xff8 [maple_fix_obj]
   [...]

  Freed by task 0:
   [...]
   __kasan_slab_free+0x88/0xb8
   __rcu_free_sheaf_prepare+0x94/0x360
   rcu_free_sheaf+0x30/0x138
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [...]

  The buggy address belongs to the object at ffff0000f3d40000
   which belongs to the cache maple_node of size 256
  The buggy address is located 0 bytes inside of
   256-byte region [ffff0000f3d40000, ffff0000f3d40100)

  [...]
  Memory state around the buggy address:
   ffff0000f3d3ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff0000f3d3ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffff0000f3d40000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                     ^
   ffff0000f3d40080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff0000f3d40100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================

The second issue fixed in the first patch is in the mt_free_walk().
mt_free_walk() descends by checking if the corresponding slot[offset]
entry is non-zero. In a maple_range_64 node that has
MAPLE_RANGE64_SLOTS-1 valid pointers to child nodes, all slots will be
non-zero, since the last slot holds the metadata. Thus, mte_dead_walk()
dereferences the metadata as if it were a node and hits the
null-ptr-deref as shown in the splat below.

After fixing the first issue, the reproducer reaches this case at 3166
insertions. The affected node is the root on a tree with height 3 and it
has 15 valid child nodes on a 64-bit machine. The first fix does not
introduce this bug, but it exposes it for the root node because it no
longer clears the root metadata. On an unmodified kernel, the same bug
exists and is reachable when such a maple_range_64 node appears below
the root, where mt_clear_meta() is not called.

Second KASAN splat:

  Unable to handle kernel paging request at virtual address dfff800000000006
  KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
  [...]
  Call trace:
   mte_dead_walk+0x78/0x140 (P)
   mt_free_walk+0x1f8/0x3a0
   rcu_core+0x5d0/0x1638
   rcu_core_si+0x18/0x30
   [..]

Both splats are from an arm64 QEMU guest. The test_maple_tree and the
userspace suite pass after each patch in the series.


This patch (of 2):

This commit fixes two issues in maple_range_64 nodes under RCU mode. A
maple_range_64 node repurposes its last slot to hold metadata whenever
the node is not full. Both issues arise from mishandling that last slot.

More specifically the two fixes are:

1. Remove mt_clear_meta() function. mt_clear_meta() decides whether the
   last slot of a maple_range_64 node holds a child pointer or a
   struct maple_metadata with the check

        if (unlikely((mte_to_node(next) &&
                      mte_node_type(next))))
                return; /* no metadata, could be node */

   The check expects the pointer to be encoded.  But the only callsite
   of mt_clear_meta() is mt_destroy_walk() on the RCU destroy path, and
   by the time it runs, mte_dead_leaves() has overwritten every slot on
   a full node with a raw pointer, stripping the type information. Thus,
   the check above never returns early for a full node as it should. It
   falls through and then:
           meta->gap = 0;
           meta->end = 0;
   zeroes two bytes of a valid child pointer. Later, mt_free_walk()
   dereferences the corrupted pointer.

  Fix this by removing mt_clear_meta() along with its only callsite.
  mt_clear_meta() is only called for the root of each sub-tree destroyed
  under RCU. Descendant nodes retain their metadata until they are
  freed. RCU readers may use the metadata while traversing a node, but
  do not use cleared metadata to detect that a node has been removed.
  They detect a dead node via ma_dead_node().

2. Fix invalid memory access in mt_free_walk().  mt_free_walk() descends
   to the left-most unvisited "parent-of-a-leaf" node by checking the
   condition:

        if ((offset < mt_slots[type]) &&
            rcu_dereference_protected(slots[offset],
                                      lock_is_held(&rcu_callback_map)))
                slots = mte_dead_walk(&enode, offset);

   On a maple_range_64 node with MAPLE_RANGE64_SLOTS-1 children *all*
   slots are non-NULL. The first MAPLE_RANGE64_SLOTS-1  hold valid
   pointers to child nodes, and the last slot contains metadata. The
   above check therefore passes for all offsets, and mte_dead_walk()
   dereferences the metadata as if it were a node.

   To trigger this, a node at least two levels above the leaves has to
   have exactly MAPLE_RANGE64_SLOTS-1 valid pointers to other nodes.
   maple_arange_64 nodes cannot hit this since they store the metadata
   in a separate field.

   Fix this by bounding the descent with slot_len which holds the number
   of children of a dead node.

Link: https://lore.kernel.org/20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr
Link: https://lore.kernel.org/20261005-fix-maple-tree-range64-rcu-v3-1-ebe7fb278e20@cslab.ece.ntua.gr
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Fixes: 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
---

 lib/maple_tree.c |   43 +------------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-maple_range_64-crashes-in-rcu-mode
+++ a/lib/maple_tree.c
@@ -764,43 +764,6 @@ static inline void ma_set_meta(struct ma
 }
 
 /*
- * mt_clear_meta() - clear the metadata information of a node, if it exists
- * @mt: The maple tree
- * @mn: The maple node
- * @type: The maple node type
- */
-static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
-				  enum maple_type type)
-{
-	struct maple_metadata *meta;
-	unsigned long *pivots;
-	void __rcu **slots;
-	void *next;
-
-	switch (type) {
-	case maple_range_64:
-		pivots = mn->mr64.pivot;
-		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
-			slots = mn->mr64.slot;
-			next = mt_slot_locked(mt, slots,
-					      MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) &&
-				      mte_node_type(next))))
-				return; /* no metadata, could be node */
-		}
-		fallthrough;
-	case maple_arange_64:
-		meta = ma_meta(mn, type);
-		break;
-	default:
-		return;
-	}
-
-	meta->gap = 0;
-	meta->end = 0;
-}
-
-/*
  * ma_meta_end() - Get the data end of a node from the metadata
  * @mn: The maple node
  * @mt: The maple node type
@@ -4789,9 +4752,7 @@ static void mt_free_walk(struct rcu_head
 
 		type = mte_node_type(enode);
 		slots = ma_slots(mte_to_node(enode), type);
-		if ((offset < mt_slots[type]) &&
-		    rcu_dereference_protected(slots[offset],
-					      lock_is_held(&rcu_callback_map)))
+		if (offset < mte_to_node(enode)->slot_len)
 			slots = mte_dead_walk(&enode, offset);
 		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));
@@ -4885,8 +4846,6 @@ next:
 free_leaf:
 	if (free)
 		kfree(node);
-	else
-		mt_clear_meta(mt, node, node->type);
 }
 
 /*
_

Patches currently in -mm which might be from dchar@cslab.ece.ntua.gr are

maple_tree-fix-maple_range_64-crashes-in-rcu-mode.patch
test_maple_tree-test-maple_range_64-node-in-rcu-mode.patch

