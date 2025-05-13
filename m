Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593081EB5E6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119213; cv=none; b=C4uWao3w6vLAEITJRNoDbu8wgVyIlvpBFJrYluT2XRUDEBjIW+1ScGkArmKLmeIBrBSQcjAOYlBBgfNF7iltkYM/qBL6Uaac+wdvzrtpj36OaNK0VBs9f51G0qVRxXvwwqM9XdxGM28EdRW/fabpvO4AymlnWjAsv3y/fUtr2kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119213; c=relaxed/simple;
	bh=sHjb+dcvYQ8vZ/yev1fw8R6ZH1ykUU76ZJd6OZim9Hs=;
	h=Date:To:From:Subject:Message-Id; b=JVN08mybh4kLTptHwGeOJHRmZKQEOOBSxZMTw8F3AkOGn0IyGGbLSvn915GctFU8SJFWJEbcUDGWCj84QeB5nm+fzQKxXPCocIl/R4jfliw9tAdqaljP8v3/oLPOKoHUjJXNhBmIBMHYHwJKaKmw6AlDaDx7rBAPlpNQ/jDrEzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vEBCQ4SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEBCQ4SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F543C4CEE4;
	Tue, 13 May 2025 06:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119213;
	bh=sHjb+dcvYQ8vZ/yev1fw8R6ZH1ykUU76ZJd6OZim9Hs=;
	h=Date:To:From:Subject:From;
	b=vEBCQ4SXovNvyU9PrOxyoiZ030Xx9SdbhZ4IUO3kyCweJUkMjnmvTTEJctMcbaXBn
	 kSGg6B9RAIcmVN94Ap0vpGsLBCuTZL6vAeANOibteVmzYD9v2oigKE0umQaaZfwi+K
	 1RdzcbN+6D7SbnY7d/LDThj8tilbS8Q/8TXUN3VA=
Date: Mon, 12 May 2025 23:53:32 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch removed from -mm tree
Message-Id: <20250513065333.2F543C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: change purge_ndoes as local static variable
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-change-purge_ndoes-as-local-static-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: change purge_ndoes as local static variable
Date: Sat, 19 Apr 2025 06:36:49 +0800

Patch series "mm/vmalloc.c: code cleanup and improvements", v2.

These changes were made from code inspection in mm/vmalloc.c.


This patch (of 5):

Static variable 'purge_ndoes' is defined in global scope, while it's only
used in function __purge_vmap_area_lazy().  It mainly serves to avoid
memory allocation repeatedly, especially when NR_CPUS is big.

While a local static variable can also satisfy the demand, and can improve
code readibility.  Hence move its definition into
__purge_vmap_area_lazy().

Link: https://lkml.kernel.org/r/20250418223653.243436-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250418223653.243436-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-change-purge_ndoes-as-local-static-variable
+++ a/mm/vmalloc.c
@@ -2127,7 +2127,6 @@ static DEFINE_MUTEX(vmap_purge_lock);
 
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
-static cpumask_t purge_nodes;
 
 static void
 reclaim_list_global(struct list_head *head)
@@ -2260,6 +2259,7 @@ static bool __purge_vmap_area_lazy(unsig
 {
 	unsigned long nr_purged_areas = 0;
 	unsigned int nr_purge_helpers;
+	static cpumask_t purge_nodes;
 	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
 	int i;
_

Patches currently in -mm which might be from bhe@redhat.com are


