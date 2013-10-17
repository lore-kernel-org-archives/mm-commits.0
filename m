From: akpm@linux-foundation.org
Subject: [merged]
 pidns-fix-free_pid-to-handle-the-first-fork-failure.patch removed from -mm
 tree
Date: Thu, 17 Oct 2013 11:12:51 -0700
Message-ID: <526028a3.RgSPE62jDLewocVP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge@hallyn.com, ebiederm@xmission.com, oleg@redhat.com

Subject: [merged] pidns-fix-free_pid-to-handle-the-first-fork-failure.patch removed from -mm tree
To: oleg@redhat.com,ebiederm@xmission.com,serge@hallyn.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:51 -0700


The patch titled
     Subject: pidns: fix free_pid() to handle the first fork failure
has been removed from the -mm tree.  Its filename was
     pidns-fix-free_pid-to-handle-the-first-fork-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: pidns: fix free_pid() to handle the first fork failure

"case 0" in free_pid() assumes that disable_pid_allocation() should clear
PIDNS_HASH_ADDING before the last pid goes away.  However this doesn't
happen if the 1st fork() fails to create the child reaper which should
call disable_pid_allocation().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/pid.c~pidns-fix-free_pid-to-handle-the-first-fork-failure kernel/pid.c
--- a/kernel/pid.c~pidns-fix-free_pid-to-handle-the-first-fork-failure
+++ a/kernel/pid.c
@@ -273,6 +273,11 @@ void free_pid(struct pid *pid)
 			 */
 			wake_up_process(ns->child_reaper);
 			break;
+		case PIDNS_HASH_ADDING:
+			/* Handle a fork failure of the first process */
+			WARN_ON(ns->child_reaper);
+			ns->nr_hashed = 0;
+			/* fall through */
 		case 0:
 			schedule_work(&ns->proc_work);
 			break;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
kthread-make-kthread_create-killable.patch
anon_inodefs-forbid-open-via-proc.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
mm-rearrange-madvise-code-to-allow-for-reuse.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

