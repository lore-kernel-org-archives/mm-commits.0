Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E42334214A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866034; cv=none; b=Je7ppj7FHu3TVQ3rSN4hib9xjko8Rvl5fJfhQegKrKiCd9CgJyy0DUL26PL7m1SoS2FDrYm0K2G9hVo2IxZ8sx/KaDYlQMleRJZ778E2WnkP0+DsGOhq/drLRS2kau4hZ00O/iWmnfiUTR0hZHruHO862JILGfesbnFxo0ftscc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866034; c=relaxed/simple;
	bh=eamI+9McU2W2vcI1L+FYrb7vP3ZETJrGFpWrzhQrH2I=;
	h=Date:To:From:Subject:Message-Id; b=tuVOCFAlZ9u6BfPQIklttIMKDhxri8EtlhQQrwCHmHyZvpa5lNnLPsyszf7NtCEvt8rBeC211g5EXyXX0q9nFg44vsINDVv2zhBBZWNUra+q0r7W0XxlnW/evqA5u0lB6wle54ee76i6x2NoZk1mPMt8ew6rIlSwEX1QOJOuC3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CM2uUdoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CM2uUdoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FA91F000E9;
	Tue,  4 Aug 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785866032;
	bh=X4So+rwSwrkjhHV+tjJKKvHJa0rkq3EAXba0y7VO884=;
	h=Date:To:From:Subject;
	b=CM2uUdoWk0SOrNGvIYYoNPatrNxezBaE1wtFdC9OJ1OuoSXcw1SIp4lvQk85ItlX3
	 kjp1/NghiiabsnFlQjxLhtK4RkALSALy29yy0xh2plx7xZiI05xbaM1QIiyhTlgGl5
	 f87klfBnqIHu4IwailqM4LLHGsXmZb9XnIPPOyms=
Date: Tue, 04 Aug 2026 10:53:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-make-flatmem-depend-on-numa.patch added to mm-new branch
Message-Id: <20260804175352.92FA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/Kconfig: make FLATMEM depend on !NUMA
has been added to the -mm mm-new branch.  Its filename is
     mm-kconfig-make-flatmem-depend-on-numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-make-flatmem-depend-on-numa.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch
mm-sparse-correct-init-section-annotations.patch
mm-kconfig-make-flatmem-depend-on-numa.patch
mm-page_ext-remove-pgdat_page_ext_init.patch

