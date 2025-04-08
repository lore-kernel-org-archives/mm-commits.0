Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E190236427
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744127160; cv=none; b=CRA05peeSDOKn8lfrDhziGVTf0TziT5mhUr9nEWh9RWR0s4YPXEy7mOUIqW5abZpRWtYEEx4Y9gsXJXLpMWHMGvQ+nZa7O66JNrjboKzvJ5WeQiBRbHFaCQZTB6o8ZpOEzld/so+80KLeQQsKh467MUjItsQPUTRc6hj2ox1J2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744127160; c=relaxed/simple;
	bh=TVoAr6TGO7wCkOSO2Lnv8xzibhOxdoDW2Q9jxQoW9XA=;
	h=Date:To:From:Subject:Message-Id; b=NC8PvoTF9bfLJrO4njIKddvK+X2OYcwxX/5WLBRFw4QL0bXrwRo0ZzK8NsNq/T7v2bare9IGL1wJ78BGUfFc8N4K44p62XNgKbIAYm8pKEXT81fKIfjBK3rpPwk1VLfJGBX6QiWHJFB7bauc++ijnYB4H5EvSnOrTlmWokR2VW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M3vbljMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M3vbljMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94920C4CEE5;
	Tue,  8 Apr 2025 15:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744127159;
	bh=TVoAr6TGO7wCkOSO2Lnv8xzibhOxdoDW2Q9jxQoW9XA=;
	h=Date:To:From:Subject:From;
	b=M3vbljMqJbteUUP600fksVrQIxmcNbANGhxkcRP2mqtOHG5l5GQXofrJGERD0Pamm
	 a+2UsemMAj0oDoEdE2SJtlzB5lwC5CUKnpAdXSMtx0ZAbqi1y0GEOYiSVsJLTJzTtl
	 xaZ3QdZ9ZrRF5M0i0B1PvhT/EeS8z2KdYXrF2s1A=
Date: Tue, 08 Apr 2025 08:45:58 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-add-for_each_vmap_node-helper.patch added to mm-new branch
Message-Id: <20250408154559.94920C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: add for_each_vmap_node() helper
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-add-for_each_vmap_node-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-add-for_each_vmap_node-helper.patch

This patch will later appear in the mm-new branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: add for_each_vmap_node() helper
Date: Tue, 8 Apr 2025 17:15:47 +0200

To simplify iteration over vmap-nodes, add the for_each_vmap_node() macro
that iterates over all nodes in a system.  It tends to simplify the code.

Link: https://lkml.kernel.org/r/20250408151549.77937-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/vmalloc.c~vmalloc-add-for_each_vmap_node-helper
+++ a/mm/vmalloc.c
@@ -900,6 +900,11 @@ static struct vmap_node *vmap_nodes = &s
 static __read_mostly unsigned int nr_vmap_nodes = 1;
 static __read_mostly unsigned int vmap_zone_size = 1;
 
+/* A simple iterator over all vmap-nodes. */
+#define for_each_vmap_node(vn)	\
+	for ((vn) = &vmap_nodes[0];	\
+		(vn) < &vmap_nodes[nr_vmap_nodes]; (vn)++)
+
 static inline unsigned int
 addr_to_node_id(unsigned long addr)
 {
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

