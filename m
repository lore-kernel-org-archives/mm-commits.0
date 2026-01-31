Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501720CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898279; cv=none; b=EMv3cnNwMidIjab88vfx+5ruv/pwYPaUKUGocj5AUNv13oyoUbNjEznbLThMqbT64VnEzKXWBOEZFH5WYjb70zQqnznOivUhPcRg0YSzTma52zSLhiyjDozDhzXyiVM2iaGTPsfGezs/+lMQcgdiz2G6Qz6fSIAgOtUUawae4Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898279; c=relaxed/simple;
	bh=LXq5sdbeE2NVYNkWzmzFIBuOYPGcrevTT8vbdIE/LLU=;
	h=Date:To:From:Subject:Message-Id; b=aGSZymmAGl2BL3eaUsAvHlkKx6cHufWpZDs22kFLswdYyIJY0v5YB3c9WJK6YaTCF4H4my0yTne5D1hMhO3yATlLUk+oF9gMovjAoaFwY4EZShfNY2O2pb/GePECJrCJ1COt83y/Agu1y99R42uMeXaAo9kdxMTX8dVCVI6SzlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZNB+tWeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZNB+tWeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D394C4CEF1;
	Sat, 31 Jan 2026 22:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898279;
	bh=LXq5sdbeE2NVYNkWzmzFIBuOYPGcrevTT8vbdIE/LLU=;
	h=Date:To:From:Subject:From;
	b=ZNB+tWeXGzs6z4NM2TUhPuV73G0wP5NPFfMU6ViT7xJGW9jCsp4VkpjREpLQtjk0n
	 PUEkEDXV2gEMCVOM4Z1GpJjUE5vfUeCjPYfk9JxrIJWP5x5zyoFTOQNAai0Vr5b5gO
	 DbVH4D+D46EtM2TIgSjCiw50QytkYESHNV6VrkKk=
Date: Sat, 31 Jan 2026 14:24:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-config_memory_balloon-config_balloon.patch removed from -mm tree
Message-Id: <20260131222439.6D394C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
has been removed from the -mm tree.  Its filename was
     mm-rename-config_memory_balloon-config_balloon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
Date: Tue, 20 Jan 2026 00:01:31 +0100

Let's make it consistent with the naming of the files but also with the
naming of CONFIG_BALLOON_MIGRATION.

While at it, add a "/* CONFIG_BALLOON */".

Link: https://lkml.kernel.org/r/20260119230133.3551867-24-david@kernel.org
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

 arch/powerpc/platforms/pseries/Kconfig |    2 +-
 drivers/misc/Kconfig                   |    2 +-
 drivers/virtio/Kconfig                 |    2 +-
 include/linux/vm_event_item.h          |    4 ++--
 mm/Kconfig                             |    4 ++--
 mm/Makefile                            |    2 +-
 mm/vmstat.c                            |    4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/powerpc/platforms/pseries/Kconfig~mm-rename-config_memory_balloon-config_balloon
+++ a/arch/powerpc/platforms/pseries/Kconfig
@@ -120,7 +120,7 @@ config PPC_SMLPAR
 config CMM
 	tristate "Collaborative memory management"
 	depends on PPC_SMLPAR
-	select MEMORY_BALLOON
+	select BALLOON
 	default y
 	help
 	  Select this option, if you want to enable the kernel interface
--- a/drivers/misc/Kconfig~mm-rename-config_memory_balloon-config_balloon
+++ a/drivers/misc/Kconfig
@@ -410,7 +410,7 @@ config DS1682
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
 	depends on VMWARE_VMCI && X86 && HYPERVISOR_GUEST
-	select MEMORY_BALLOON
+	select BALLOON
 	help
 	  This is VMware physical memory management driver which acts
 	  like a "balloon" that can be inflated to reclaim physical pages
--- a/drivers/virtio/Kconfig~mm-rename-config_memory_balloon-config_balloon
+++ a/drivers/virtio/Kconfig
@@ -112,7 +112,7 @@ config VIRTIO_PMEM
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver"
 	depends on VIRTIO
-	select MEMORY_BALLOON
+	select BALLOON
 	select PAGE_REPORTING
 	help
 	 This driver supports increasing and decreasing the amount
--- a/include/linux/vm_event_item.h~mm-rename-config_memory_balloon-config_balloon
+++ a/include/linux/vm_event_item.h
@@ -122,13 +122,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
+#ifdef CONFIG_BALLOON
 		BALLOON_INFLATE,
 		BALLOON_DEFLATE,
 #ifdef CONFIG_BALLOON_MIGRATION
 		BALLOON_MIGRATE,
 #endif /* CONFIG_BALLOON_MIGRATION */
-#endif
+#endif /* CONFIG_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
--- a/mm/Kconfig~mm-rename-config_memory_balloon-config_balloon
+++ a/mm/Kconfig
@@ -593,7 +593,7 @@ config SPLIT_PMD_PTLOCKS
 
 #
 # support for memory balloon
-config MEMORY_BALLOON
+config BALLOON
 	bool
 
 #
@@ -601,7 +601,7 @@ config MEMORY_BALLOON
 config BALLOON_MIGRATION
 	bool "Allow for balloon memory migration"
 	default y
-	depends on MIGRATION && MEMORY_BALLOON
+	depends on MIGRATION && BALLOON
 	help
 	  Allow for migration of pages inflated in a memory balloon such that
 	  they can be allocated from memory areas only available for movable
--- a/mm/Makefile~mm-rename-config_memory_balloon-config_balloon
+++ a/mm/Makefile
@@ -122,7 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
+obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
--- a/mm/vmstat.c~mm-rename-config_memory_balloon-config_balloon
+++ a/mm/vmstat.c
@@ -1419,13 +1419,13 @@ const char * const vmstat_text[] = {
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
 #endif
-#ifdef CONFIG_MEMORY_BALLOON
+#ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
 	[I(BALLOON_DEFLATE)]			= "balloon_deflate",
 #ifdef CONFIG_BALLOON_MIGRATION
 	[I(BALLOON_MIGRATE)]			= "balloon_migrate",
 #endif /* CONFIG_BALLOON_MIGRATION */
-#endif /* CONFIG_MEMORY_BALLOON */
+#endif /* CONFIG_BALLOON */
 #ifdef CONFIG_DEBUG_TLBFLUSH
 	[I(NR_TLB_REMOTE_FLUSH)]		= "nr_tlb_remote_flush",
 	[I(NR_TLB_REMOTE_FLUSH_RECEIVED)]	= "nr_tlb_remote_flush_received",
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

