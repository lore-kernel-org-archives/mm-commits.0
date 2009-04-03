From: akpm@linux-foundation.org
Subject: + proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch added to -mm tree
Date: Thu, 02 Apr 2009 18:41:00 -0700
Message-ID: <200904030141.n331f0j2019739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbZDCBoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 21:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, mikew@google.com, yinghan@google.com


The patch titled
     proc pid maps dont show pgoff of pure anon vmas style fix
has been added to the -mm tree.  Its filename is
     proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

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
Subject: proc pid maps dont show pgoff of pure anon vmas style fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix conding style of proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |    5 +++--
 fs/proc/task_nommu.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup
+++ a/fs/proc/task_mmu.c
@@ -204,6 +204,7 @@ static void show_map_vma(struct seq_file
 	struct file *file = vma->vm_file;
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
+	unsigned long long pgoff = 0;
 	dev_t dev = 0;
 	int len;
 
@@ -211,6 +212,7 @@ static void show_map_vma(struct seq_file
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
@@ -220,8 +222,7 @@ static void show_map_vma(struct seq_file
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
 			flags & VM_MAYSHARE ? 's' : 'p',
-			(!vma->vm_file) ? 0 :
-				((loff_t)vma->vm_pgoff) << PAGE_SHIFT,
+			pgoff,
 			MAJOR(dev), MINOR(dev), ino, &len);
 
 	/*
diff -puN fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup
+++ a/fs/proc/task_nommu.c
@@ -126,6 +126,7 @@ static int nommu_vma_show(struct seq_fil
 	struct file *file;
 	dev_t dev = 0;
 	int flags, len;
+	unsigned long long pgoff = 0;
 
 	flags = vma->vm_flags;
 	file = vma->vm_file;
@@ -134,6 +135,7 @@ static int nommu_vma_show(struct seq_fil
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
+		pgoff = (loff_t)vma->pg_off << PAGE_SHIFT;
 	}
 
 	seq_printf(m,
@@ -144,8 +146,7 @@ static int nommu_vma_show(struct seq_fil
 		   flags & VM_WRITE ? 'w' : '-',
 		   flags & VM_EXEC ? 'x' : '-',
 		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   (!vma->vm_file) ? 0 :
-			(unsigned long long) vma->vm_pgoff << PAGE_SHIFT,
+		   pgoff,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
devcgroup-avoid-using-cgroup_lock.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-show-memcg-information-during-oom.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
memcg-remove-redundant-message-at-swapon.patch
memcg-cleanup-cache_charge.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-cleanup.patch

