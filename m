From: akpm@linux-foundation.org
Subject: + x86-fix-the-argument-passed-to-sync_global_pgds.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:08:55 -0800
Message-ID: <20121127200856.2860282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:43810 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2K0UI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:08:57 -0500
Received: by mail-ye0-f202.google.com with SMTP id m11so868208yen.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:08:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, akpm@linux-foundation.org, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, rientjes@google.com, tglx@linutronix.de


The patch titled
     Subject: x86: fix the argument passed to sync_global_pgds()
has been added to the -mm tree.  Its filename is
     x86-fix-the-argument-passed-to-sync_global_pgds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: x86: fix the argument passed to sync_global_pgds()

The address range of sync_global_pgds() should be [start, end], but we
pass [start, end) to this function.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86-fix-the-argument-passed-to-sync_global_pgds arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86-fix-the-argument-passed-to-sync_global_pgds
+++ a/arch/x86/mm/init_64.c
@@ -605,7 +605,7 @@ kernel_physical_mapping_init(unsigned lo
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(addr, end);
+		sync_global_pgds(addr, end - 1);
 
 	__flush_tlb_all();
 
@@ -977,7 +977,7 @@ vmemmap_populate(struct page *start_page
 		}
 
 	}
-	sync_global_pgds((unsigned long)start_page, end);
+	sync_global_pgds((unsigned long)start_page, end - 1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

mm-vmemmap-fix-wrong-use-of-virt_to_page.patch
linux-next.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-fix-nr_free_pages-mismatch-fix.patch
numa-convert-static-memory-to-dynamically-allocated-memory-for-per-node-device.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
memory-hotplug-mm-sparsec-clear-the-memory-to-store-struct-page.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-memory_hotplugc-update-start_pfn-in-zone-and-pg_data-when-spanned_pages-==-0.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

