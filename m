From: akpm@linux-foundation.org
Subject: +
 seq_read-info-message-about-buggy-next-functions-fix.patch added to -mm
 tree
Date: Mon, 02 Mar 2020 12:42:26 -0800
Message-ID: <20200302204226.9w1wyuwgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCBUm1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 15:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, viro@zeniv.linux.org.uk, vvs@virtuozzo.com


The patch titled
     Subject: seq_read-info-message-about-buggy-next-functions-fix
has been added to the -mm tree.  Its filename is
     seq_read-info-message-about-buggy-next-functions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_read-info-message-about-buggy-next-functions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_read-info-message-about-buggy-next-functions-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_read-info-message-about-buggy-next-functions-fix

s/pr_info/pr_info_ratelimited/, per Qian Cai

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/seq_file.c~seq_read-info-message-about-buggy-next-functions-fix
+++ a/fs/seq_file.c
@@ -257,7 +257,7 @@ Fill:
 
 		p = m->op->next(m, p, &m->index);
 		if (pos == m->index) {
-			pr_info("buggy seq_file .next function %ps "
+			pr_info_ratelimited("buggy seq_file .next function %ps "
 				"did not updated position index\n",
 				m->op->next);
 			m->index++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
