Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935218;
	b=MdqxzcKvI4BB69iEBFVAU9P73PnwCqKQbUh3IgWrtnkYNgrXcLlvBNcAFxYsrY4EgBHL
	 v4RDvfU3DT2wUFkmr6MPyesLNCnZ1T6do3dxJ9cO05nrY+odCGOuQCP8TWKqrEvzJh7ao
	 3EQK2vE7sHgHQSOq1UJlLW/xtsgiJRQwTIQ1/Q3ETuSpnWkpgXAHPYgeGzMK9uU0BuRcN
	 K0qoKDJ3yK3nTbCjUtgIczL/qTvKskBYRkdreuFfw0OJOlNTOBX7ny3pPXyuCFuqU+W81
	 p6u5VL/axoKWApz02Os2iqNKiI5YQu3z97JYl+BBapT2stUMM4ctqde7mKIqsWqlEnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935218;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DlaXrThR4o3RdT/wz7mRU4NlO1m404KohI1IZ0hM5JY=;
	b=5qikzSK/xgLgyzUmBK37usSgabVAm1kIzm5yq04QfpTmroq7tO4T7dlo7AE+p0Hk0DY6
	 hnYvx+vhfBDAxvNxHmqEXjB6MZx5+ftAPpwW9nP3GVX0JkNrYrYQTSWYz0C2f6eXh56cl
	 aAj3G8q5KxUu2I6dC8SAOHqe7BrZQ70fc6qWSTc5dKIGEwcFFJGq0pX/7tol9IqK1TX0C
	 LBpFXYKZGCi0xMPKQBO2X61DAEp5I7iCnBEC8Kg1ySmZAk9fdAWpsR4gWsfAKE06gy/s7
	 MHv+0zpv4k4MTK8GSFjE7y/ZvD3r5UfRkenFIdbF3yLYrWBueG6LKx+RRXg564Y7Hww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BYT957Yw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C9606A339;
	Tue, 17 Nov 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BYT957Yw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA651F000CB;
	Tue, 17 Nov 2026 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794935218;
	bh=DlaXrThR4o3RdT/wz7mRU4NlO1m404KohI1IZ0hM5JY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BYT957YwSe2GUJdGyg1UBRkJd7uCjAB8zvkJ27J8wrhGLmofWhbZvlOcPhrrKGNOs
	 Iopn769yrx8ujpgy7cz4aghmXpqkMiCinSMLEY3G7zrtQ6/UtGeo6WlNFlOUNybmUb
	 FQtD37KmlPjo9TfMHvU1PE+4EI9mcEjBtpVW8CUQ=
Date: Tue, 17 Nov 2026 09:06:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 mm-commits@vger.kernel.org, stable@vger.kernel.org, dhowells@redhat.com,
 4ncienth@gmail.com
Subject: Re: [merged mm-hotfixes-stable]
 assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch removed
 from -mm tree
Message-Id: <20261117090657.4a69ab63152011076171883e@linux-foundation.org>
In-Reply-To: <avxh82yWCs_bQq_w@kernel.org>
References: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
	<86f9796a-2d2f-4e5a-875c-d2714bd76c58@kernel.org>
	<avxh82yWCs_bQq_w@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Nov 2026 16:17:23 +0200 Jarkko Sakkinen <jarkko@kernel.org> wrote:

> > >  	}
> > 
> > This causes conflicts with upstream. I suspect with Linus' cleanups part of
> > 
> > commit 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4 (origin/master, origin/HEAD,
> > master, base)
> > Merge: 141b164bbe18 bbab563c5131
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Mon Nov 16 09:35:38 2026 -0800
> > 
> >     Merge tag 'assoc-array-fixes-v2'
> > 
> >     Clean up assoc_array library code
> > 
> > It's in akpm/mm-hotfixes-unstable, but is this really MM material?
> > 
> > Sounds more like nonmm stuff.

Crap, I keep putting nonmm stuff into mm-hotfixes.  Muscle memory :(

> > Anyhow, I'll drop this from now from mm-next as I couldn't easily figure out how
> > to resolve this (or if it is still required).
> 
> I think you're right, thanks.
> 
> I temporarily removed the commits from my next mirror branch.
> 
> I'll go through this with time and re-push them later.

Thanks.  I've removed Daehyeon's patch from mm.git.

Here's the latest version:


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

