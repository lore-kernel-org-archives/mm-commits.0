From: akpm@linux-foundation.org
Subject: + procfs-convert-vm_flags-to-unsigned-long-long.patch added to -mm tree
Date: Wed, 13 Apr 2011 14:51:05 -0700
Message-ID: <201104132151.p3DLp5KO002436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933052Ab1DMVvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Apr 2011 17:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, benh@kernel.crashing.org, dave@linux.vnet.ibm.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, linux@arm.linux.org.uk


The patch titled
     procfs: convert vm_flags to unsigned long long
has been added to the -mm tree.  Its filename is
     procfs-convert-vm_flags-to-unsigned-long-long.patch

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
Subject: procfs: convert vm_flags to unsigned long long
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

int is a crazy mistake. ;-)

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

 fs/proc/task_mmu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~procfs-convert-vm_flags-to-unsigned-long-long fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-convert-vm_flags-to-unsigned-long-long
+++ a/fs/proc/task_mmu.c
@@ -211,7 +211,7 @@ static void show_map_vma(struct seq_file
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
-	int flags = vma->vm_flags;
+	unsigned long long vm_flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start;
@@ -234,10 +234,10 @@ static void show_map_vma(struct seq_file
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
 			vma->vm_end,
-			flags & VM_READ ? 'r' : '-',
-			flags & VM_WRITE ? 'w' : '-',
-			flags & VM_EXEC ? 'x' : '-',
-			flags & VM_MAYSHARE ? 's' : 'p',
+			vm_flags & VM_READ ? 'r' : '-',
+			vm_flags & VM_WRITE ? 'w' : '-',
+			vm_flags & VM_EXEC ? 'x' : '-',
+			vm_flags & VM_MAYSHARE ? 's' : 'p',
 			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
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

