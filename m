Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776CF3EBF1D;
	Sun,  1 Feb 2026 00:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905029; cv=none; b=bBluceB6d/nE2hV/bk2Mu2KNk7rlaoh5icUqgsUc+0OZiv+h7HUbk8G8GVEI64dsxzcbXbHk/iXzuakWgtLGzL+9kB9tJtiurXvE73yv+fRoYXHLnqUL6tQZOfpe+ZrPr+EasVR95dckt3MFj7oMKRtFZ3ZckRv9BTVoj7ztZRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905029; c=relaxed/simple;
	bh=fI5SNR2QQUHsDNwxzfEnxVcPhdUxgEYcVNDR6xkyQpE=;
	h=Date:To:From:Subject:Message-Id; b=advNlvgLuECXal68V9Pr+7XC+XJf+rRkpC1bqn9OGVUU6+pL78DS9Oxf0n43YnToPKyQjlVOiV+4X9vCe2MoYK7SC4R+PjLT68LWPDqkZJ/KvikXg8WhtxgcRvAKNGZJkz4Vo8FIxTQFeu0L7b4dJc86guYXwPgZle5ox3uZGLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XflCYuJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XflCYuJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFF2C4CEF1;
	Sun,  1 Feb 2026 00:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905029;
	bh=fI5SNR2QQUHsDNwxzfEnxVcPhdUxgEYcVNDR6xkyQpE=;
	h=Date:To:From:Subject:From;
	b=XflCYuJorifomaZfkAho5wHhmt32s5viIXEE0rDSE72LEgWg29iHlOd0nYQbbdmyl
	 oB3oPKiXVaRjh3sIwHgHk5NuuZHwG1+rQnlu9PrRMqIxsOJZ6MP6LzfvjRQx32buji
	 EimS2dRn71qnVUOVmAErawKaZOauOHpMVRgl79Ts=
Date: Sat, 31 Jan 2026 16:17:08 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch removed from -mm tree
Message-Id: <20260201001709.4FFF2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: skip memoryless NUMA nodes when reserving scratch areas
has been removed from the -mm tree.  Its filename was
     kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Evangelos Petrongonas <epetron@amazon.de>
Subject: kho: skip memoryless NUMA nodes when reserving scratch areas
Date: Tue, 20 Jan 2026 17:59:11 +0000

kho_reserve_scratch() iterates over all online NUMA nodes to allocate
per-node scratch memory.  On systems with memoryless NUMA nodes (nodes
that have CPUs but no memory), memblock_alloc_range_nid() fails because
there is no memory available on that node.  This causes KHO initialization
to fail and kho_enable to be set to false.

Some ARM64 systems have NUMA topologies where certain nodes contain only
CPUs without any associated memory.  These configurations are valid and
should not prevent KHO from functioning.

Fix this by only counting nodes that have memory (N_MEMORY state) and skip
memoryless nodes in the per-node scratch allocation loop.

Link: https://lkml.kernel.org/r/20260120175913.34368-1-epetron@amazon.de
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers").
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas
+++ a/kernel/liveupdate/kexec_handover.c
@@ -655,7 +655,7 @@ static void __init kho_reserve_scratch(v
 	scratch_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_scratch_cnt = num_online_nodes() + 2;
+	kho_scratch_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
 	if (!kho_scratch) {
@@ -691,7 +691,11 @@ static void __init kho_reserve_scratch(v
 	kho_scratch[i].size = size;
 	i++;
 
-	for_each_online_node(nid) {
+	/*
+	 * Loop over nodes that have both memory and are online. Skip
+	 * memoryless nodes, as we can not allocate scratch areas there.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
_

Patches currently in -mm which might be from epetron@amazon.de are


