Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B751B667
	for <mm-commits@vger.kernel.org>; Sat, 15 Mar 2025 01:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742000602; cv=none; b=ZgQHw+492hjWtr4+fgSbv+LTHZTNIE6766uJ+LY6KSAj8RGJxoELBFGRXxZ8ubTtOuTPMkzW97Ba5ful6bZj4qDW/o4/crWUvHQMgYRjeBjG5fowkIZrOg5OqxZjfGebl3sgtbWE9PmvAIDR9fflsAS7kdsO0EudlFMEDcyHHtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742000602; c=relaxed/simple;
	bh=VLspXZZa7e2uSErG9P4EDxoe5/LLtdFUOqUvfCWsXTE=;
	h=Date:To:From:Subject:Message-Id; b=ehVmbGbg4d4jTql2AMF8nTvreqRDlU2us3t3JqnE6meTx5ZmTkPCTRcr1Pn6UgKC+Gxt0GobE1C9TwOfxI5p5RD7L0/5Abp6RrMZnhHw4Iq92eOtn93zY2B98gTfluR9EfMZW6upMvdIg5FE+/wSLDPgC9O9o2JmkHbZsyoQpig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vsjs2WVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vsjs2WVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657C0C4CEE3;
	Sat, 15 Mar 2025 01:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742000601;
	bh=VLspXZZa7e2uSErG9P4EDxoe5/LLtdFUOqUvfCWsXTE=;
	h=Date:To:From:Subject:From;
	b=Vsjs2WVZ3SvIppcEXV8MBO4Ilt2CLDuU02DqRWJSP0MP19IHhNs3BePwj7HfcntNd
	 YItRPncpLm85TGZKvBHjkQIqLMr/o5E508WEUEkazomgywY0QCzMM7wJIi1CLP9D0V
	 DkYqUy6jIcgGi7ef24aZFmSc4UiU1BLZB6hUOcDo=
Date: Fri, 14 Mar 2025 18:03:20 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + meminfo-add-a-per-node-counter-for-balloon-drivers.patch added to mm-unstable branch
Message-Id: <20250315010321.657C0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: meminfo: add a per node counter for balloon drivers
has been added to the -mm mm-unstable branch.  Its filename is
     meminfo-add-a-per-node-counter-for-balloon-drivers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/meminfo-add-a-per-node-counter-for-balloon-drivers.patch

This patch will later appear in the mm-unstable branch at
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

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c      |    2 ++
 include/linux/mmzone.h |    1 +
 mm/show_mem.c          |    4 +++-
 mm/vmstat.c            |    1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

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

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch

