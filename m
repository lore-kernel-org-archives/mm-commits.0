From: akpm@linux-foundation.org
Subject: + memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch added to -mm tree
Date: Tue, 01 Jul 2008 15:34:25 -0700
Message-ID: <200807012234.m61MYPIm018149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761524AbYGAWfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 18:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, vgoyal@redhat.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memrlimit: correct mremap and move_vma accounting
has been added to the -mm tree.  Its filename is
     memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: correct mremap and move_vma accounting
From: Balbir Singh <balbir@linux.vnet.ibm.com>

The memrlimit patches did not account for move_vma() since we account for
address space usage in do_mremap().  The code flow actually increments
total_vm twice (once in do_mremap() and once in move_vma()), the excess is
removed in remove_vma_list() via do_munmap().  Since we did not do the
duplicate accounting, the code was seeing the extra uncharge, causing our
accounting to break.  This patch fixes the problem

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/mremap.c~memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting mm/mremap.c
--- a/mm/mremap.c~memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting
+++ a/mm/mremap.c
@@ -174,10 +174,15 @@ static unsigned long move_vma(struct vm_
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	if (memrlimit_cgroup_charge_as(mm, new_len >> PAGE_SHIFT))
+		return -ENOMEM;
+
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
-	if (!new_vma)
+	if (!new_vma) {
+		memrlimit_cgroup_uncharge_as(mm, new_len >> PAGE_SHIFT);
 		return -ENOMEM;
+	}
 
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
 	if (moved_len < old_len) {
@@ -381,6 +386,8 @@ unsigned long do_mremap(unsigned long ad
 		}
 	}
 
+	memrlimit_cgroup_uncharge_as(mm, (new_len - old_len) >> PAGE_SHIFT);
+
 	/*
 	 * We weren't able to just expand or shrink the area,
 	 * we need to create a new one and move it..
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

delay-accounting-maintainer-update.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
distinct-tgid-tid-i-o-statistics.patch
per-task-delay-accounting-add-memory-reclaim-delay.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
gcov-architecture-specific-compile-flag-adjustments-x86_64-fix.patch

