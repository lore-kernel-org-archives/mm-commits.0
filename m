Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF519E839
	for <mm-commits@vger.kernel.org>; Sun, 26 Jul 2026 03:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785036649; cv=none; b=nrYKqmaoWg6glxqAK9o+IXlelR5ygcbFaiRP+dcHolLMRWYOiApcwo+kneIBTmBHEJw3yzslSgCF4M46W6ulVSpNBcSZN8+wxlJka9wTTzIrnZJC4QDAVJCdP80GD5qZlcUQ1ifJrUqkhTUMdt950OFyfzQsyOl9kn4tsvs05Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785036649; c=relaxed/simple;
	bh=rN+6tJx3i2srKs9yDrOPwORAsU7u2NRHvR/gu6QOUYk=;
	h=Date:To:From:Subject:Message-Id; b=HFS3rO0igC0wmv0zoJvPC5ZTK+Q0VAGLAMAo6Na3rLc6ChU/C/vo0RYUtIkziyZFPI2r26YKgjNDBtgoLRuoPOcTC7SG6s/HsPg3wXj5FpyrcfKEURWL8YXb9pJVNSQUAQUIOMCkCvAUmXLU5ErufAxMNUyq7OmaAxT9uwunFQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ylbC1xt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ylbC1xt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913381F000E9;
	Sun, 26 Jul 2026 03:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036647;
	bh=uRyY04tceCUjIaptjpVsk13uJklI5QQIOTa+4n1jeKU=;
	h=Date:To:From:Subject;
	b=ylbC1xt+/vkFX+n+F18cZl/l3Mod6JlXEjnZkXv6jjNdciEYPyGQJkJ85phZNvJGm
	 AxlLLwfFg7RgPHNysdZaZgqjcy1/EeTFKfinb2bIrsAXgekW0iUL4wEcni8CfrEqo3
	 Yg0IrpoYvkHKPAQ/S83gNhE4NPLBbPMnv+SQ729s=
Date: Sat, 25 Jul 2026 20:30:47 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch added to mm-nonmm-unstable branch
Message-Id: <20260726033047.913381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Gou Hao <gouhao@uniontech.com>
Subject: RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:51 +0800

alloc_skb() with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks and error handling are unreachable dead code. 
Remove them.

Link: https://lore.kernel.org/20260724022851.466017-7-gouhao@uniontech.com
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Cc: Bharat Potnuri <bharat@chelsio.com>
Cc: Cédric Le Goater <clg@kaod.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb4/mem.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/cxgb4/mem.c~rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations
+++ a/drivers/infiniband/hw/cxgb4/mem.c
@@ -74,11 +74,8 @@ static int _c4iw_write_mem_dma_aligned(s
 		c4iw_init_wr_wait(wr_waitp);
 	wr_len = roundup(sizeof(*req) + sizeof(*sgl), 16);
 
-	if (!skb) {
+	if (!skb)
 		skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-		if (!skb)
-			return -ENOMEM;
-	}
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 	req = __skb_put_zero(skb, wr_len);
@@ -134,11 +131,8 @@ static int _c4iw_write_mem_inline(struct
 					 roundup(copy_len, T4_ULPTX_MIN_IO),
 				 16);
 
-		if (!skb) {
+		if (!skb)
 			skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
-			if (!skb)
-				return -ENOMEM;
-		}
 		set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
 
 		req = __skb_put_zero(skb, wr_len);
_

Patches currently in -mm which might be from gouhao@uniontech.com are

powerpc-xive-remove-dead-null-check-after-gfp_nofail-allocation.patch
powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
powerpc-xive-fix-use-after-free-of-xive_ipis.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch
rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

