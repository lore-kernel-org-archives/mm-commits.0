From: akpm@linux-foundation.org
Subject: +
 huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch added
 to -mm tree
Date: Wed, 06 Apr 2016 19:24:49 -0700
Message-ID: <5705c4f1.9AG8dJOjDnwq0atD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcDGCYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2016 22:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix
has been added to the -mm tree.  Its filename is
     huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch

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
Subject: huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix

fix nommu build

drivers/char/mem.c: In function 'get_unmapped_area_zero':
drivers/char/mem.c:683: error: 'struct mm_struct' has no member named 'get_unmapped_area'

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix drivers/char/mem.c
--- a/drivers/char/mem.c~huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix
+++ a/drivers/char/mem.c
@@ -666,9 +666,7 @@ static unsigned long get_unmapped_area_z
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
-#ifndef CONFIG_MMU
-	return -ENOSYS;
-#endif
+#ifdef CONFIG_MMU
 	if (flags & MAP_SHARED) {
 		/*
 		 * mmap_zero() will call shmem_zero_setup() to create a file,
@@ -681,6 +679,9 @@ static unsigned long get_unmapped_area_z
 
 	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
 	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
+#else
+	return -ENOSYS;
+#endif
 }
 
 static ssize_t write_full(struct file *file, const char __user *buf,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page-fix.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

