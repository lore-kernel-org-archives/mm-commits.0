Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC9A3A874C;
	Wed, 30 Sep 2026 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790806273; cv=none; b=bqbdlazrQevh+9nXgoWcNzJbOX0qRx/Ff9X4xVaf7BaOIQ7oRi2wAC73tR99mRhrFkEBZO68AIhYTSo3r7o2I18sFjtMYoCMFgpd7H0ODDwSEv+greGsg7t56pGAPRTQBNpoT4o83szpzOjZD6hilR54TKcHrPnUbrJhkfsg+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790806273; c=relaxed/simple;
	bh=aw/ik4YFXZlKmWS5MVdAPt0tfd7AREzMzoi/Ayk+qrg=;
	h=Date:To:From:Subject:Message-Id; b=ZdAV1q+BEmUuM5yQIySJOuR/oFEVi1qpgsCsTmWc1oMGWiLK0KvBkKDCAOT5HdL3L2EIj2XwQ9yuS9SuHv0r2YuwuF8q6+GvELkXdQkJ0Bblov6PUPuikgzbEJKQ33WvMbeo8sKDV7bzqWAGkuWO7s4H2zmDMsaDTHBZh1kbV7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jdWmQVgh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jdWmQVgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AECB1F000FF;
	Wed, 30 Sep 2026 22:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790806271;
	bh=PvVNdBZrhLvbSzQ99WPPHWzLYyK2uS5akF0EqyEjuKs=;
	h=Date:To:From:Subject;
	b=jdWmQVghAKWW8fSJM2xjcuP62+vhl8Nk1NIZqnjihXX6GD8zRAQg0O7KLULO0S+f0
	 OjIsLZxHIVRLpk/9wqqYh8TglkfgYz2aeKKM80EdQ8XKL19pKvW4dRBsyMgVtxu3TS
	 1ak+3B+apSeviqYi1hfF1N0Foz739thQPLEiAY64=
Date: Wed, 30 Sep 2026 15:11:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jarkko@kernel.org,dhowells@redhat.com,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch added to mm-hotfixes-unstable branch
Message-Id: <20260930221111.7AECB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: assoc_array: discard shortcut when collapsing a leaf-only node
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Assisted-by: LLM
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

assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch
ipc-mqueue-release-notification-resources-during-inode-eviction.patch

