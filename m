Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66ED2E40B
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749006482; cv=none; b=mnL2/6YhsgE+/zamGWQHR7C3Tt2cwwNmNlxHbfdAg94N2LqOJjOHeng6dRockC+HwiZ19RJYk1TJoJnqBEyivxtSIpXwdiujXn8BpyPod3t6AWXeOYwNS7cHX/4ZlIHw054mEdst42L2Sp37eXdYER10yNiUrwPKtfZWTfW1UJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749006482; c=relaxed/simple;
	bh=HppSK4VDtRv3T1DDg9kPhME6qFz17Mx77LuP/1quf+0=;
	h=Date:To:From:Subject:Message-Id; b=NSKSPfb/vHLKBRr3AtgqUZKllFiV05oTfZdwdqboBFwEGhdIA98dHg1NDRH8PvoN7o3WZ8kF96TnyD6L+IxtIq9Xpup7HSjTk8sdt4a/ZIQkxcoxCeIxNerTvK9JGUA5nYRyemTnAi5VPIWfBbbaem8yDzpdP9RObyE197epZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eY/lMy3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eY/lMy3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4C1C4CEED;
	Wed,  4 Jun 2025 03:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749006482;
	bh=HppSK4VDtRv3T1DDg9kPhME6qFz17Mx77LuP/1quf+0=;
	h=Date:To:From:Subject:From;
	b=eY/lMy3lrr2AeVNQYHmCASCjAodXIMEAuChMBf3WFz56F6B19jy/+6QBvDkphmS2D
	 rABXaXhcSAfHkI1zgG2rIRS2kGKz/nPTbSud3WzuVu7kyq1533IXJ6N3QCW206x78E
	 uDNYHTCX7z4NSY0s5bA63rveL9Daxmmsx3lU9RjI=
Date: Tue, 03 Jun 2025 20:08:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch added to mm-new branch
Message-Id: <20250604030802.3E4C1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: remove register_memory_blocks_under_node() function call from register_one_node
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: remove register_memory_blocks_under_node() function call from register_one_node
Date: Wed, 28 May 2025 12:18:02 -0500

register_one_node() is now only called via cpu_up() →
__try_online_node() during CPU hotplug operations to online a node.

At this stage, the node has not yet had any memory added.  As a result,
there are no memory blocks to walk or register, so calling
register_memory_blocks_under_node() is unnecessary.

Therefore, the call to register_memory_blocks_under_node() has been
removed from register_one_node().

Link: https://lkml.kernel.org/r/ecf07075b1a41015fcf58823997d5c2ed7b8c18f.1748452242.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/node.h |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/include/linux/node.h~drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node
+++ a/include/linux/node.h
@@ -134,21 +134,7 @@ extern int __register_one_node(int nid);
 /* Registers an online node */
 static inline int register_one_node(int nid)
 {
-	int error = 0;
-
-	if (node_online(nid)) {
-		struct pglist_data *pgdat = NODE_DATA(nid);
-		unsigned long start_pfn = pgdat->node_start_pfn;
-		unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
-
-		error = __register_one_node(nid);
-		if (error)
-			return error;
-		register_memory_blocks_under_node(nid, start_pfn, end_pfn,
-						  MEMINIT_EARLY);
-	}
-
-	return error;
+	return __register_one_node(nid);
 }
 
 extern void unregister_one_node(int nid);
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-optimize-memory-block-registration-to-reduce-boot-time.patch
drivers-base-node-remove-register_mem_block_under_node_early.patch
drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch
drivers-base-node-rename-register_memory_blocks_under_node-and-remove-context-argument.patch
drivers-base-node-rename-__register_one_node-to-register_one_node.patch

