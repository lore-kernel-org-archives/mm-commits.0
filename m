Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D09339393
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465810; cv=none; b=MmLtDDfr/wS5dStqdsmZcX4wjvwMF35upiINUuavvl4aYuRqFsqBFkW+mj5tQxnGbw7FN/gt8YyZ/24KQlNY/Y4Z3XkABa4jVmbIpkSXa1KTnDz20zUuA7f3CqiLVnnvvA+mRBB8W9+A9A2p3uwuz8VQlrAdb2nTo+pcqWbiQN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465810; c=relaxed/simple;
	bh=LBd1sHxfp31F853YJCVbAwc5fPCSas18N+8fj94Z0oo=;
	h=Date:To:From:Subject:Message-Id; b=kWyZaCsVB3my2b+vdVvHMTYTGFOg+S4ZaKbhge8HfQ6CJLX0bzwUFOzMDjYqhn/LAxZbDslZ16dvQW5y5d3+3cIymY/nIvq6VEMm7KIaKXCvH3QATURVTqYdL4fUPqSQSzfBtZKJ/QzixF3oSlbIkZ1t/3AB5SW6hS3E1d5/FX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EC6uDI02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EC6uDI02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF351F00A3D;
	Fri, 31 Jul 2026 02:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465808;
	bh=1YL0dgoCzuVOKxc00Lx26o4dXvdlY20iO/gqlJW4zW8=;
	h=Date:To:From:Subject;
	b=EC6uDI02eYKzF6IcECuX9oLqXhuGwdbh2cEZ6J2rBxolv3+F51FpBTiPrGO5+1XSx
	 RgZjjhbAhV6M4q4uCzUuwmUa5h14EP62afnnFHQkziPjTwWwxDqrg0237Dpk8FboK+
	 YYfARPaKao4D3hWO6saO2jN8ngh2hE5BPOVdMa54=
Date: Thu, 30 Jul 2026 19:43:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,pabeni@redhat.com,kuba@kernel.org,edumazet@google.com,dmichail@fungible.com,davem@davemloft.net,andrew+netdev@lunn.ch,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] net-funeth-switch-to-higher-level-allocator-api.patch removed from -mm tree
Message-Id: <20260731024328.CAF351F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: net/funeth: switch to higher-level allocator API
has been removed from the -mm tree.  Its filename was
     net-funeth-switch-to-higher-level-allocator-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: net/funeth: switch to higher-level allocator API
Date: Fri, 03 Jul 2026 12:31:52 +0000

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Link: https://lore.kernel.org/20260703-alloc-trylock-v5-12-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Assisted-by: Gemini:unknown-version
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/fungible/funeth/funeth_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c~net-funeth-switch-to-higher-level-allocator-api
+++ a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -103,7 +103,7 @@ static int funeth_alloc_page(struct fune
 	if (cache_get(q, rb))
 		return 0;
 
-	p = __alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
+	p = alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
 	if (unlikely(!p))
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

