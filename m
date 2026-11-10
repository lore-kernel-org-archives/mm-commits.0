Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293151;
	b=g8gUfKe4VADQMSH+dziv+QJQPXfVoftKj3vFoZb804jobzNerEH3Pl+2QcE2/PSWkTXH
	 hlQ7aISYZeSQCmUC1TKE4O7RQcPrn8d1zZl083kyfkip/qzN2Cz3uaG4f0H2zULoioJyT
	 Laq0DCjWMxOgiXWL9bNO/73HKPyI6feSLvH/fSb355smpwl7Ted2p4bZOxewHIfymDYYg
	 sr0nsd7W8GADzdzZcGEmylW1V6lnMDE7gKaIqKnL4RySXFlq8+uiOCFybzcKSwJd0wy43
	 xg5gmWHtPXPVjkgDih0RCkkFJRCbyv5DWeL2hGmUj1ZpA/W06txRyXhDjGxcDi+Zfzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293151;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=E6jPraanYRH6KymZKaaGm8aI2CRRm7B6mbiacqnWKxY=;
	b=H5ZTdc0ojAuB4S2AGjq6VCXtvnin4y3Al/vEQ2Mw3a6pOyEWgosJk4klIuNpaIPKLRyH
	 BDi2tXCV3u/je/fYwgvwRCZBcGmAmzXOrI4ZSijvCO+FxtU1h3T+ddQRCHMzPlWnKKxbs
	 DF8gTFv0EjgsSut45o3AftO+yZQ0Au5Wp4RrIvSkjvaRfCp4EgoIESwvAx4LPrsY6T9hz
	 OiNP2tsYkTk8xzAGab4mOxmeco9YxxYPJJFazepPFd7znYDNH+zzt7vU8PQ4vutqsPkt3
	 PaJHRWdGhovjnCpij2g36p2ozzRyeMiusEOF/YSjDms7SZnKx7ecaD14tWjA5TG4ctA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wtCvdhzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B03606A649;
	Tue, 10 Nov 2026 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wtCvdhzk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA5D1F008A1;
	Tue, 10 Nov 2026 06:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293151;
	bh=E6jPraanYRH6KymZKaaGm8aI2CRRm7B6mbiacqnWKxY=;
	h=Date:To:From:Subject;
	b=wtCvdhzkQ5Z4inIGYbJFSSpR5cKm/f7gT87ORWpfFLyGKqi9U+FsyD+EfI6HSxaze
	 x0nckCo30kPYFSDU3mXyxduux2YiFNI7MI5oFwhRSMFg0YGsUS5arOyoBerLHnhMUn
	 qRVl3oMxutYkzFxmG9QfgLWis0qQFsp+MvY+30Z8=
Date: Mon, 09 Nov 2026 22:45:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jarkko@kernel.org,
	dhowells@redhat.com,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch removed from -mm tree
Message-Id: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: assoc_array: discard shortcut when collapsing a leaf-only node
has been removed from the -mm tree.  Its filename was
     assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daehyeon Ko <4ncienth@gmail.com>
Subject: assoc_array: discard shortcut when collapsing a leaf-only node
Date: Fri, 25 Sep 2026 17:05:48 +0900

assoc_array_delete() can collapse a subtree into a node that contains only
leaves while retaining the shortcut that led to it.  If that node later
fills, all_leaves_cluster_together replaces it with another shortcut.  The
first shortcut then points directly to the second one.

assoc_array_apply_edit() publishes this topology and propagates branch
counts from the new child node.  It skips the inner shortcut, encounters
the outer shortcut where it requires a node and triggers the BUG_ON().

Linux v7.2 and v6.12.105 are affected.  The same root remains at the
base-commit below and in every supported stable branch checked down to
5.10.  It requires CONFIG_KEYS, but no capability, user namespace or race.
A UID/GID 1000 process produced:

  CONTROL_BEGIN mode=exact uid=1000 gid=1000
  CONTROL_CapEff: 0000000000000000
  kernel BUG at lib/assoc_array.c:1388!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 0 UID: 1000 PID: 154 Comm: exploit
  RIP: assoc_array_apply_edit+0x4aa/0x690
  Call Trace:
   __key_link
   __key_instantiate_and_link
   __key_create_or_update
   __do_sys_add_key
  Kernel panic - not syncing: Fatal exception

When deletion produces a leaf-only node, bypass its preceding shortcut as
garbage collection already does.  Retire the shortcut and old node
together after an RCU grace period; reused leaves keep their references
and the deleted leaf is still freed separately.

The exact trigger reached the BUG in 3/3 unmodified v7.2 KASAN boots and
completed cleanly in 3/3 fixed boots.  Fixed v6.12.105 also passed 3/3.  A
source reproducer is available privately on request.

Link: https://lore.kernel.org/20260925080548.2505640-1-4ncienth@gmail.com
Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
---

 lib/assoc_array.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/lib/assoc_array.c~assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node
+++ a/lib/assoc_array.c
@@ -1210,8 +1210,22 @@ found_leaf:
 				goto enomem;
 			edit->new_meta[0] = assoc_array_node_to_ptr(new_n0);
 
-			new_n0->back_pointer = node->back_pointer;
-			new_n0->parent_slot = node->parent_slot;
+			/* A shortcut above a leaf-only node is redundant.  Drop it as
+			 * GC does so that a later split can't create two shortcuts in a row.
+			 */
+			ptr = node->back_pointer;
+			if (assoc_array_ptr_is_shortcut(ptr)) {
+				struct assoc_array_shortcut *s =
+					assoc_array_ptr_to_shortcut(ptr);
+
+				new_n0->back_pointer = s->back_pointer;
+				new_n0->parent_slot = s->parent_slot;
+				edit->excised_subtree = ptr;
+			} else {
+				new_n0->back_pointer = ptr;
+				new_n0->parent_slot = node->parent_slot;
+				edit->excised_subtree = assoc_array_node_to_ptr(node);
+			}
 			new_n0->nr_leaves_on_branch = node->nr_leaves_on_branch;
 			edit->adjust_count_on = new_n0;
 
@@ -1225,21 +1239,15 @@ found_leaf:
 			pr_devel("collapsed %d,%lu\n", collapse.slot, new_n0->nr_leaves_on_branch);
 			BUG_ON(collapse.slot != new_n0->nr_leaves_on_branch - 1);
 
-			if (!node->back_pointer) {
+			if (!new_n0->back_pointer) {
 				edit->set[1].ptr = &array->root;
-			} else if (assoc_array_ptr_is_leaf(node->back_pointer)) {
-				BUG();
-			} else if (assoc_array_ptr_is_node(node->back_pointer)) {
-				struct assoc_array_node *p =
-					assoc_array_ptr_to_node(node->back_pointer);
-				edit->set[1].ptr = &p->slots[node->parent_slot];
-			} else if (assoc_array_ptr_is_shortcut(node->back_pointer)) {
-				struct assoc_array_shortcut *s =
-					assoc_array_ptr_to_shortcut(node->back_pointer);
-				edit->set[1].ptr = &s->next_node;
+			} else {
+				struct assoc_array_node *p;
+
+				p = assoc_array_ptr_to_node(new_n0->back_pointer);
+				edit->set[1].ptr = &p->slots[new_n0->parent_slot];
 			}
 			edit->set[1].to = assoc_array_node_to_ptr(new_n0);
-			edit->excised_subtree = assoc_array_node_to_ptr(node);
 		}
 	}
 
_

Patches currently in -mm which might be from 4ncienth@gmail.com are

iov_iter-validate-extracted-segment-for-bvec-alignment.patch
mm-hugetlb_cgroup-prevent-use-after-free-during-cgroup-offlining.patch

