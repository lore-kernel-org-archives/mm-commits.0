Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793122923;
	b=aigCdMpsqUF4BNkUq17tlcr81F4/nxrOpYraQTkwDCpQqJomDGzrFFJaQvYJgplgyl6j
	 Oz5eKf3mfwJdpE7KEdIAFJqGxaN3B0iKBf/XDQmyYCXb3dOdRUQmuZgGg37jDRWU2hIZf
	 WfLJyqW5YyhmBDNcFnwHkctH9bTK1pDP4bt3cuhvln/YgzJLL4Ci1oymBOCq2tuYNIMru
	 pkrLm5oitwJqi8gIbQyiDhCK1jYTn7dGxHEK5yZ62Go2CezCCQizf+/SYM7CtFmgMLs2y
	 0z3d51UDx1gj1bt/qJrgXJ1T7ji2D41E6g1zOWNZRNjFqV3oWpAPXGWbBZRyvccyZGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122923;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=z3iAtCbmLUk/E3t+9/rOg5G6mlHHR35SW4OVmGcBTKs=;
	b=Ui21QFEtaB21xkCwhUs3qHHSUTNZQcXgz3dbune4WdyJ27v9uJHSm3NCeTm1BJCnve+a
	 I9DCl3fJIqJ/0wnIyPwLcvNw8COfpi/qylzBt310HFqeclfZaNYlDYA1phkO0Q6yxOjZy
	 LZphwNzvbLd2F9p3uLTNQ8hi4N3OC/OyEKRavnKUUQ/6/frl4bcodj1c/66dNCECpbxfQ
	 xkuh0y359hW4798vJAhaDk3Njr3pIOi7qcBlQV/5/W2YuNu0XqCRkXMRw8uUMPX/Bo3GT
	 0Vfj+pGt/k07wtArMQ9+3Xj9jdRuVaI1ftf5QG8z+d2gzKTJAYl/UjvPykf2IZtrKKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=ExYHbSH2;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1B6606A31A;
	Tue, 27 Oct 2026 17:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F1B6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=ExYHbSH2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z3iAtCbmLUk/E3t+9/rOg5G6mlHHR35SW4OVmGcBTKs=; b=ExYHbSH2utsdn/f8lny59vG1Ni
	gcCOx99xrz1qJ2U4gkUsrgdIXnNQjVgDgYJn+Qyp1fD7DQ6cKJt6HU5pGGVv8rtyH1Q2cgBkbnxPr
	KiSTGMw8n5custdkSFtsndnBEBEAndXGtZOV+hZ1DPvMNe8tjpwA6ss4kvLRyWVXZjY+M4bky3+dQ
	mURFbEaqwrxuJ8OZykkNmiGxZCB3MPznpKxPvASuPynxcqSM8UABPKnknqryrva3OofwtIsuJj5Lw
	LBvqkacFuStE4IB4cAOPVibXteCEwETjytqImpXCrPbl8qzBpI9vnlCbRXEUeVnUTLB+CtN+chbbO
	Pql6008g==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLlBP-0000000EzyB-2YWZ;
	Tue, 27 Oct 2026 17:41:59 +0000
Date: Tue, 27 Oct 2026 17:41:59 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
	nickolai@csail.mit.edu
Subject: Re: +
 xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch added to
 mm-unstable branch
Message-ID: <auDiZyUI490v5Pgm@casper.infradead.org>
References: <20261023181200.53AF01F01825@smtp.kernel.org>
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
In-Reply-To: <20261023181200.53AF01F01825@smtp.kernel.org>


i said this patch wasn't acceptable with the commit message the way it
was, and the very next mail i get is you taking it into your tree.
please stop doing this, it really makes me wonder if i have any value
left.

On Fri, Oct 23, 2026 at 11:11:59AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: xarray: clear the new head's parent before freeing the old head
> has been added to the -mm mm-unstable branch.  Its filename is
>      xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Subject: xarray: clear the new head's parent before freeing the old head
> Date: Mon, 12 Oct 2026 16:25:49 -0400
> 
> When xas_shrink() replaces the head node of an array with the node in its
> slot 0, it stores the child in xa_head, passes the old head to
> xa_node_free(), which queues it with call_rcu(), and only then clears the
> child's ->parent pointer.  In between, a lockless walker can still reach
> the old head, not from xa_head but upwards from the new head: xas_find(),
> xas_find_marked(), xas_next() and xas_prev() climb through xa_parent()
> when they step past the end of a node.  RCU does not protect a walker that
> gets there: call_rcu() waits only for the read-side critical sections that
> were running when the callback's grace period started, and that grace
> period can start before the parent pointer is cleared.
> 
>   CPU 0: xa_erase(), xa_lock held   CPU 1: RCU walker, e.g. xa_find()
> 
>   xas_shrink()
>     xa->xa_head = child
>     xa_node_free(old head)
>       call_rcu()
>                     <grace period starts>
>                                      passes a quiescent state
>                                      rcu_read_lock()
>                                      xas_find(): loads xa_head (child),
>                                      steps past its last slot,
>                                      child->parent is still old head
>     child->parent = NULL
>   xa_unlock()
>   quiescent state
>                     <grace period ends>
>   radix_tree_node_rcu_free(old head)
>                                      reads old head's slots[], shift,
>                                      offset and parent
> 
> The grace period does not wait for CPU 1, which reported its quiescent
> state before its critical section began; holding xa_lock delays the end of
> the grace period, not its start.  The start can fall inside the window
> when an interrupt arrives in it (interrupts are enabled under xa_lock(),
> and RCU core processing may run on interrupt exit), when callbacks are
> offloaded (rcu_nocbs=) and the rcuog kthread on another CPU handles the
> callback, when many callbacks are queued, or while the writer is preempted
> under PREEMPT_RT.  Interrupts, and in a guest a preempted vCPU, also
> stretch the window.
> 
> After the climb, xas_find(), xas_find_marked() and xas_next() resume in
> the old head at the slot after the child and read its slots[] and shift
> (xas_find_marked() also its mark bitmaps); xas_prev(), for which the child
> is the first slot, steps past the old head at once and reads its offset
> and parent, as the others do when they reach its end.  Nothing in the walk
> notices that the node is gone.  The climb takes ->parent as it is, no
> lockless path looks at node->array (XA_RCU_FREE), and xas_shrink() stores
> XA_RETRY_ENTRY in slot 0 of the old head only when the head shrinks to a
> single entry, not to a node; the walker does not look at slot 0 anyway. 
> radix_tree_node_cachep is not SLAB_TYPESAFE_BY_RCU, so the walker reads
> freed memory.  Once the object is reused for a node of another array, the
> walker returns that array's entries or descends and climbs into its nodes.
> 
> The order dates from the introduction of xas_shrink() in the commit below,
> which reimplemented radix_tree_shrink().  radix_tree_shrink() clears the
> child's parent pointer before it replaces the head and frees the old node,
> and still does in lib/radix-tree.c.  The commit gives no reason for the
> different order and nothing depends on it: xas_update() and xa_node_free()
> only touch the old head.
> 
> Clear the child's parent pointer before freeing the old head, as
> radix_tree_shrink() does.  The stores are the same, the tree and the
> xa_state the caller sees are the same, and a walker that starts after the
> callback's grace period has begun sees the cleared pointer, like every
> store before call_rcu(), and ends its walk at the new head, which covers
> every index that the old head had an entry for.
> 
> A check in the radix-tree test harness that no node passed to
> xa_node_free() is still the parent of a node reachable from xa_head fails
> in xas_shrink() 4731 times in the XArray tests without this patch and
> never with it.  No test is added: the race is not deterministic and the
> check needs a hook on xa_node_free().  A harness race test (readers
> walking the whole array with the four climbing walkers while a writer
> stores and erases an entry that adds three levels above the leaf) did not
> hit the window in 20 runs of 200000 erases; with a 1 ms sleep injected
> after xa_node_free() in xas_shrink(), every one of 20 runs reported a
> heap-use-after-free in __xas_next() or __xas_prev() under
> AddressSanitizer, and none did with this patch and the same sleep.  On a
> kernel (x86_64 defconfig + KASAN, QEMU), with a 100 ms delay injected at
> the same place, a walk that starts on another CPU 20 ms into the window
> climbs to the old head in each of 20 rounds, and KASAN reports a
> slab-use-after-free of the radix_tree_node freed from rcu_core() when the
> walk takes its next step; with this patch, the walk ends at the new head. 
> The XArray and IDA self-tests pass on x86_64 and riscv64.
> 
> Found while formally verifying xas_store() against the kernel binary.
> 
> Link: https://lore.kernel.org/20261012202549.772887-1-nickolai@csail.mit.edu
> Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: <stable@vger.kernel.org>
> ---
> 
>  lib/xarray.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/lib/xarray.c~xarray-clear-the-new-heads-parent-before-freeing-the-old-head
> +++ a/lib/xarray.c
> @@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *
>  		if (!xa_is_node(entry))
>  			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
>  		xas_update(xas, node);
> +		if (xa_is_node(entry))
> +			xa_to_node(entry)->parent = NULL;
>  		xa_node_free(node);
>  		if (!xa_is_node(entry))
>  			break;
>  		node = xa_to_node(entry);
> -		node->parent = NULL;
>  	}
>  }
>  
> _
> 
> Patches currently in -mm which might be from nickolai@csail.mit.edu are
> 
> mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
> mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch
> resource-report-a-devm_request_resource-conflict-under-the-lock.patch
> mm-bdi-reset-min_ratio-after-the-sysfs-attributes-are-gone.patch
> xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
> mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch
> 
