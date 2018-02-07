From: akpm@linux-foundation.org
Subject: + fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch added to -mm tree
Date: Wed, 07 Feb 2018 14:47:48 -0800
Message-ID: <5a7b8214.0F79vaFp5zHyK8dG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeBGWru (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 17:47:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#8: 
(before eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE"))

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#15: 
further from the stack (eab09532d400 and later by c715b72c1ba4 ("mm:

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#17: 
stack consumption early during execve fully stopped by da029c11e6b1

WARNING: 'segement' may be misspelled - perhaps 'segment'?
#64: FILE: arch/metag/kernel/process.c:421:
+		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",

ERROR: "(foo*)" should be "(foo *)"
#65: FILE: arch/metag/kernel/process.c:422:
+				task_pid_nr(current), tsk->comm, (void*)addr);

WARNING: 'segement' may be misspelled - perhaps 'segment'?
#78: FILE: fs/binfmt_elf.c:381:
+		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",

WARNING: line over 80 characters
#79: FILE: fs/binfmt_elf.c:382:
+				task_pid_nr(current), current->comm, (void*)addr);

ERROR: "(foo*)" should be "(foo *)"
#79: FILE: fs/binfmt_elf.c:382:
+				task_pid_nr(current), current->comm, (void*)addr);

total: 5 errors, 3 warnings, 60 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/fs-elf-drop-map_fixed-usage-from-elf_map.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/process.c |    4 ++--
 fs/binfmt_elf.c             |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes arch/metag/kernel/process.c
--- a/arch/metag/kernel/process.c~fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes
+++ a/arch/metag/kernel/process.c
@@ -418,8 +418,8 @@ unsigned long __metag_elf_map(struct fil
 		map_addr = vm_mmap(filep, addr, size, prot, type, off);
 
 	if ((type & MAP_FIXED_NOREPLACE) && BAD_ADDR(map_addr))
-		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",
-				task_pid_nr(current), tsk->comm, (void*)addr);
+		pr_info("%d (%s): Uhuuh, elf segment at %p requested but the memory is mapped already\n",
+				task_pid_nr(current), tsk->comm, (void *)addr);
 
 	if (!BAD_ADDR(map_addr) && tcm_tag != TCM_INVALID_TAG) {
 		struct tcm_allocation *tcm;
diff -puN fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes
+++ a/fs/binfmt_elf.c
@@ -378,8 +378,9 @@ static unsigned long elf_map(struct file
 		map_addr = vm_mmap(filep, addr, size, prot, type, off);
 
 	if ((type & MAP_FIXED_NOREPLACE) && BAD_ADDR(map_addr))
-		pr_info("%d (%s): Uhuuh, elf segement at %p requested but the memory is mapped already\n",
-				task_pid_nr(current), current->comm, (void*)addr);
+		pr_info("%d (%s): Uhuuh, elf segment at %p requested but the memory is mapped already\n",
+				task_pid_nr(current), current->comm,
+				(void *)addr);
 
 	return(map_addr);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

