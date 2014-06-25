From: akpm@linux-foundation.org
Subject: + mm-catch-memory-commitment-underflow.patch added to -mm tree
Date: Wed, 25 Jun 2014 15:04:12 -0700
Message-ID: <53ab475c.SB1uSIyLh9V5v6lT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaFYWEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 18:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: catch memory commitment underflow
has been added to the -mm tree.  Its filename is
     mm-catch-memory-commitment-underflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-catch-memory-commitment-underflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-catch-memory-commitment-underflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: catch memory commitment underflow

Print a warning (if CONFIG_DEBUG_VM=y) when memory commitment becomes too
negative.

This shouldn't happen any more - the previous two patches fixed the
committed_as underflow issues.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/mmap.c~mm-catch-memory-commitment-underflow mm/mmap.c
--- a/mm/mmap.c~mm-catch-memory-commitment-underflow
+++ a/mm/mmap.c
@@ -134,6 +134,12 @@ int __vm_enough_memory(struct mm_struct
 {
 	unsigned long free, allowed, reserve;
 
+#ifdef CONFIG_DEBUG_VM
+	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus(),
+			"memory commitment underflow");
+#endif
+
 	vm_acct_memory(pages);
 
 	/*
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
mm-memoryc-use-entry-=-access_oncepte-in-handle_pte_fault.patch
shmem-fix-double-uncharge-in-__shmem_file_setup.patch
shmem-update-memory-reservation-on-truncate.patch
mm-catch-memory-commitment-underflow.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch

