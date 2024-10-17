Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB51925B2;
	Thu, 17 Oct 2024 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150123; cv=none; b=TVYKawQwNtw7bnVQJctxcBRD3mqH6JN905t9j4loiT27Sl3ZOvhXEAHUJ+990KlQE3LKUIbnHdRwstWfgezhC7oiMsv6NkDL4BVBkNqex9Wumk8JDaNXfRo52aw0A7Z3xJSnn4ySZPWaUKumBpJpmz+a45rt1Vs/rvrZ4fsKDfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150123; c=relaxed/simple;
	bh=8EKO0Y82HvG1xz85HYxViHr0O7bvTke/J4Shz6cc4es=;
	h=Date:To:From:Subject:Message-Id; b=ZXTli/mKWjYlXYBsEuk9LSvR7DxIjsOEJqjHi4xolZh8yq5WJXgo8kSWdjJ/C01HErpzhrPAldwkSz/+UiOJ/DMioYFPXHGRm04IE3K/+ca+OiP+/jQqCK4cP+es3ms4/PWUiacWw3jOoiB49Reuo/yG4McyDwtddJ+7vkpUPfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WbanNbVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WbanNbVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C76EC4CEC7;
	Thu, 17 Oct 2024 07:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150123;
	bh=8EKO0Y82HvG1xz85HYxViHr0O7bvTke/J4Shz6cc4es=;
	h=Date:To:From:Subject:From;
	b=WbanNbVbjTzgroqwdbc0LIb1R2j31UfzCdC2j/SLpv1WzG/Vezi1fr5YFZJz5SbG0
	 hxzLEQQDT+G2IAdAI55ekWXNEtgNaZaaEJI3pfDJySd0uPOsa+r5cBRutAkN0TzXia
	 YwIEIh7UzVwkxEw7/+chSOlPF64tlwVkHsMOpVBQ=
Date: Thu, 17 Oct 2024 00:28:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,stable@vger.kernel.org,kent.overstreet@linux.dev,greearb@candelatech.com,fw@strlen.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch removed from -mm tree
Message-Id: <20241017072843.3C76EC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
has been removed from the -mm tree.  Its filename was
     lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Westphal <fw@strlen.de>
Subject: lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
Date: Mon, 7 Oct 2024 22:52:24 +0200

Ben Greear reports following splat:
 ------------[ cut here ]------------
 net/netfilter/nf_nat_core.c:1114 module nf_nat func:nf_nat_register_fn has 256 allocated at module unload
 WARNING: CPU: 1 PID: 10421 at lib/alloc_tag.c:168 alloc_tag_module_unload+0x22b/0x3f0
 Modules linked in: nf_nat(-) btrfs ufs qnx4 hfsplus hfs minix vfat msdos fat
...
 Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
 RIP: 0010:alloc_tag_module_unload+0x22b/0x3f0
  codetag_unload_module+0x19b/0x2a0
  ? codetag_load_module+0x80/0x80

nf_nat module exit calls kfree_rcu on those addresses, but the free
operation is likely still pending by the time alloc_tag checks for leaks.

Wait for outstanding kfree_rcu operations to complete before checking
resolves this warning.

Reproducer:
unshare -n iptables-nft -t nat -A PREROUTING -p tcp
grep nf_nat /proc/allocinfo # will list 4 allocations
rmmod nft_chain_nat
rmmod nf_nat                # will WARN.

[akpm@linux-foundation.org: add comment]
Link: https://lkml.kernel.org/r/20241007205236.11847-1-fw@strlen.de
Fixes: a473573964e5 ("lib: code tagging module support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Closes: https://lore.kernel.org/netdev/bdaaef9d-4364-4171-b82b-bcfc12e207eb@candelatech.com/
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/codetag.c~lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls
+++ a/lib/codetag.c
@@ -228,6 +228,9 @@ bool codetag_unload_module(struct module
 	if (!mod)
 		return true;
 
+	/* await any module's kfree_rcu() operations to complete */
+	kvfree_rcu_barrier();
+
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {
 		struct codetag_module *found = NULL;
_

Patches currently in -mm which might be from fw@strlen.de are


