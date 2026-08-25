Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F97C3750CB
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622948; cv=none; b=n0YTk2nyzRFPte8auBXImow9KiuJ1VRtk5cBRyPIF33Y25+Iu+yEwqSc/FaRaHEc8IsA9tn2Hn+z9ytek3r4vz7uZvTjvGTHLmEfIt/GHApR6OJvfveIc/mG6k0c+u3m0BJaq8B4Y99rFti+e8WdT8bm+2KUDCMHRmWtZaZq6oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622948; c=relaxed/simple;
	bh=TO+OjQn7UqapgujsqSlzPk6EMK44knEx0ubCg0AOL98=;
	h=Date:To:From:Subject:Message-Id; b=nN/0/wPXnViQDgkx1lvE4bmh0KnVl7b1+C9/NRAsK6gB/ZqJPWujfTxtERmdsuATGEIPSl3UvT4ZvW97x4SWNQNBwbt82cjTtVOhHEfvxN8kzrFM4fb8lomb4llNeSlDUyOv9IY3wKE/Hgbl0P1UdoFkSg1SzDU+PM1pIkWfJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWJbq1OX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWJbq1OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB58F1F00A3A;
	Tue, 25 Aug 2026 01:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622946;
	bh=S0XcHpeYFHdgpOqNmj/G8HdBAhn/kK5EhV/Qm0ThZSU=;
	h=Date:To:From:Subject;
	b=tWJbq1OXgiVQtpfR+I6FyvxmdtNHkhaW/PgV7ho5YzjO2gQC2Dlf+BkMNQwd8m/+8
	 xMSna7wVXAli5tEOD9arTFB++9DxhKalVSdQqSLFovOSpKt8Wb0yLCBIH8Al+0u4Py
	 8eZ9vubmEBIpRwfahzrygmCZNHahQqfUSd3Rgp7Q=
Date: Mon, 24 Aug 2026 18:55:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,tony.luck@intel.com,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,nao.horiguchi@gmail.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,linmiaohe@huawei.com,liaohua4@huawei.com,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,bp@alien8.de,apopple@nvidia.com,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-make-memory_failure-select-migration.patch removed from -mm tree
Message-Id: <20260825015546.DB58F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/Kconfig: make MEMORY_FAILURE select MIGRATION
has been removed from the -mm tree.  Its filename was
     mm-kconfig-make-memory_failure-select-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
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


