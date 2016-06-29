From: akpm@linux-foundation.org
Subject: [merged] x86-get-rid-of-superfluous-__gfp_repeat.patch removed
 from -mm tree
Date: Tue, 28 Jun 2016 19:01:51 -0700
Message-ID: <57732c0f.tKzbrP2OWmDoztVR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcF2CBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hpa@zytor.com, luto@kernel.org, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: get rid of superfluous __GFP_REPEAT
has been removed from the -mm tree.  Its filename was
     x86-get-rid-of-superfluous-__gfp_repeat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: x86: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

PGALLOC_GFP uses __GFP_REPEAT but none of the allocation which uses this
flag is for more than order-0.  This means that this flag has never been
actually useful here because it has always been used only for
PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-3-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/espfix_64.c |    2 +-
 arch/x86/mm/pgtable.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/espfix_64.c~x86-get-rid-of-superfluous-__gfp_repeat arch/x86/kernel/espfix_64.c
--- a/arch/x86/kernel/espfix_64.c~x86-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/x86/kernel/espfix_64.c
@@ -57,7 +57,7 @@
 # error "Need more than one PGD for the ESPFIX hack"
 #endif
 
-#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO)
+#define PGALLOC_GFP (GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
 
 /* This contains the *bottom* address of the espfix stack */
 DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
diff -puN arch/x86/mm/pgtable.c~x86-get-rid-of-superfluous-__gfp_repeat arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/x86/mm/pgtable.c
@@ -6,7 +6,7 @@
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
 
-#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
+#define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO
 
 #ifdef CONFIG_HIGHPTE
 #define PGALLOC_USER_GFP __GFP_HIGHMEM
_

Patches currently in -mm which might be from mhocko@suse.com are

arm-get-rid-of-superfluous-__gfp_repeat.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

