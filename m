Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730A142F70C
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173683; cv=none; b=h93qgD1v4f6o2f3JLFFdeuTRlnl3/Ym4xRaPwoxE4vucJ4lonh/cMwjORommTxwgFk4FAe1tXr/1obAqXsC9yfvomUUx5YYBrCaBncV4CFbWnOy/sMnWx2+XmsD5xboBlKdrhgrVhkBtHHJBoRJTaN9z0apcbnf/6rvlgy5ldIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173683; c=relaxed/simple;
	bh=UacPadgCI+xsqDlkjNqVCIlxrV+eenoeToLSerhbwZs=;
	h=Date:To:From:Subject:Message-Id; b=VH0Snh7iATlMJ7+/u7NB1ZlEWRrKhU0t8i/Qh5Xbg9cwUxhpaUaB7pCYtkqL1otzhbqz3PRrQVy2L4UNfBXyGIJ8iIxp11dsYVhnSF4PNDkVkInTxB96HNo9QvysoZidJH0OfZ4BSdiDJ+15zSllyUnHP6IvhJJc7Il4kUiLTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jn2PcyA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jn2PcyA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4661F000E9;
	Mon, 27 Jul 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785173682;
	bh=vo+YZTbjGM5g5s/c7f7BZKN8Bzh5J05cNzqNb6CYiwI=;
	h=Date:To:From:Subject;
	b=jn2PcyA347ixQukEq8cLSsZZxLxJNVYrYkRuL1sKgSj2YytqcEJS1x1kvD7kP0LZA
	 l4O3yWLWUx4n1FKoN+fW4aA/y6Te1Sp5StpF0EA6UvcgtArRPnJPpS7hKxH6dEbpt8
	 u7IDaxUejQhBDGQ6V7W2AZswYAOhVTSHQK90YPAs=
Date: Mon, 27 Jul 2026 10:34:41 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch removed from -mm tree
Message-Id: <20260727173442.1D4661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations
has been removed from the -mm tree.  Its filename was
     rdma-cxgb4-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

powerpc-xive-add-error-return-value-to-xive_smp_probe.patch
drm-remove-dead-warn_on-null-check-after-gfp_nofail-allocation.patch
lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch

