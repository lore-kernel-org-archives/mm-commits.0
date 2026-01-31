Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500CB20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898276; cv=none; b=bG7VPQEpKQmhuMwlTX52CogbaNu7ed4Z4wUvyqvv33r3CmsD4MCA7uVxDkg3eoXdcc0CbT+OczIVo9Tvkp2y+J+6ngQ3Z/TaAUZl4z1ZqSxSjPYVi5Iz+nlGo7oUoez+0Yg+wfG+7b2o0goFoJh76MkKH0Hn+WP7l1O0O7Sr5p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898276; c=relaxed/simple;
	bh=8Gw28SwG7Qe5hcy58tKYlMRPBdi+gEFafxwv+v0T+vo=;
	h=Date:To:From:Subject:Message-Id; b=YN8o3XAkCGpoFfRlHe0arf6iNcwHvrztgLHmUkVmo6LngysiU6ErzgX+qf7LNz4Rn+FkgYbcliDzL11AJngTMOPCeOw7OKKKKfNUSAry/yuphkK1hrvWcBOV+WAWMIEZY+TV7KtEWIO+AkOYp8eA3w2wYGhrKmTcbSQ6AaUyv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mkpp0ocl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mkpp0ocl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF5C4CEF1;
	Sat, 31 Jan 2026 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898276;
	bh=8Gw28SwG7Qe5hcy58tKYlMRPBdi+gEFafxwv+v0T+vo=;
	h=Date:To:From:Subject:From;
	b=Mkpp0oclZJH0IbftbruiLneYpl86WVaflAh4OfvyqVbIhpX/U0FQpfK0oh0TASkkU
	 DXaKm1bAy2bbJF/B7Rrv49CkMUd7OJa+uq3iO+QMabv3jrOTvNfIiqPjOuwWgG+VLP
	 QWxKX1c+zLijrLmXxCO8HDAUPDi65I9QTzhS0HN8=
Date: Sat, 31 Jan 2026 14:24:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-make-balloon_compaction-depend-on-migration.patch removed from -mm tree
Message-Id: <20260131222436.0AEF5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-balloon_compaction-depend-on-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
Date: Tue, 20 Jan 2026 00:01:29 +0100

Migration support for balloon memory depends on MIGRATION not COMPACTION. 
Compaction is simply another user of page migration.

The last dependency on compaction.c was effectively removed with commit
3d388584d599 ("mm: convert "movable" flag in page->mapping to a page
flag").  Ever since, everything for handling movable_ops page migration
resides in core migration code.

So let's change the dependency and adjust the description + help text.

We'll rename BALLOON_COMPACTION separately next.

Link: https://lkml.kernel.org/r/20260119230133.3551867-22-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/Kconfig~mm-kconfig-make-balloon_compaction-depend-on-migration
+++ a/mm/Kconfig
@@ -599,17 +599,14 @@ config MEMORY_BALLOON
 #
 # support for memory balloon compaction
 config BALLOON_COMPACTION
-	bool "Allow for balloon memory compaction/migration"
+	bool "Allow for balloon memory migration"
 	default y
-	depends on COMPACTION && MEMORY_BALLOON
+	depends on MIGRATION && MEMORY_BALLOON
 	help
-	  Memory fragmentation introduced by ballooning might reduce
-	  significantly the number of 2MB contiguous memory blocks that can be
-	  used within a guest, thus imposing performance penalties associated
-	  with the reduced number of transparent huge pages that could be used
-	  by the guest workload. Allowing the compaction & migration for memory
-	  pages enlisted as being part of memory balloon devices avoids the
-	  scenario aforementioned and helps improving memory defragmentation.
+	  Allow for migration of pages inflated in a memory balloon such that
+	  they can be allocated from memory areas only available for movable
+	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can be
+	  migrated for memory defragmentation purposes by memory compaction.
 
 #
 # support for memory compaction
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

