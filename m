Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B13028467B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126235; cv=none; b=Gol3D19/dZ3O9h7rUOvOGkNP8sqa6wHz+tvUL3HCjEiUdUH7pUKOxe6mgUuE1FQND53RzC+nCvSddX1ES6EKI0XSEzfdHUroIi3eTDmxz19zGOcNo6N5Wg+QFMjRiGDOdpG85Bvm050iJzsfW/YzpkkmlV9+QGY0jnAi6Lsqil0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126235; c=relaxed/simple;
	bh=736WTWjhOqj68Z3etvez+yY9mtE+pHr6GUZ5zcXzDaw=;
	h=Date:To:From:Subject:Message-Id; b=JpzSmejfttHu79V4Qh2iWT704wiXYgd7b28FPNHq7aukptmuEFke5UhiuOt0UnR7fvxLMkbHuxXsJH1B1/JFhTJZ5SHDT+UkPe8LG2ub65JRK3voYEH+Tpoex7UVQl1milMyE/VppXIyb2udhmIzaVGTpFTNUXZGdYb6Pg/flhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RNVxV4Sl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RNVxV4Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E40FC4CEE3;
	Thu, 10 Jul 2025 05:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126235;
	bh=736WTWjhOqj68Z3etvez+yY9mtE+pHr6GUZ5zcXzDaw=;
	h=Date:To:From:Subject:From;
	b=RNVxV4SlZJH8KrEpo1MpgHNabQXS45GIK1nG62/au0xzD/Bsbf0cg89GA9j93TkHy
	 ZxGBRAycdkpXeIZFw01ufD6M/woAubRyaxaz/n/m/Jgt0EWmOcdJNP8OegnMRCf3R3
	 rLMWGAMq9Dz/NmEkraoGJhFGBak4AK4QYi51/Wks=
Date: Wed, 09 Jul 2025 22:43:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,osalvador@suse.de,david@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch removed from -mm tree
Message-Id: <20250710054355.2E40FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: remove register_memory_blocks_under_node() function call from register_one_node
has been removed from the -mm tree.  Its filename was
     drivers-base-node-remove-register_memory_blocks_under_node-function-call-from-register_one_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


