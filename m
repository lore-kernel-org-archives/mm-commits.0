Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B4335F191
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783236706; cv=none; b=de61++T2Jd4vDYOdA/bN3c5ItNs8niD7Z8fZYvGrT44U2KpFNv8xZYDkymCtkVbePJVdvY7h3d4FPirB5w376eHHQ3je6pemjE9ZwW51az6RoV5xpH/kKA3YOiX/5vadFMvgfPakFKEU4PNT3RLDaO7ovBtqE6PgaFaQnCKZ2Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783236706; c=relaxed/simple;
	bh=ijpWjxIpkKUnXwqATNSKH9LF/mrjDxKvpGuNckk3hHQ=;
	h=Date:To:From:Subject:Message-Id; b=MC5H2nmIVO+llTaC48GqbWU4F9IpN4z32CFws6tE3dKVVVwebiX1ARg+XYwS+e1y2LQt+Pi9GBVynKbXeyHXgregMQcknASGcIguIIY4maUZuW2HSWEHWe7UKH6a3tGrh5A5vjKxHxkcG52rFIkY/cmOoSdDZ2xpuA/nW4SEWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pCXavRrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pCXavRrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52151F000E9;
	Sun,  5 Jul 2026 07:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783236704;
	bh=DNHML8W6PxN/FXCFns0p8WfO7ZOa+ujVxz6rqJJUBOE=;
	h=Date:To:From:Subject;
	b=pCXavRrUMCN0CnCzC1+u6Jgded4gr2/WzU1ScYfg9lU/yb4YVI1RR9ScLCt+fBMNk
	 cYCIR6MkPnSIiGkYJXSHRsp5CB1EvnoazRMjOIbiC9xUnD3s2bYo60TRN+n/l69goX
	 yy1CyRc35xXGHXAZ7KrUpDRgfFdUgTb4b7OSUYAA=
Date: Sun, 05 Jul 2026 00:31:44 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + net-funeth-switch-to-higher-level-allocator-api.patch added to mm-new branch
Message-Id: <20260705073144.A52151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: net/funeth: switch to higher-level allocator API
has been added to the -mm mm-new branch.  Its filename is
     net-funeth-switch-to-higher-level-allocator-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-funeth-switch-to-higher-level-allocator-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch

