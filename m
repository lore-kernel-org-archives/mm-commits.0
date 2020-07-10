From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch added
 to -mm tree
Date: Thu, 09 Jul 2020 17:23:51 -0700
Message-ID: <20200710002351.-X5wYALNt%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGJAXw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 20:23:52 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jannh@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, oleg@redhat.com, vbabka@suse.cz, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm-close-race-between-munmap-and-expand_upwards-downwards-fix
has been added to the -mm tree.  Its filename is
     mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch

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
Subject: mm-close-race-between-munmap-and-expand_upwards-downwards-fix

s/mmap_sem/mmap_lock/ in comment

Cc: Jann Horn <jannh@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-close-race-between-munmap-and-expand_upwards-downwards-fix
+++ a/mm/mmap.c
@@ -2647,9 +2647,9 @@ detach_vmas_to_be_unmapped(struct mm_str
 	vmacache_invalidate(mm);
 
 	/*
-	 * Do not downgrade mmap_sem if we are next to VM_GROWSDOWN or
+	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
 	 * VM_GROWSUP VMA. Such VMAs can change their size under
-	 * down_read(mmap_sem) and collide with the VMA we are about to unmap.
+	 * down_read(mmap_lock) and collide with the VMA we are about to unmap.
 	 */
 	if (vma && (vma->vm_flags & VM_GROWSDOWN))
 		return false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
