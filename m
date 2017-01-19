From: akpm@linux-foundation.org
Subject: +
 mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch added
 to -mm tree
Date: Thu, 19 Jan 2017 15:02:34 -0800
Message-ID: <5881458a.k3dUoYxkLFfTqOxB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdASXNb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 18:13:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, borntraeger@de.ibm.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix
has been added to the -mm tree.  Its filename is
     mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch

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
Subject: mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix

make zero_checksum and ksm_use_zero_pages __read_mostly, per Andrea

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix mm/ksm.c
--- a/mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix
+++ a/mm/ksm.c
@@ -224,10 +224,10 @@ static unsigned int ksm_thread_pages_to_
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
 /* Checksum of an empty (zeroed) page */
-static unsigned int zero_checksum;
+static unsigned int zero_checksum __read_mostly;
 
 /* Whether to merge empty (zeroed) pages with actual zero pages */
-static bool ksm_use_zero_pages;
+static bool ksm_use_zero_pages __read_mostly;
 
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask-checkpatch-fixes.patch
mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

