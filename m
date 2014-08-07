From: akpm@linux-foundation.org
Subject: [merged] mm-catch-memory-commitment-underflow.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:09 -0700
Message-ID: <53e3dbf5.wV9Hsr1gpe6pMDNH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:51117 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaHGUFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:10 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so879572igd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, dave.hansen@intel.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: catch memory commitment underflow
has been removed from the -mm tree.  Its filename was
     mm-catch-memory-commitment-underflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: catch memory commitment underflow

Print a warning (if CONFIG_DEBUG_VM=y) when memory commitment becomes too
negative.

This shouldn't happen any more - the previous two patches fixed the
committed_as underflow issues.

[akpm@linux-foundation.org: use VM_WARN_ONCE, per Dave]
Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mmap.c~mm-catch-memory-commitment-underflow mm/mmap.c
--- a/mm/mmap.c~mm-catch-memory-commitment-underflow
+++ a/mm/mmap.c
@@ -31,6 +31,7 @@
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
 #include <linux/mmu_notifier.h>
+#include <linux/mmdebug.h>
 #include <linux/perf_event.h>
 #include <linux/audit.h>
 #include <linux/khugepaged.h>
@@ -134,6 +135,10 @@ int __vm_enough_memory(struct mm_struct
 {
 	unsigned long free, allowed, reserve;
 
+	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
+			-(s64)vm_committed_as_batch * num_online_cpus(),
+			"memory commitment underflow");
+
 	vm_acct_memory(pages);
 
 	/*
_

Patches currently in -mm which might be from koct9i@gmail.com are

origin.patch
lib-idr-fix-out-of-bounds-pointer-dereference.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch

