Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7EF318EE5
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486691; cv=none; b=aL29NKyrGsLXikhAZZl9HUTVf+tPOzcCK5Mz9/JpNkoNdabazjlhvw+eXNVQcWiquvtsWi4TO5vnss9EE2FUk2NuzLkLNqNEsGNRm3v1UY3oWYmJwsyCscNly0VMzZyOde5McsreSS5REQDVqG1qAQeghPo8cA7HMMUh7BP6qic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486691; c=relaxed/simple;
	bh=2rqFBXIng06CTiP0qHN7dVRABTF2Sol6c7Ov3wAQ+bI=;
	h=Date:To:From:Subject:Message-Id; b=jJCC8z7xvaXjP5o6FoQ3aNeJXj7vpDK/d9XdqvUbE2wrweNsAx/p+HMVEPZYcXfbV/+SWQHQeojLE//xvSMMdm43+m+gjPchvtqk95c6xHfvP+o/Ye+7XBcH8Gp+8cX2nK1PT78zyAUL43fQUawjippR7Gx8rB1VFajRCb/x3e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f7GkNtFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f7GkNtFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A67C116C6;
	Tue, 27 Jan 2026 04:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486690;
	bh=2rqFBXIng06CTiP0qHN7dVRABTF2Sol6c7Ov3wAQ+bI=;
	h=Date:To:From:Subject:From;
	b=f7GkNtFS66/er5jFWJJxliFDXCXuHyQKQtEAv9gdJ5d9IFivTEb4mPyUMG4yXby9/
	 76ZVBMR+AmsGf3+PqJLH3SY3gAMOpzSXX0yWhS6IvnLj9zNPaXs8f4iS7AHUxG90PS
	 wR+AVWZXgQz0fCZ7jPHDw0tupcBhPI8/aJHvTaiU=
Date: Mon, 26 Jan 2026 20:04:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,houwenlong.hwl@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch removed from -mm tree
Message-Id: <20260127040450.D6A67C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/early_ioremap: print the starting physical address in __early_ioremap()
has been removed from the -mm tree.  Its filename was
     mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: mm/early_ioremap: print the starting physical address in __early_ioremap()
Date: Fri, 9 Jan 2026 21:31:51 +0800

The debug WARN() printing occurs after the while loop, so the 'phys_addr'
reflects the last physical address rather than the actual starting
physical address, which is not useful for debugging.  To simplify, the
WARN() statement could be moved up before the loop instead of introducing
a new variable to record the original 'phys_addr' value.  Additionally,
swap the print order of 'slot_virt[slot]' and 'offset', as this will
enhance output readability.

Link: https://lkml.kernel.org/r/aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremap-print-the-starting-physical-address-in-__early_ioremap
+++ a/mm/early_ioremap.c
@@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_add
 	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
 		return NULL;
 
+	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
+
 	/*
 	 * Ok, go for it..
 	 */
@@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_add
 		--idx;
 		--nrpages;
 	}
-	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
 
 	prev_map[slot] = (void __iomem *)(offset + slot_virt[slot]);
 	return prev_map[slot];
_

Patches currently in -mm which might be from houwenlong.hwl@antgroup.com are


