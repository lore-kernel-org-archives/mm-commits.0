Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6BA37A48B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388653; cv=none; b=HiFcn+okqiRWHls0F7Uns1/eiLgFvyvzW/KRiZBBxzRwPr1oy8d53ubTzXiof0Q2WK8rGOV9hdJ8ocbk373pjeJzQ1TI7wq9MpnG0GHGqrLJnu8By55CgQGtuQmrC3y2XeoB/ssyEpfqKpRSET7iGqT5MwU8B07tmp0mUDS15Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388653; c=relaxed/simple;
	bh=1EOFIC3bVAax0R+VoL3PtOPm97L4Mdsxt7UffKDerOg=;
	h=Date:To:From:Subject:Message-Id; b=iWLuweIobgiHCrPzhHcDAJePJUJVdMlEWPdvdSjkSdqYrKWmFb3N6SprrIS6lNwB8uxAVzaZJhrNs/mCKi/5DRTqipdQRCK4xm17KhM4z3DVflDc1DMzxhhzUDgNtoDeUh6/8Cj+daqZI/M8uSIs71oGH8wyFT3d6PigupaA6lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PMkoHzYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PMkoHzYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE04C2BCB2;
	Tue, 24 Mar 2026 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388653;
	bh=1EOFIC3bVAax0R+VoL3PtOPm97L4Mdsxt7UffKDerOg=;
	h=Date:To:From:Subject:From;
	b=PMkoHzYgxIElQfi9QGoVZPEbK9IR0IkQrIr6sgL1lZkfOoK9TY/01vVvG5qMwnmiw
	 3NuAy6XLHw6S7BoZuLKrt3WHYe9WbRe4oHPJywraRRECZuNXeYAnJqAUT4vUeoL9zw
	 reMsCMKTSfindXN/oOwij/3w+vyNNpAYMiN5L/+g=
Date: Tue, 24 Mar 2026 14:44:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,kernel@xen0n.name,harry.yoo@oracle.com,hannes@cmpxchg.org,fvdl@google.com,david@kernel.org,corbet@lwn.net,cl@gentwo.org,chenhuacai@kernel.org,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slab-use-compound_head-in-page_slab.patch removed from -mm tree
Message-Id: <20260324214413.3EE04C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/slab: use compound_head() in page_slab()
has been removed from the -mm tree.  Its filename was
     mm-slab-use-compound_head-in-page_slab.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/slab: use compound_head() in page_slab()
Date: Fri, 27 Feb 2026 19:42:56 +0000

page_slab() contained an open-coded implementation of compound_head().

Replace the duplicated code with a direct call to compound_head().

Link: https://lkml.kernel.org/r/20260227194302.274384-19-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/mm/slab.h~mm-slab-use-compound_head-in-page_slab
+++ a/mm/slab.h
@@ -131,19 +131,7 @@ static_assert(IS_ALIGNED(offsetof(struct
  */
 static inline struct slab *page_slab(const struct page *page)
 {
-	unsigned long info;
-
-	info = READ_ONCE(page->compound_info);
-	if (info & 1) {
-		/* See compound_head() */
-		if (compound_info_has_mask()) {
-			unsigned long p = (unsigned long)page;
-			page = (struct page *)(p & info);
-		} else {
-			page = (struct page *)(info - 1);
-		}
-	}
-
+	page = compound_head(page);
 	if (data_race(page->page_type >> 24) != PGTY_slab)
 		page = NULL;
 
_

Patches currently in -mm which might be from kas@kernel.org are


