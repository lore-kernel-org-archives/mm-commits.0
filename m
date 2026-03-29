Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EC9279DCA
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744970; cv=none; b=lblXTsVWF9m5EYUh+bGmZiUmo4Lwp96GSK23BbyJyhtaqnu0/VfxLRdjIjxinhoz14pu2t+pSwQ1rySNpH8w7P02NJyhbcq6ma5u6nGyPQIF38cwGeeQ70dvRDW+njwevlh4XgdvvgJIBFFXjvbZ/BsXEoTnGqTYcqe37Qipuuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744970; c=relaxed/simple;
	bh=/nS7LiFtfaO7ucouosMnnE2yn8zPVC8I9P09fajLiiE=;
	h=Date:To:From:Subject:Message-Id; b=M3TEX8mn4YoFzmADUFuPax0eFhendgUtKNzDBwmCShVUhPOsJw5nd+Q9ZoHIklnLLw+pQltJZ18v+18Vw+3zYjeEvCJN86F+dG5er3whkZ53A/BWHLtxeh+SirErSobLVMsDiiLmaBlV+fqzXQEm4kzsfs6RAOchKEZeVRobK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GZGZVZnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GZGZVZnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDD2C4CEF7;
	Sun, 29 Mar 2026 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744970;
	bh=/nS7LiFtfaO7ucouosMnnE2yn8zPVC8I9P09fajLiiE=;
	h=Date:To:From:Subject:From;
	b=GZGZVZnnFkH4a7TQELLttKYExGQW4GwoE82PCrxvS/379MXvhpVvH/GfQHnuhmypN
	 Eq10oO/VpBEecyJ5wrusjhQ+1kUZS9jAH8TFGOij3hMx0eWym94qjSPp/ajGT7HL2L
	 RnkLFI2jS0rdviwph7EBRysjQzpNdw736kiyS+gc=
Date: Sat, 28 Mar 2026 17:42:49 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch removed from -mm tree
Message-Id: <20260329004250.7BDD2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: fix stale reference to memory_block_add_nid()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-fix-stale-reference-to-memory_block_add_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: drivers/base/memory: fix stale reference to memory_block_add_nid()
Date: Sat, 21 Mar 2026 18:57:04 +0800

The function memory_block_add_nid() was renamed to
memory_block_add_nid_early() by commit 0a947c14e48c ("drivers/base: move
memory_block_add_nid() into the caller").  Update the stale reference in
add_memory_block().

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Link: https://lkml.kernel.org/r/20260321105704.6093-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memory-fix-stale-reference-to-memory_block_add_nid
+++ a/drivers/base/memory.c
@@ -815,7 +815,7 @@ static int add_memory_block(unsigned lon
 		/*
 		 * MEM_ONLINE at this point implies early memory. With NUMA,
 		 * we'll determine the zone when setting the node id via
-		 * memory_block_add_nid(). Memory hotplug updated the zone
+		 * memory_block_add_nid_early(). Memory hotplug updated the zone
 		 * manually when memory onlining/offlining succeeds.
 		 */
 		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are


