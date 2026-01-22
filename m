Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49F330F958
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769124229; cv=none; b=Adp/dXR1x2+mZ1lLu9EJZ8qlfthcJTcSnhQlAWVtsH9rUFhIT7q55TANKvVD+9+ngrV/EDKbydGjeiJ2s3XY3UFPNbTIqs3O8A7Acz04zyfsAm6YZWUDMv3hkOCneNrozrMpAMpH68PQDv38UH0KawI3/lTWaSM1h3CwhC/4Ces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769124229; c=relaxed/simple;
	bh=nuYyFY9gvHxBCjDUAjgG7vuUFUqStZ/rw8C0LgGvy6w=;
	h=Date:To:From:Subject:Message-Id; b=dGA67468kJ+044plqlK+JWPxTz7RasRT+7FTouHv8iMmHDXfO1LwbMmH9ZIhpfDLz9Mun8wLPcoMX0XxK56AvJfDUvpsbFIqwSF7x56cgvmb6eYicvw/mBb+BtH/j7Hgp6aR6uG9/MIuVyl+aQ+sLNbu95tOlLTy5dM/pBSYENE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TQODfc21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQODfc21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAB3C116C6;
	Thu, 22 Jan 2026 23:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769124228;
	bh=nuYyFY9gvHxBCjDUAjgG7vuUFUqStZ/rw8C0LgGvy6w=;
	h=Date:To:From:Subject:From;
	b=TQODfc21QNvpgxYgSeKLYy5pZ9E+1bYOtCTcj0u8U5Y9AAVQF+lZBlYlxlTVrqtOu
	 3wZRzM8orM6hsZcqDw3QsZ/+s89YgLaCCo/kJDttVGrvRENA6VH+Z6QrfuQV5GsHcQ
	 X+icx3qI0Ws7EI20miJ/ytCNL1Nh7LmfUym/RDAg=
Date: Thu, 22 Jan 2026 15:23:47 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,epetron@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch added to mm-nonmm-unstable branch
Message-Id: <20260122232348.3FAB3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: skip memoryless NUMA nodes when reserving scratch areas
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch

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
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
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

kho-skip-memoryless-numa-nodes-when-reserving-scratch-areas.patch

