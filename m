From: akpm@linux-foundation.org
Subject: + tmpfs-implement-numa-node-interleaving-fix.patch added to -mm tree
Date: Thu, 31 May 2012 13:25:54 -0700
Message-ID: <20120531202554.A24B2A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52244 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab2EaUZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 16:25:56 -0400
Received: by wgbdt11 with SMTP id dt11so78647wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 13:25:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, hughd@google.com, lee.schermerhorn@hp.com, npiggin@gmail.com, nzimmer@sgi.com, riel@redhat.com


The patch titled
     Subject: tmpfs-implement-numa-node-interleaving-fix
has been added to the -mm tree.  Its filename is
     tmpfs-implement-numa-node-interleaving-fix.patch

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
Subject: tmpfs-implement-numa-node-interleaving-fix

add comment

Cc: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nathan T Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-implement-numa-node-interleaving-fix include/linux/shmem_fs.h
diff -puN mm/shmem.c~tmpfs-implement-numa-node-interleaving-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-numa-node-interleaving-fix
+++ a/mm/shmem.c
@@ -927,9 +927,12 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
 	/*
-	 * alloc_page_vma() will drop the shared policy reference
+	 * alloc_page_vma() will drop the shared policy reference.
+	 *
+	 * To avoid allocating all tmpfs pages on node 0, we fake up a virtual
+	 * address based on this file's predetermined preferred node.
 	 */
-	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_
Subject: Subject: tmpfs-implement-numa-node-interleaving-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch

