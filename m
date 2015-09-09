From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:12:15 -0700
Message-ID: <55f0aebf.11wh1UaNyme1RmTW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbIIWMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, fengguang.wu@intel.com, msalter@redhat.com, oleg@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix
has been removed from the -mm tree.  Its filename was
     mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix.patch

This patch was dropped because it was folded into mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix

   mm/nommu.c: In function 'do_mmap':
>> mm/nommu.c:1248:30: error: 'vm_flags' redeclared as different kind of symbol
     unsigned long capabilities, vm_flags, result;
                                 ^
   mm/nommu.c:1241:15: note: previous definition of 'vm_flags' was here
       vm_flags_t vm_flags,

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix mm/nommu.c
--- a/mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix
+++ a/mm/nommu.c
@@ -1245,7 +1245,7 @@ unsigned long do_mmap(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags, result;
+       unsigned long capabilities, result;
 	int ret;
 
 	*populate = 0;
@@ -1263,7 +1263,7 @@ unsigned long do_mmap(struct file *file,
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
-	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
+       vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

