From: akpm@linux-foundation.org
Subject: + mm-aout-handle-vm_brk-failures.patch added to -mm tree
Date: Wed, 27 Apr 2016 13:50:45 -0700
Message-ID: <57212625.fZb3VPoMNAWcBLis%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcD0Uur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 16:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de, vbabka@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, aout: handle vm_brk failures
has been added to the -mm tree.  Its filename is
     mm-aout-handle-vm_brk-failures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-aout-handle-vm_brk-failures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-aout-handle-vm_brk-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, aout: handle vm_brk failures

vm_brk is allowed to fail but load_aout_binary simply ignores the error
and happily continues.  I haven't noticed any problem from that in real
life but later patches will make the failure more likely because vm_brk
will become killable (resp.  mmap_sem for write waiting will become
killable) so we should be more careful now.

The error handling should be quite straightforward because there are calls
to vm_mmap which check the error properly already.  The only notable
exception is set_brk which is called after beyond_if label.  But nothing
indicates that we cannot move it above set_binfmt as the two do not depend
on each other and fail before we do set_binfmt and alter reference
counting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_aout.c |   22 +++++++++++++++-------
 fs/binfmt_aout.c          |   11 ++++++++---
 2 files changed, 23 insertions(+), 10 deletions(-)

diff -puN arch/x86/ia32/ia32_aout.c~mm-aout-handle-vm_brk-failures arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~mm-aout-handle-vm_brk-failures
+++ a/arch/x86/ia32/ia32_aout.c
@@ -116,13 +116,13 @@ static struct linux_binfmt aout_format =
 	.min_coredump	= PAGE_SIZE
 };
 
-static void set_brk(unsigned long start, unsigned long end)
+static unsigned long set_brk(unsigned long start, unsigned long end)
 {
 	start = PAGE_ALIGN(start);
 	end = PAGE_ALIGN(end);
 	if (end <= start)
-		return;
-	vm_brk(start, end - start);
+		return start;
+	return vm_brk(start, end - start);
 }
 
 #ifdef CONFIG_COREDUMP
@@ -349,7 +349,10 @@ static int load_aout_binary(struct linux
 #endif
 
 		if (!bprm->file->f_op->mmap || (fd_offset & ~PAGE_MASK) != 0) {
-			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			error = vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			if (IS_ERR_VALUE(error))
+				return error;
+
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 					ex.a_text+ex.a_data);
 			goto beyond_if;
@@ -372,10 +375,13 @@ static int load_aout_binary(struct linux
 		if (error != N_DATADDR(ex))
 			return error;
 	}
+
 beyond_if:
-	set_binfmt(&aout_format);
+	error = set_brk(current->mm->start_brk, current->mm->brk);
+	if (IS_ERR_VALUE(error))
+		return error;
 
-	set_brk(current->mm->start_brk, current->mm->brk);
+	set_binfmt(&aout_format);
 
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
@@ -434,7 +440,9 @@ static int load_aout_library(struct file
 			error_time = jiffies;
 		}
 #endif
-		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		retval = vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		if (IS_ERR_VALUE(retval))
+			goto out;
 
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
diff -puN fs/binfmt_aout.c~mm-aout-handle-vm_brk-failures fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~mm-aout-handle-vm_brk-failures
+++ a/fs/binfmt_aout.c
@@ -297,7 +297,10 @@ static int load_aout_binary(struct linux
 		}
 
 		if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
-			vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			error = vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
+			if (IS_ERR_VALUE(error))
+				return error;
+
 			read_code(bprm->file, N_TXTADDR(ex), fd_offset,
 				  ex.a_text + ex.a_data);
 			goto beyond_if;
@@ -378,8 +381,10 @@ static int load_aout_library(struct file
 			       "N_TXTOFF is not page aligned. Please convert library: %pD\n",
 			       file);
 		}
-		vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
-		
+		retval = vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
+		if (IS_ERR_VALUE(retval))
+			goto out;
+
 		read_code(file, start_addr, N_TXTOFF(ex),
 			  ex.a_text + ex.a_data);
 		retval = 0;
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom_reaper-hide-oom-reaped-tasks-from-oom-killer-more-carefully.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix.patch
mm-make-mmap_sem-for-write-waits-killable-for-mm-syscalls.patch
mm-make-vm_mmap-killable.patch
mm-make-vm_munmap-killable.patch
mm-aout-handle-vm_brk-failures.patch
mm-elf-handle-vm_brk-error.patch
mm-make-vm_brk-killable.patch
mm-proc-make-clear_refs-killable.patch
mm-fork-make-dup_mmap-wait-for-mmap_sem-for-write-killable.patch
ipc-shm-make-shmem-attach-detach-wait-for-mmap_sem-killable.patch
vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable.patch
coredump-make-coredump_wait-wait-for-mmap_sem-for-write-killable.patch
aio-make-aio_setup_ring-killable.patch
exec-make-exec-path-waiting-for-mmap_sem-killable.patch
prctl-make-pr_set_thp_disable-wait-for-mmap_sem-killable.patch
uprobes-wait-for-mmap_sem-for-write-killable.patch
drm-i915-make-i915_gem_mmap_ioctl-wait-for-mmap_sem-killable.patch
drm-radeon-make-radeon_mn_get-wait-for-mmap_sem-killable.patch
drm-amdgpu-make-amdgpu_mn_get-wait-for-mmap_sem-killable.patch

