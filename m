Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45E412F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619836; cv=none; b=O8GNjAaxxBKgH8FfQQSHsWmbebmalcknDrUCVRDlGkFGn/+e3dARJimAezHOlnc81GHm8V3wncIiqx1yW+8CZNfIOiAT4HfWr6wGpLlkdyOQ2AHxPhX3rrr0Lu26zbFvZgP2ej7jNJKNB4Bch8E/lqdEyGXllEgnYzcKmoEsvAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619836; c=relaxed/simple;
	bh=V7xJ+RePizDrKKKtJiXlZIX26EuYR7qriqE4Fm5jzbE=;
	h=Date:To:From:Subject:Message-Id; b=D6saLlfUaiV8HfrlyQXCn5wLR7pAdHjYiSvDC1wPIHx/IqOm1yl1ZxA5EllWizYEVwV75DD23zsG0a/rZ1y3TfaF0e72syHY6tmqj0BJLm7ClKgpeNRnAuPy511d5rSPexpgU1jEoszRgIHOdMspJvtpnkE48fBsTJq0NSrVNJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MmqEDpHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MmqEDpHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78438C4CEDD;
	Sat, 22 Mar 2025 05:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619836;
	bh=V7xJ+RePizDrKKKtJiXlZIX26EuYR7qriqE4Fm5jzbE=;
	h=Date:To:From:Subject:From;
	b=MmqEDpHNedm6i9CTiu1qy6ax5RC/ZUj4iAfBgsmw76yu+KeMai8QpFk+YxV6v3gEc
	 0NAEMPqjR5eltc2hGtWa1EFuEMsgGOo0YgI1DkNQ+7QUT2O0uQQBUffOvsYh5I48R6
	 DkYRYejQF6nBQouLUHcOHWvOtEMk41jl0t1wttjE=
Date: Fri, 21 Mar 2025 22:03:55 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,mhklinux@outlook.com,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] meminfo-add-a-per-node-counter-for-balloon-drivers.patch removed from -mm tree
Message-Id: <20250322050356.78438C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: meminfo: add a per node counter for balloon drivers
has been removed from the -mm tree.  Its filename was
     meminfo-add-a-per-node-counter-for-balloon-drivers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: meminfo: add a per node counter for balloon drivers
Date: Fri, 14 Mar 2025 15:37:54 -0600

Patch series "track memory used by balloon drivers", v2.

This series introduces a way to track memory used by balloon drivers.

Add a NR_BALLOON_PAGES counter to track how many pages are reclaimed by
the balloon drivers.  First add the accounting, then updates the balloon
drivers (virtio, Hyper-V, VMware, Pseries-cmm, and Xen) to maintain this
counter.  The virtio, Vmware, and pseries-cmm balloon drivers utilize the
balloon_compaction interface to allocate and free balloon pages.  Other
balloon drivers will have to maintain this counter manually.

This makes the information visible in memory reporting interfaces like
/proc/meminfo, show_mem, and OOM reporting.

This provides admins visibility into their VM balloon sizes without
requiring different virtualization tooling.  Furthermore, this information
is helpful when debugging an OOM inside a VM.


This patch (of 4):

Add NR_BALLOON_PAGES counter to track memory used by balloon drivers and
expose it through /proc/meminfo and other memory reporting interfaces.

[npache@redhat.com: document Balloon Meminfo entry]
  Link: https://lkml.kernel.org/r/a0315ccf-f244-460e-8643-fd7388724fe5@redhat.com
Link: https://lkml.kernel.org/r/20250314213757.244258-1-npache@redhat.com
Link: https://lkml.kernel.org/r/20250314213757.244258-2-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 fs/proc/meminfo.c                  |    2 ++
 include/linux/mmzone.h             |    1 +
 mm/show_mem.c                      |    4 +++-
 mm/vmstat.c                        |    1 +
 5 files changed, 10 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~meminfo-add-a-per-node-counter-for-balloon-drivers
+++ a/Documentation/filesystems/proc.rst
@@ -1081,6 +1081,7 @@ Example output. You may not have all of
     FilePmdMapped:         0 kB
     CmaTotal:              0 kB
     CmaFree:               0 kB
+    Balloon:               0 kB
     HugePages_Total:       0
     HugePages_Free:        0
     HugePages_Rsvd:        0
@@ -1255,6 +1256,8 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
+Balloon
+              Memory returned to Host by VM Balloon Drivers
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
 DirectMap4k, DirectMap2M, DirectMap1G
--- a/fs/proc/meminfo.c~meminfo-add-a-per-node-counter-for-balloon-drivers
+++ a/fs/proc/meminfo.c
@@ -162,6 +162,8 @@ static int meminfo_proc_show(struct seq_
 	show_val_kb(m, "Unaccepted:     ",
 		    global_zone_page_state(NR_UNACCEPTED));
 #endif
+	show_val_kb(m, "Balloon:        ",
+		    global_node_page_state(NR_BALLOON_PAGES));
 
 	hugetlb_report_meminfo(m);
 
--- a/include/linux/mmzone.h~meminfo-add-a-per-node-counter-for-balloon-drivers
+++ a/include/linux/mmzone.h
@@ -224,6 +224,7 @@ enum node_stat_item {
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
+	NR_BALLOON_PAGES,
 	NR_VM_NODE_STAT_ITEMS
 };
 
--- a/mm/show_mem.c~meminfo-add-a-per-node-counter-for-balloon-drivers
+++ a/mm/show_mem.c
@@ -260,6 +260,7 @@ static void show_free_areas(unsigned int
 			" pagetables:%lukB"
 			" sec_pagetables:%lukB"
 			" all_unreclaimable? %s"
+			" Balloon:%lukB"
 			"\n",
 			pgdat->node_id,
 			K(node_page_state(pgdat, NR_ACTIVE_ANON)),
@@ -285,7 +286,8 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES));
+			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES),
+			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
 	for_each_populated_zone(zone) {
--- a/mm/vmstat.c~meminfo-add-a-per-node-counter-for-balloon-drivers
+++ a/mm/vmstat.c
@@ -1277,6 +1277,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	"nr_hugetlb",
 #endif
+	"nr_balloon_pages",
 	/* system-wide enum vm_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
_

Patches currently in -mm which might be from npache@redhat.com are


