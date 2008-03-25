From: akpm@linux-foundation.org
Subject: + memcgroup-fix-spurious-ebusy-on-memory-cgroup-removal.patch added to -mm tree
Date: Mon, 24 Mar 2008 22:54:27 -0700
Message-ID: <200803250554.m2P5sRxe011884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYCYFzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Mar 2008 01:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yamamoto@valinux.co.jp, balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     memcgroup: fix spurious EBUSY on memory cgroup removal
has been added to the -mm tree.  Its filename is
     memcgroup-fix-spurious-ebusy-on-memory-cgroup-removal.patch

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
Subject: memcgroup: fix spurious EBUSY on memory cgroup removal
From: YAMAMOTO Takashi <yamamoto@valinux.co.jp>

Call mm_free_cgroup earlier.  Otherwise a reference due to lazy mm switching
can prevent cgroup removal.

Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~memcgroup-fix-spurious-ebusy-on-memory-cgroup-removal kernel/fork.c
--- a/kernel/fork.c~memcgroup-fix-spurious-ebusy-on-memory-cgroup-removal
+++ a/kernel/fork.c
@@ -394,7 +394,6 @@ void __mmdrop(struct mm_struct *mm)
 {
 	BUG_ON(mm == &init_mm);
 	mm_free_pgd(mm);
-	mm_free_cgroup(mm);
 	destroy_context(mm);
 	free_mm(mm);
 }
@@ -416,6 +415,7 @@ void mmput(struct mm_struct *mm)
 			spin_unlock(&mmlist_lock);
 		}
 		put_swap_token(mm);
+		mm_free_cgroup(mm);
 		mmdrop(mm);
 	}
 }
_

Patches currently in -mm which might be from yamamoto@valinux.co.jp are

memcgroup-fix-spurious-ebusy-on-memory-cgroup-removal.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time-fix-boot-option-parsing.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
memcgroup-move-memory-controller-allocations-to-their-own-slabs.patch
procfs-task-exe-symlink-fix-3.patch

