Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF07424664
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 19:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786649549; cv=none; b=nn0ZuoLMchzbInNRCkZvsABhDudciU1nfSVDPBDN5ovWax5jpOoqTXrHDTs2HX24NaNc8Oo4c+jQyvsrUkOEntPKiFldxIOqCWg5S3Irby6DeYTT/qs+BESSlVuNwZS0S6K9ySeCimzsDhunj2HPoOIAgVtw43JWtVhp5m5g2bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786649549; c=relaxed/simple;
	bh=1Ucs20uOqW473XeRpQcbm5/lBy74Rc2pA9vg++YEOOg=;
	h=Date:To:From:Subject:Message-Id; b=N+w3B6LqMo5IIHAeGcLNg0GTups/LD1i1RXdSU3GtGjQ0+axnWBEEnPIYdj08AAlEyOv/Ijte2JJSO1GLwL7Jx2bIUSS8UV1c6vHd0CvM9b4ukrPVPMCdIQBSw0f1K5eR1sJjCImxuN67qTIs3nnpsP7hFET+54hTQ6rTEQvtuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BqQGH/5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BqQGH/5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46861F000E9;
	Thu, 13 Aug 2026 19:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786649547;
	bh=P7LAz3v+9Bl6X6tQI3L91IKpHoaeUP2touV84R49XoE=;
	h=Date:To:From:Subject;
	b=BqQGH/5smcoyNz90eH7CO5OkVCg0Qyb/qPo8i5wOFy0194JIvgXNjq2/4CfvtsdoJ
	 CTMn5xZ4cYEWxRAB4ntendBR0jRWJ7esGCTgyRLQcNOOD59wsqMhbLaAVjLFyQvhQu
	 uEDuislHrzjPUHOV4LAUDDZFWc9bgmbrjRphIQpc=
Date: Thu, 13 Aug 2026 12:32:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,nao.horiguchi@gmail.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,linmiaohe@huawei.com,liaohua4@huawei.com,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,bp@alien8.de,apopple@nvidia.com,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-make-memory_failure-select-migration.patch added to mm-new branch
Message-Id: <20260813193227.C46861F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/Kconfig: make MEMORY_FAILURE select MIGRATION
has been added to the -mm mm-new branch.  Its filename is
     mm-kconfig-make-memory_failure-select-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-make-memory_failure-select-migration.patch

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
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: mm/Kconfig: make MEMORY_FAILURE select MIGRATION
Date: Thu, 13 Aug 2026 21:49:16 +0800

For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
CMA and huge pages is a quite common scenario.  In this scenario, the
demand for contiguous physical memory allocation is very low.  To reduce
the kernel image size, some devices disable the compaction.  However,
their SoCs do support DDR ECC, meaning that memory-failure may be needed.

Migration is very useful for soft_offline_page() in memory-failure, which
may be triggered by correctable memory errors.  Most anonymous and
file-mapped faulty pages can be migrated to other healthy pages.

Currently, MEMORY_FAILURE does not explicitly select MIGRATION.  When
COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.

Make MEMORY_FAILURE select MIGRATION to handle this situation.

Link: https://lore.kernel.org/20260813134916.292733-1-xieyuanbin1@huawei.com
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: liaohua <liaohua4@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yuanbin Xie <xieyuanbin1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-kconfig-make-memory_failure-select-migration
+++ a/mm/Kconfig
@@ -767,6 +767,7 @@ config MEMORY_FAILURE
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	select INTERVAL_TREE
+	select MIGRATION
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
_

Patches currently in -mm which might be from xieyuanbin1@huawei.com are

mm-kconfig-make-memory_failure-select-migration.patch

