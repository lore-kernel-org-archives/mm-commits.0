Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF930F55F
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622834; cv=none; b=aXSxl9yfvxOeuLyp/GwvBP4dfjxW6xSI+AH22KtPDNhwYg0UTFmSfB41WzXTjSk2yI5jdWrrnp6i/Z6df2aEzE3zP6k0WRVqHojG91dLgG5aTwISAvoXdR2d6/aGqqzunrrta+Gp9Bt41NGqpd5arZp6GgMoREJkU2Vp5B2Qlro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622834; c=relaxed/simple;
	bh=gGIcMLm4v3oJty0MkmisLG5gQfr9TV58jL+Owe4LSck=;
	h=Date:To:From:Subject:Message-Id; b=YWrDcbGLEZYVoJn9RnQOw34GyNNRt63toiMyIy81EYZoJYdI1dtX1mSWzls7Q0+kJGJbNeVf/DaWLgPjQ6CSWu4g8FFw+ZhuVeOSa4TUmGVroTOVfi32oJ7o377jwNtvyW1g/Z1tI/Y6em3YR5FHstQ4L/C71QboPj93llnf2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXLEukym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXLEukym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510DE1F00A3A;
	Tue, 25 Aug 2026 01:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622833;
	bh=A5QFTlEgosNC2+3DT4nKJkXQZ1MSj/LAFDHdG88Eigk=;
	h=Date:To:From:Subject;
	b=wXLEukymFXb2bDSsZw2OSedx+K+vV6yrij/emLLxkrRZ6jncxfCpun8tRDlxZcyym
	 eCx473e8n3zTedXVA5yZD/C+ZwemrUkKmvPS5Vupa/H0M7SQeDBxdceJk66DqqssTU
	 oPiljMuPbkNoeX1EyPe47d7YJzukEK24sd4bx5D8=
Date: Mon, 24 Aug 2026 18:53:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-make-flatmem-depend-on-numa.patch removed from -mm tree
Message-Id: <20260825015353.510DE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/Kconfig: make FLATMEM depend on !NUMA
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-flatmem-depend-on-numa.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/Kconfig: make FLATMEM depend on !NUMA
Date: Wed, 5 Aug 2026 00:11:41 +0900

Patch series "mm/page_ext: remove pgdat_page_ext_init()", v2.

pgdat_page_ext_init() has no effect on FLATMEM. The pgdat is always
the zero-initialized contig_page_data, because no architecture
supports FLATMEM + NUMA.

That constraint is only implicit in the arch Kconfig files. So patch 1
makes it explicit in mm/Kconfig, and patch 2 removes pgdat_page_ext_init().

No functional change.


This patch (of 2):

FLATMEM + NUMA is not supported by any architecture and fails to build. 
The constraint is only implicit in the arch Kconfig files.

So make it explicit in mm/Kconfig.

No functional change.

Link: https://lore.kernel.org/20260804151145.3419768-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20260804151145.3419768-2-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/Kconfig~mm-kconfig-make-flatmem-depend-on-numa
+++ a/mm/Kconfig
@@ -390,6 +390,7 @@ choice
 
 config FLATMEM_MANUAL
 	bool "Flat Memory"
+	depends on !NUMA
 	depends on !ARCH_SPARSEMEM_ENABLE || ARCH_FLATMEM_ENABLE
 	help
 	  This option is best suited for non-NUMA systems with
@@ -424,6 +425,7 @@ config SPARSEMEM
 
 config FLATMEM
 	def_bool y
+	depends on !NUMA
 	depends on !SPARSEMEM || FLATMEM_MANUAL
 
 #
_

Patches currently in -mm which might be from ekffu200098@gmail.com are


