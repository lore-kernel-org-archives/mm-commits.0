From: akpm@linux-foundation.org
Subject: +
 memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch added to -mm tree
Date: Mon, 02 Jun 2014 15:45:13 -0700
Message-ID: <538cfe79.mQTEFX/3f03RFO3p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaFBWpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 18:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, n-horiguchi@ah.jp.nec.com, gong.chen@linux.jf.intel.com, bp@suse.de, andi@firstfloor.org, tony.luck@intel.com

Subject: + memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch added to -mm tree
To: tony.luck@intel.com,andi@firstfloor.org,bp@suse.de,gong.chen@linux.jf.intel.com,n-horiguchi@ah.jp.nec.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 15:45:13 -0700


The patch titled
     Subject: mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED
has been added to the -mm tree.  Its filename is
     memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

When Linux sees an "action optional" machine check (where h/w has reported
an error that is not in the current execution path) we generally do not
want to signal a process, since most processes do not have a SIGBUS
handler - we'd just prematurely terminate the process for a problem that
they might never actually see.

task_early_kill() decides whether to consider a process - and it checks
whether this specific process has been marked for early signals with
"prctl", or if the system administrator has requested early signals for
all processes using /proc/sys/vm/memory_failure_early_kill.

But for MF_ACTION_REQUIRED case we must not defer.  The error is in the
execution path of the current thread so we must send the SIGBUS
immediatley.

Fix by passing a flag argument through collect_procs*() to
task_early_kill() so it knows whether we can defer or must take action.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN mm/memory-failure.c~memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required
+++ a/mm/memory-failure.c
@@ -380,10 +380,12 @@ static void kill_procs(struct list_head
 	}
 }
 
-static int task_early_kill(struct task_struct *tsk)
+static int task_early_kill(struct task_struct *tsk, int force_early)
 {
 	if (!tsk->mm)
 		return 0;
+	if (force_early)
+		return 1;
 	if (tsk->flags & PF_MCE_PROCESS)
 		return !!(tsk->flags & PF_MCE_EARLY);
 	return sysctl_memory_failure_early_kill;
@@ -393,7 +395,7 @@ static int task_early_kill(struct task_s
  * Collect processes when the error hit an anonymous page.
  */
 static void collect_procs_anon(struct page *page, struct list_head *to_kill,
-			      struct to_kill **tkc)
+			      struct to_kill **tkc, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -409,7 +411,7 @@ static void collect_procs_anon(struct pa
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 
-		if (!task_early_kill(tsk))
+		if (!task_early_kill(tsk, force_early))
 			continue;
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
 					       pgoff, pgoff) {
@@ -428,7 +430,7 @@ static void collect_procs_anon(struct pa
  * Collect processes when the error hit a file mapped page.
  */
 static void collect_procs_file(struct page *page, struct list_head *to_kill,
-			      struct to_kill **tkc)
+			      struct to_kill **tkc, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -439,7 +441,7 @@ static void collect_procs_file(struct pa
 	for_each_process(tsk) {
 		pgoff_t pgoff = page_pgoff(page);
 
-		if (!task_early_kill(tsk))
+		if (!task_early_kill(tsk, force_early))
 			continue;
 
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
@@ -465,7 +467,8 @@ static void collect_procs_file(struct pa
  * First preallocate one tokill structure outside the spin locks,
  * so that we can kill at least one process reasonably reliable.
  */
-static void collect_procs(struct page *page, struct list_head *tokill)
+static void collect_procs(struct page *page, struct list_head *tokill,
+				int force_early)
 {
 	struct to_kill *tk;
 
@@ -476,9 +479,9 @@ static void collect_procs(struct page *p
 	if (!tk)
 		return;
 	if (PageAnon(page))
-		collect_procs_anon(page, tokill, &tk);
+		collect_procs_anon(page, tokill, &tk, force_early);
 	else
-		collect_procs_file(page, tokill, &tk);
+		collect_procs_file(page, tokill, &tk, force_early);
 	kfree(tk);
 }
 
@@ -963,7 +966,7 @@ static int hwpoison_user_mappings(struct
 	 * there's nothing that can be done.
 	 */
 	if (kill)
-		collect_procs(ppage, &tokill);
+		collect_procs(ppage, &tokill, flags & MF_ACTION_REQUIRED);
 
 	ret = try_to_unmap(ppage, ttu);
 	if (ret != SWAP_SUCCESS)
_

Patches currently in -mm which might be from tony.luck@intel.com are

hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
memory-failure-send-right-signal-code-to-correct-thread.patch
memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
linux-next.patch

