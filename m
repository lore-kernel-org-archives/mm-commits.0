Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C010237160
	for <mm-commits@vger.kernel.org>; Tue,  8 Apr 2025 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744127164; cv=none; b=b4JvBpNxC/8N1v0Klouh/8H/aD0DNp60B40EDgS0HNEyMe7dk1RoZ4JtBePaBxQ/GsuBdHJD7DYWZ8BoQlD/7UBc06SGqb8y2F39Io3BGmzVEeRNQrse/hp19QfltnQZIZsMFvJznsayDUetfKkweo93MDOBsRg9MMGOnn7DIKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744127164; c=relaxed/simple;
	bh=iKPRTFmf2RlTAQsqCLRlssh2nmu9nogtVax9iEo4p54=;
	h=Date:To:From:Subject:Message-Id; b=uhRNUFJHFWykfgBy0ApK6Ovu85ZGNjqp7v5liDNjQ4P686EMtpXlzlGn41sJdZPgbButtrB4TDx+8v9K+6+ptG++RxFRlz5h1bKXxdToZRr0Js0UThuAIIzc3CqP3bjvDTz6vmYCTGQpHsExOp/IPvxxZ/QUTI6bUHal1gDcVGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KbjJd68m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KbjJd68m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE61C4CEE5;
	Tue,  8 Apr 2025 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744127163;
	bh=iKPRTFmf2RlTAQsqCLRlssh2nmu9nogtVax9iEo4p54=;
	h=Date:To:From:Subject:From;
	b=KbjJd68mGDxKCegFJpUC+En2BtvxUYmCn0/GaosNP/wKs9GSbyOr9sfT8W90CZpjS
	 d4/5k0cD/2v/ic29GxQXXvdlQA8OlLflcCqs6J4HX4waGsQ5LGjbHmg77tXiv5czf/
	 yJmzIWxYE5vVQfxJ06T+As7wVBjkfWmmjZrQ9NIw=
Date: Tue, 08 Apr 2025 08:46:03 -0700
To: mm-commits@vger.kernel.org,hch@infradead.org,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch added to mm-new branch
Message-Id: <20250408154603.AAE61C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: use for_each_vmap_node() in purge-vmap-area
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

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
Subject: vmalloc: use for_each_vmap_node() in purge-vmap-area
Date: Tue, 8 Apr 2025 17:15:49 +0200

Update a __purge_vmap_area_lazy() to use introduced helper.  This is last
place in vmalloc code.  Also this patch introduces an extra function which
is node_to_id() that converts a vmap_node pointer to an index in array.

__purge_vmap_area_lazy() requires that extra function.

Link: https://lkml.kernel.org/r/20250408151549.77937-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~vmalloc-use-for_each_vmap_node-in-purge-vmap-area
+++ a/mm/vmalloc.c
@@ -923,6 +923,19 @@ id_to_node(unsigned int id)
 	return &vmap_nodes[id % nr_vmap_nodes];
 }
 
+static inline unsigned int
+node_to_id(struct vmap_node *node)
+{
+	/* Pointer arithmetic. */
+	unsigned int id = node - vmap_nodes;
+
+	if (likely(id < nr_vmap_nodes))
+		return id;
+
+	WARN_ONCE(1, "An address 0x%p is out-of-bounds.\n", node);
+	return 0;
+}
+
 /*
  * We use the value 0 to represent "no node", that is why
  * an encoded value will be the node-id incremented by 1.
@@ -2259,9 +2272,7 @@ static bool __purge_vmap_area_lazy(unsig
 	 */
 	purge_nodes = CPU_MASK_NONE;
 
-	for (i = 0; i < nr_vmap_nodes; i++) {
-		vn = &vmap_nodes[i];
-
+	for_each_vmap_node(vn) {
 		INIT_LIST_HEAD(&vn->purge_list);
 		vn->skip_populate = full_pool_decay;
 		decay_va_pool_node(vn, full_pool_decay);
@@ -2280,7 +2291,7 @@ static bool __purge_vmap_area_lazy(unsig
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(i, &purge_nodes);
+		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
 	}
 
 	nr_purge_nodes = cpumask_weight(&purge_nodes);
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch

