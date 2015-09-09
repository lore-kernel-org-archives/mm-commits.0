From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 09 Sep 2015 15:12:49 -0700
Message-ID: <55f0aee1.T8DlHjYOOyqg+JXB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbIIWMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#5: 
>> mm/nommu.c:1248:30: error: 'vm_flags' redeclared as different kind of symbol

WARNING: please, no spaces at the start of a line
#28: FILE: mm/nommu.c:1248:
+       unsigned long capabilities, result;$

WARNING: please, no spaces at the start of a line
#37: FILE: mm/nommu.c:1266:
+       vm_flags |= determine_vm_flags(file, prot, flags, capabilities);$

total: 0 errors, 3 warnings, 16 lines checked

./patches/mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes
+++ a/mm/nommu.c
@@ -1245,7 +1245,7 @@ unsigned long do_mmap(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-       unsigned long capabilities, result;
+	unsigned long capabilities, result;
 	int ret;
 
 	*populate = 0;
@@ -1263,7 +1263,7 @@ unsigned long do_mmap(struct file *file,
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
-       vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
+	vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

