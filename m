Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE41D425867
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816371; cv=none; b=D5sfoIl8OjOb65yKXWrpLf2soRYoVtmjjU7HB/DNkVhB8Mc/s0ivo3iAgCpg0L8jyKB76gfXgtHPF9JEqWvaG5TZkdfyvgFbX3X1lcEGb9nbE6CQ3mDuzPf8p4AZorPhI9PkOBjoGppzJPDfsp6moVuRlhtxs4anZzm7cP3OMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816371; c=relaxed/simple;
	bh=AoCee0UzpK8ARdGXOZy3hcsnhpW4fXGRe7YwdN1wiRA=;
	h=Date:To:From:Subject:Message-Id; b=fTJ+HY9y3ZdtjIowo9pogHIqbTwrv4yxwSErDDFEoKNg2ubNeGSZS+VM9BcYl0dZuxrJzPdIzbXItvDirrpxCflwngq6m5VsBqhIX6f8k6WEnuRxUHfzTACBgKFBmONJkIWQtMd0k2TP5dHxfodPI9dAzF6cZNjkZgB29TwDOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zyeSCKRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zyeSCKRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ACF1F000E9;
	Tue,  4 Aug 2026 04:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816369;
	bh=zov/Cyu/pj6OQx87RTAbIkujTsTVAcRJ60EcgNtLNAA=;
	h=Date:To:From:Subject;
	b=zyeSCKRwUyL7wiN2InuyH9K1OadScPNT8ql1g4ih0Ddu0Avwgcm+vitdDG230VmwE
	 0C8ik8yfUT9YarXAfsm9watYjWqqERImRk7AXH7mdwt+b8uIW9IxA5JN3OJRe4VLvM
	 JJ2Tl5iEoqARufqus4hV+ikYhQQAwqIsWvZEkgps=
Date: Mon, 03 Aug 2026 21:06:09 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,apopple@nvidia.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch removed from -mm tree
Message-Id: <20260804040609.88ACF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
has been removed from the -mm tree.  Its filename was
     rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Alistair Popple <apopple@nvidia.com>
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


