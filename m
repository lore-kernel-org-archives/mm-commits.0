Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794925047;
	b=za72ccUskkNG8oBdMuwlDf6Gqk5fHGRsdripAR42eMtHloaDEl3VNEZW6C0nFzoU4lOa
	 c0OFmTX695dAX2dKTdlPcfKEyR8dOdbbaJc6oFb8Aag1iI0EgY11pqPiymHHjSNPpqxn6
	 UinXEx4MlTgd+zLkdLPg9eTknKgVNM5hpjZ+hT4Zrjj7aiPGrM86E3/Cbuwvu7kc5xsBc
	 D2kzgX1TBAUaLy25v/t7XMppWxtNHK1MFoglrJ+FZoPYyoazKB7mDG5L470l9PzKDOpmE
	 gUvLRK7zPHp3xS4ShrMT8PvUOJwPZh2CuSuFVlj8hgc4DnBEDw/ZjcbfkUQOtAPtUlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794925047;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=liIZOjRuYPEbplj4vLWB8JdNqmnfvrixSMO+8M41odI=;
	b=h+h5ksQeqSWb79S4SNcnjYUx2DH5bkdujZxDRTTGNa2KmOPJ8HKr0/l4EupdJgHaUHAH
	 TRsdlSwIzk/0pdVR/ymwwDWmjuU1nVPS3euQ1dCMkfkgPLwi8ndIJQuKzNXzRt31flhGq
	 LJGalVAB+fZetoyeG9jMluG07NIeulbIHnWP9q1ALM2LurthjvnGfYrTTd5CqvZ+EFEH9
	 AHh1V4SCNCVP4e+5J/6OCfaSNhlqsdEIFHqDb9pu70eGLVd+aC2rXC+HCeOvQu4TSYPo/
	 XB94m3BwWrJ6A0Zd7sXOfBHecGGhc68l3xnpoL6dgDTWILXz7fxtajLZJr88yFi+IbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMyTfUiH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D4684606A329;
	Tue, 17 Nov 2026 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMyTfUiH
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2CDE11F000C5;
	Tue, 17 Nov 2026 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794925047;
	bh=liIZOjRuYPEbplj4vLWB8JdNqmnfvrixSMO+8M41odI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LMyTfUiHO2RCiWpysRkGi3YHyZ5J0cL8l1BasNNy7jvqJ7qYAB/s4pKS4QXHXT0rn
	 MqwJtvZdF9bmnqLcVmenrDel6dYJ7WAB/IDJ5bWX14bVKA9+J3qhEHyqs+6SMZ0CB0
	 EfPeikOm/UJ5oDq5Cj8eMejV3F7eymlU9gQKXh2NM6GkhnA0BCNEUT2DXOv8Pj7BBt
	 0mmxpkzGDUunpXs0IibCMIJ44RvV5thgHL+FP+OWXRZKWL/C7HQ0jJ8RXiDS1hSLW9
	 WrD9caCOivDNaXELcrLeeml9xLYt/FjoPek+Df/SkuoIu6cEl1NAa1rh9kcsAGt2U+
	 ZXtdoQzObbGZQ==
Date: Tue, 17 Nov 2026 16:17:23 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	stable@vger.kernel.org, dhowells@redhat.com, 4ncienth@gmail.com
Subject: Re: [merged mm-hotfixes-stable]
 assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch removed
 from -mm tree
Message-ID: <avxh82yWCs_bQq_w@kernel.org>
References: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
 <86f9796a-2d2f-4e5a-875c-d2714bd76c58@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f9796a-2d2f-4e5a-875c-d2714bd76c58@kernel.org>

On Tue, Nov 17, 2026 at 02:22:22PM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 07:45, Andrew Morton wrote:
> > The quilt patch titled
> >      Subject: assoc_array: discard shortcut when collapsing a leaf-only node
> > has been removed from the -mm tree.  Its filename was
> >      assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch
> > 
> > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > ------------------------------------------------------
> > From: Daehyeon Ko <4ncienth@gmail.com>
> > Subject: assoc_array: discard shortcut when collapsing a leaf-only node
> > Date: Fri, 25 Sep 2026 17:05:48 +0900
> > 
> > assoc_array_delete() can collapse a subtree into a node that contains only
> > leaves while retaining the shortcut that led to it.  If that node later
> > fills, all_leaves_cluster_together replaces it with another shortcut.  The
> > first shortcut then points directly to the second one.
> > 
> > assoc_array_apply_edit() publishes this topology and propagates branch
> > counts from the new child node.  It skips the inner shortcut, encounters
> > the outer shortcut where it requires a node and triggers the BUG_ON().
> > 
> > Linux v7.2 and v6.12.105 are affected.  The same root remains at the
> > base-commit below and in every supported stable branch checked down to
> > 5.10.  It requires CONFIG_KEYS, but no capability, user namespace or race.
> > A UID/GID 1000 process produced:
> > 
> >   CONTROL_BEGIN mode=exact uid=1000 gid=1000
> >   CONTROL_CapEff: 0000000000000000
> >   kernel BUG at lib/assoc_array.c:1388!
> >   Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> >   CPU: 0 UID: 1000 PID: 154 Comm: exploit
> >   RIP: assoc_array_apply_edit+0x4aa/0x690
> >   Call Trace:
> >    __key_link
> >    __key_instantiate_and_link
> >    __key_create_or_update
> >    __do_sys_add_key
> >   Kernel panic - not syncing: Fatal exception
> > 
> > When deletion produces a leaf-only node, bypass its preceding shortcut as
> > garbage collection already does.  Retire the shortcut and old node
> > together after an RCU grace period; reused leaves keep their references
> > and the deleted leaf is still freed separately.
> > 
> > The exact trigger reached the BUG in 3/3 unmodified v7.2 KASAN boots and
> > completed cleanly in 3/3 fixed boots.  Fixed v6.12.105 also passed 3/3.  A
> > source reproducer is available privately on request.
> > 
> > Link: https://lore.kernel.org/20260925080548.2505640-1-4ncienth@gmail.com
> > Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
> > Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> > 
> >  lib/assoc_array.c |   36 ++++++++++++++++++++++--------------
> >  1 file changed, 22 insertions(+), 14 deletions(-)
> > 
> > --- a/lib/assoc_array.c~assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node
> > +++ a/lib/assoc_array.c
> > @@ -1210,8 +1210,22 @@ found_leaf:
> >  				goto enomem;
> >  			edit->new_meta[0] = assoc_array_node_to_ptr(new_n0);
> >  
> > -			new_n0->back_pointer = node->back_pointer;
> > -			new_n0->parent_slot = node->parent_slot;
> > +			/* A shortcut above a leaf-only node is redundant.  Drop it as
> > +			 * GC does so that a later split can't create two shortcuts in a row.
> > +			 */
> > +			ptr = node->back_pointer;
> > +			if (assoc_array_ptr_is_shortcut(ptr)) {
> > +				struct assoc_array_shortcut *s =
> > +					assoc_array_ptr_to_shortcut(ptr);
> > +
> > +				new_n0->back_pointer = s->back_pointer;
> > +				new_n0->parent_slot = s->parent_slot;
> > +				edit->excised_subtree = ptr;
> > +			} else {
> > +				new_n0->back_pointer = ptr;
> > +				new_n0->parent_slot = node->parent_slot;
> > +				edit->excised_subtree = assoc_array_node_to_ptr(node);
> > +			}
> >  			new_n0->nr_leaves_on_branch = node->nr_leaves_on_branch;
> >  			edit->adjust_count_on = new_n0;
> >  
> > @@ -1225,21 +1239,15 @@ found_leaf:
> >  			pr_devel("collapsed %d,%lu\n", collapse.slot, new_n0->nr_leaves_on_branch);
> >  			BUG_ON(collapse.slot != new_n0->nr_leaves_on_branch - 1);
> >  
> > -			if (!node->back_pointer) {
> > +			if (!new_n0->back_pointer) {
> >  				edit->set[1].ptr = &array->root;
> > -			} else if (assoc_array_ptr_is_leaf(node->back_pointer)) {
> > -				BUG();
> > -			} else if (assoc_array_ptr_is_node(node->back_pointer)) {
> > -				struct assoc_array_node *p =
> > -					assoc_array_ptr_to_node(node->back_pointer);
> > -				edit->set[1].ptr = &p->slots[node->parent_slot];
> > -			} else if (assoc_array_ptr_is_shortcut(node->back_pointer)) {
> > -				struct assoc_array_shortcut *s =
> > -					assoc_array_ptr_to_shortcut(node->back_pointer);
> > -				edit->set[1].ptr = &s->next_node;
> > +			} else {
> > +				struct assoc_array_node *p;
> > +
> > +				p = assoc_array_ptr_to_node(new_n0->back_pointer);
> > +				edit->set[1].ptr = &p->slots[new_n0->parent_slot];
> >  			}
> >  			edit->set[1].to = assoc_array_node_to_ptr(new_n0);
> > -			edit->excised_subtree = assoc_array_node_to_ptr(node);
> >  		}
> >  	}
> 
> This causes conflicts with upstream. I suspect with Linus' cleanups part of
> 
> commit 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4 (origin/master, origin/HEAD,
> master, base)
> Merge: 141b164bbe18 bbab563c5131
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Nov 16 09:35:38 2026 -0800
> 
>     Merge tag 'assoc-array-fixes-v2'
> 
>     Clean up assoc_array library code
> 
> It's in akpm/mm-hotfixes-unstable, but is this really MM material?
> 
> Sounds more like nonmm stuff.
> 
> Anyhow, I'll drop this from now from mm-next as I couldn't easily figure out how
> to resolve this (or if it is still required).

I think you're right, thanks.

I temporarily removed the commits from my next mirror branch.

I'll go through this with time and re-push them later.

> 
> -- 
> Cheers,
> 
> David

Br, Jarkko
