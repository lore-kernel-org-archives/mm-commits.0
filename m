Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921748;
	b=E4Ce1jAAd9iS99eMTQBWp2PlQ98eR7ffMeaiIGZMAsoU778jHD6xe4c68ijQh/gqIuz7
	 Yknwv+pJFs9vtBqu+mAddAlJrlK/AAz4Rx4yISKpmvHDwN9zGyqf3RHzWg5QzVXspEU4A
	 OyuYGGD7YB4y/LgxGh7VHtluo16UTTUtI+9d0Avo+Phvi7wI0cU+pa/KMxyKcLD1ACamU
	 H1Ee8Ve+u/Qu6kf3HYEaW5/5VHrH7wad2IuKPP92AFegokUC2uGYGRnKCppHa/IVZX/+9
	 pzTCTIpXxQRdZtTpiC3H/1g8RTAN35nUdeyCz/1SZkZ6RSl1u5ogte5B/OI48IkIfeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921748;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=q3DDGb9IWTrX6Pj2/yvRpbRR5C2SwHZTF4cKOKzF0BE=;
	b=DuG8h9BqycZWg9B3V8VdZIh2wFwzkRXcvzpLSO5DAGwfUtWagQEGQkFmJoka7LmsBilx
	 raJe8tkrWC1RBLIQ0WIfQZZ/PxihhI+lJwtwBBxNQL2Q/mpUhJWan+2CBUqovUI6Gdis9
	 5lzMQGr4EuyguAYK1gwK0kizhtJZlHTK/x/bZorqL1nsvfwLGB3xAS9aysoowC6y90WGC
	 +yNFIRLtd0S5ntBAr4L6P8DMemp2vT2N8O7uiyzICyWJRCrzUUAQ0Uqs/8Tisefa8OYCM
	 S96wvVavC1iboTZC05Nm8+rk6rpP+pJsAfd3UZ+Hck0HlInMXbUUGuNxY0lawnfbbvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jx2oSxX+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9F606A31C;
	Tue, 17 Nov 2026 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jx2oSxX+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413851F000C4;
	Tue, 17 Nov 2026 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794921748;
	bh=q3DDGb9IWTrX6Pj2/yvRpbRR5C2SwHZTF4cKOKzF0BE=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Jx2oSxX+IU18hyzbBGG7w9MRE/DIzQJSc4ET5lo0jg4JQa98smVR7OxpWgm4SHRPX
	 u7OMazaimrueAqRx9PmQ3P32Cze5fX6r+Je5X85meHlA5IRMs5QIFhgZtUc+BIFM7a
	 Pycg6HW6OAEYt69r7P0VzR+wHi/oW0l0xutIHO62AkEhH+w07FictKvxKpLehkKOft
	 VZ/25wKnqVDDydG9wL7/0CI6DP32HOUHU58J6WaPXB2zVaRVX4UOaImZmHEtGwJSPD
	 EB/O9cw6b503V3d53Gct+rBGFkrS7ClN8E7dyXusrIbM5c4jUqI2LlUOp2Zl4wGu89
	 cGBAAGBY/iHdw==
Message-ID: <86f9796a-2d2f-4e5a-875c-d2714bd76c58@kernel.org>
Date: Tue, 17 Nov 2026 14:22:22 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [merged mm-hotfixes-stable]
 assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch removed
 from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stable@vger.kernel.org, jarkko@kernel.org, dhowells@redhat.com,
 4ncienth@gmail.com
References: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261110064551.3EA5D1F008A1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/26 07:45, Andrew Morton wrote:
> The quilt patch titled
>      Subject: assoc_array: discard shortcut when collapsing a leaf-only node
> has been removed from the -mm tree.  Its filename was
>      assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch
> 
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Daehyeon Ko <4ncienth@gmail.com>
> Subject: assoc_array: discard shortcut when collapsing a leaf-only node
> Date: Fri, 25 Sep 2026 17:05:48 +0900
> 
> assoc_array_delete() can collapse a subtree into a node that contains only
> leaves while retaining the shortcut that led to it.  If that node later
> fills, all_leaves_cluster_together replaces it with another shortcut.  The
> first shortcut then points directly to the second one.
> 
> assoc_array_apply_edit() publishes this topology and propagates branch
> counts from the new child node.  It skips the inner shortcut, encounters
> the outer shortcut where it requires a node and triggers the BUG_ON().
> 
> Linux v7.2 and v6.12.105 are affected.  The same root remains at the
> base-commit below and in every supported stable branch checked down to
> 5.10.  It requires CONFIG_KEYS, but no capability, user namespace or race.
> A UID/GID 1000 process produced:
> 
>   CONTROL_BEGIN mode=exact uid=1000 gid=1000
>   CONTROL_CapEff: 0000000000000000
>   kernel BUG at lib/assoc_array.c:1388!
>   Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   CPU: 0 UID: 1000 PID: 154 Comm: exploit
>   RIP: assoc_array_apply_edit+0x4aa/0x690
>   Call Trace:
>    __key_link
>    __key_instantiate_and_link
>    __key_create_or_update
>    __do_sys_add_key
>   Kernel panic - not syncing: Fatal exception
> 
> When deletion produces a leaf-only node, bypass its preceding shortcut as
> garbage collection already does.  Retire the shortcut and old node
> together after an RCU grace period; reused leaves keep their references
> and the deleted leaf is still freed separately.
> 
> The exact trigger reached the BUG in 3/3 unmodified v7.2 KASAN boots and
> completed cleanly in 3/3 fixed boots.  Fixed v6.12.105 also passed 3/3.  A
> source reproducer is available privately on request.
> 
> Link: https://lore.kernel.org/20260925080548.2505640-1-4ncienth@gmail.com
> Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: <stable@vger.kernel.org>
> ---
> 
>  lib/assoc_array.c |   36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> --- a/lib/assoc_array.c~assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node
> +++ a/lib/assoc_array.c
> @@ -1210,8 +1210,22 @@ found_leaf:
>  				goto enomem;
>  			edit->new_meta[0] = assoc_array_node_to_ptr(new_n0);
>  
> -			new_n0->back_pointer = node->back_pointer;
> -			new_n0->parent_slot = node->parent_slot;
> +			/* A shortcut above a leaf-only node is redundant.  Drop it as
> +			 * GC does so that a later split can't create two shortcuts in a row.
> +			 */
> +			ptr = node->back_pointer;
> +			if (assoc_array_ptr_is_shortcut(ptr)) {
> +				struct assoc_array_shortcut *s =
> +					assoc_array_ptr_to_shortcut(ptr);
> +
> +				new_n0->back_pointer = s->back_pointer;
> +				new_n0->parent_slot = s->parent_slot;
> +				edit->excised_subtree = ptr;
> +			} else {
> +				new_n0->back_pointer = ptr;
> +				new_n0->parent_slot = node->parent_slot;
> +				edit->excised_subtree = assoc_array_node_to_ptr(node);
> +			}
>  			new_n0->nr_leaves_on_branch = node->nr_leaves_on_branch;
>  			edit->adjust_count_on = new_n0;
>  
> @@ -1225,21 +1239,15 @@ found_leaf:
>  			pr_devel("collapsed %d,%lu\n", collapse.slot, new_n0->nr_leaves_on_branch);
>  			BUG_ON(collapse.slot != new_n0->nr_leaves_on_branch - 1);
>  
> -			if (!node->back_pointer) {
> +			if (!new_n0->back_pointer) {
>  				edit->set[1].ptr = &array->root;
> -			} else if (assoc_array_ptr_is_leaf(node->back_pointer)) {
> -				BUG();
> -			} else if (assoc_array_ptr_is_node(node->back_pointer)) {
> -				struct assoc_array_node *p =
> -					assoc_array_ptr_to_node(node->back_pointer);
> -				edit->set[1].ptr = &p->slots[node->parent_slot];
> -			} else if (assoc_array_ptr_is_shortcut(node->back_pointer)) {
> -				struct assoc_array_shortcut *s =
> -					assoc_array_ptr_to_shortcut(node->back_pointer);
> -				edit->set[1].ptr = &s->next_node;
> +			} else {
> +				struct assoc_array_node *p;
> +
> +				p = assoc_array_ptr_to_node(new_n0->back_pointer);
> +				edit->set[1].ptr = &p->slots[new_n0->parent_slot];
>  			}
>  			edit->set[1].to = assoc_array_node_to_ptr(new_n0);
> -			edit->excised_subtree = assoc_array_node_to_ptr(node);
>  		}
>  	}

This causes conflicts with upstream. I suspect with Linus' cleanups part of

commit 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4 (origin/master, origin/HEAD,
master, base)
Merge: 141b164bbe18 bbab563c5131
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Nov 16 09:35:38 2026 -0800

    Merge tag 'assoc-array-fixes-v2'

    Clean up assoc_array library code

It's in akpm/mm-hotfixes-unstable, but is this really MM material?

Sounds more like nonmm stuff.

Anyhow, I'll drop this from now from mm-next as I couldn't easily figure out how
to resolve this (or if it is still required).

-- 
Cheers,

David
