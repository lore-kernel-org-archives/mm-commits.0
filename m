From: akpm@linux-foundation.org
Subject: + fremap-convert-vm_flags-to-unsigned-long-long.patch added to -mm tree
Date: Wed, 13 Apr 2011 14:51:03 -0700
Message-ID: <201104132151.p3DLp3sX002433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab1DMVvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Apr 2011 17:51:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, benh@kernel.crashing.org, dave@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, linux@arm.linux.org.uk


The patch titled
     fremap: convert vm_flags to unsigned long long
has been added to the -mm tree.  Its filename is
     fremap-convert-vm_flags-to-unsigned-long-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fremap: convert vm_flags to unsigned long long
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

unsigned int is completely the wrong type.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/fremap.c~fremap-convert-vm_flags-to-unsigned-long-long mm/fremap.c
--- a/mm/fremap.c~fremap-convert-vm_flags-to-unsigned-long-long
+++ a/mm/fremap.c
@@ -224,7 +224,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 		/*
 		 * drop PG_Mlocked flag for over-mapped range
 		 */
-		unsigned int saved_flags = vma->vm_flags;
+		unsigned long long saved_flags = vma->vm_flags;
 		munlock_vma_pages_range(vma, start, start + size);
 		vma->vm_flags = saved_flags;
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-check-that-we-have-the-right-vma-in-__access_remote_vm.patch
vmscan-all_unreclaimable-use-zone-all_unreclaimable-as-a-name.patch
oom-kill-remove-boost_dying_task_prio.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

