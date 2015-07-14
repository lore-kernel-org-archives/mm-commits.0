From: akpm@linux-foundation.org
Subject: + mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
 added to -mm tree
Date: Tue, 14 Jul 2015 15:54:24 -0700
Message-ID: <55a59320.evYr6igE4VN8WHmi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbbGNWyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@suse.cz, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not panic for oom kills triggered from sysrq
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: do not panic for oom kills triggered from sysrq

Sysrq+f is used to kill a process either for debug or when the VM is
otherwise unresponsive.

It is not intended to trigger a panic when no process may be killed.

Avoid panicking the system for sysrq+f when no processes are killed.

Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    3 ++-
 mm/oom_kill.c           |    7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN Documentation/sysrq.txt~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq
+++ a/Documentation/sysrq.txt
@@ -75,7 +75,8 @@ On all -  write a character to /proc/sys
 
 'e'     - Send a SIGTERM to all processes, except for init.
 
-'f'	- Will call oom_kill to kill a memory hog process.
+'f'	- Will call the oom killer to kill a memory hog process, but do not
+	  panic if nothing can be killed.
 
 'g'	- Used by kgdb (kernel debugger)
 
diff -puN mm/oom_kill.c~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq
+++ a/mm/oom_kill.c
@@ -607,6 +607,9 @@ void check_panic_on_oom(struct oom_contr
 		if (constraint != CONSTRAINT_NONE)
 			return;
 	}
+	/* Do not panic for oom kills triggered by sysrq */
+	if (oc->order == -1)
+		return;
 	dump_header(oc, NULL, memcg);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
@@ -686,11 +689,11 @@ bool out_of_memory(struct oom_control *o
 
 	p = select_bad_process(oc, &points, totalpages);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!p) {
+	if (!p && oc->order != -1) {
 		dump_header(oc, NULL, NULL);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (p != (void *)-1UL) {
+	if (p && p != (void *)-1UL) {
 		oom_kill_process(oc, p, points, totalpages, NULL,
 				 "Out of memory");
 		killed = 1;
_

Patches currently in -mm which might be from rientjes@google.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch
mm-slub-move-slab-initialization-into-irq-enabled-region.patch
mm-slub-fix-slab-double-free-in-case-of-duplicate-sysfs-filename.patch
mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
hugetlb-make-the-function-vma_shareable-bool.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-improve-__gfp_noretry-comment-based-on-implementation.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
mm-oom-organize-oom-context-into-struct.patch
mm-oom-pass-an-oom-order-of-1-when-triggered-by-sysrq.patch
mm-oom-do-not-panic-for-oom-kills-triggered-from-sysrq.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch

