Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9837F1CD25
	for <mm-commits@vger.kernel.org>; Wed,  7 Feb 2024 22:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707344659; cv=none; b=G0kgjMZr6t7ECCfhB4wgc7xqhtwumy8pMvePiTjtKiLuEQpR7ofPn3jULU+tynPboYTU+ntVUrp9shWYegoj8j4EP5iPPYKtJalngwfiKDpv03rgpbBDUNsZFOKqbOgBlhXajAnxz3xt2rNMmln5H7G0N52KweWR9iUu2/FByTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707344659; c=relaxed/simple;
	bh=KR0ToQJVP1EvTik45rxjZk51K0MU4Dt3K4nj53x9mP4=;
	h=Date:To:From:Subject:Message-Id; b=NMF68zVTOBR8UqUnHqztTeTKdOwPkjMiZ8QEa4QoH1D9YDNo/SHIIudrZsIt+um7MMjX+7BRYJCcJui5BV1LWJJxFSb2iJ19NRu4NTTdX2T7Brsu84zPBTuEvOv5cPCXIuwoH45gyB0AKtkF/3YmKVEF1ByI+GEmb9KFhC6I3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qnIIwxtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qnIIwxtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0265C433F1;
	Wed,  7 Feb 2024 22:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707344659;
	bh=KR0ToQJVP1EvTik45rxjZk51K0MU4Dt3K4nj53x9mP4=;
	h=Date:To:From:Subject:From;
	b=qnIIwxtjRGLmXf6LQxm40qjBgG9/v5bHnngalYrmHbqnnW91S+BUdgLD0TA1wre7B
	 wcTt+TXpUMv2w7hTwZFkvTa4e1yVdIoFDmUoAmiGO/lY43PF9tiZKP1BmGBpVhw4tb
	 H9cvGZwe3Uf6T+jxAnez5u1mHJEmii0qBtY4rC5k=
Date: Wed, 07 Feb 2024 14:24:18 -0800
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,m.szyprowski@samsung.com,hch@lst.de,anshuman.khandual@arm.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-drop-config_cma_debug-fix.patch added to mm-unstable branch
Message-Id: <20240207222418.E0265C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dma-contiguous: remove debug code to removed CONFIG_CMA_DEBUG
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-drop-config_cma_debug-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-drop-config_cma_debug-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: dma-contiguous: remove debug code to removed CONFIG_CMA_DEBUG
Date: Wed, 7 Feb 2024 15:38:25 +0100

Commit acc2f3e42d4a ("mm/cma: drop CONFIG_CMA_DEBUG") removes the config
CMA_DEBUG and the debug code in cma.c, but misses debug code in
kernel/dma/contiguous.c.

Remove this dead code from this removed config option.

Link: https://lkml.kernel.org/r/20240207143825.986-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/contiguous.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/dma/contiguous.c~mm-cma-drop-config_cma_debug-fix
+++ a/kernel/dma/contiguous.c
@@ -37,12 +37,6 @@
 
 #define pr_fmt(fmt) "cma: " fmt
 
-#ifdef CONFIG_CMA_DEBUG
-#ifndef DEBUG
-#  define DEBUG
-#endif
-#endif
-
 #include <asm/page.h>
 
 #include <linux/memblock.h>
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch
mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch
mm-cma-drop-config_cma_debug-fix.patch

