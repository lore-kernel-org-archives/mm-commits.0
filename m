From: akpm@linux-foundation.org
Subject: + memory-failure-send-right-signal-code-to-correct-thread.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 15:45:12 -0700
Message-ID: <538cfe78.WuTQimBF9EXfgbAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaFBWpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 18:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, otto.g.bruggeman@intel.com, n-horiguchi@ah.jp.nec.com, gong.chen@linux.jf.intel.com, bp@suse.de, andi@firstfloor.org, tony.luck@intel.com

Subject: + memory-failure-send-right-signal-code-to-correct-thread.patch added to -mm tree
To: tony.luck@intel.com,andi@firstfloor.org,bp@suse.de,gong.chen@linux.jf.intel.com,n-horiguchi@ah.jp.nec.com,otto.g.bruggeman@intel.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 15:45:12 -0700


The patch titled
     Subject: mm/memory-failure.c-failure: send right signal code to correct thread
has been added to the -mm tree.  Its filename is
     memory-failure-send-right-signal-code-to-correct-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-failure-send-right-signal-code-to-correct-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-send-right-signal-code-to-correct-thread.patch

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
Subject: mm/memory-failure.c-failure: send right signal code to correct thread

When a thread in a multi-threaded application hits a machine check because
of an uncorrectable error in memory - we want to send the SIGBUS with
si.si_code = BUS_MCEERR_AR to that thread.  Currently we fail to do that
if the active thread is not the primary thread in the process. 
collect_procs() just finds primary threads and this test:

	if ((flags & MF_ACTION_REQUIRED) && t == current) {

will see that the thread we found isn't the current thread and so send a
si.si_code = BUS_MCEERR_AO to the primary (and nothing to the active
thread at this time).

We can fix this by checking whether "current" shares the same mm with the
process that collect_procs() said owned the page.  If so, we send the
SIGBUS to current (with code BUS_MCEERR_AR).

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Otto Bruggeman <otto.g.bruggeman@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Chen Gong <gong.chen@linux.jf.intel.com>
Cc: <stable@vger.kernel.org>	[3.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~memory-failure-send-right-signal-code-to-correct-thread mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-send-right-signal-code-to-correct-thread
+++ a/mm/memory-failure.c
@@ -204,9 +204,9 @@ static int kill_proc(struct task_struct
 #endif
 	si.si_addr_lsb = page_size_order(page) + PAGE_SHIFT;
 
-	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+	if ((flags & MF_ACTION_REQUIRED) && t->mm == current->mm) {
 		si.si_code = BUS_MCEERR_AR;
-		ret = force_sig_info(SIGBUS, &si, t);
+		ret = force_sig_info(SIGBUS, &si, current);
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
_

Patches currently in -mm which might be from tony.luck@intel.com are

hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
memory-failure-send-right-signal-code-to-correct-thread.patch
memory-failure-dont-let-collect_procs-skip-over-processes-for-mf_action_required.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
lib-scatterlist-clean-up-useless-architecture-versions-of-scatterlisth.patch
linux-next.patch

