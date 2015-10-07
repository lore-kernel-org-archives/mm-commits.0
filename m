From: akpm@linux-foundation.org
Subject: [to-be-updated] dax-temporarily-disable-dax-pmd-fault-path.patch
 removed from -mm tree
Date: Wed, 07 Oct 2015 14:35:59 -0700
Message-ID: <5615903f.3wz7De/WIjtiHSIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbbJGVgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 17:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.com, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: temporarily disable DAX PMD fault path
has been removed from the -mm tree.  Its filename was
     dax-temporarily-disable-dax-pmd-fault-path.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: temporarily disable DAX PMD fault path

There is currently a deadlock in the DAX PMD fault path because it ends up
taking the same mapping->i_mmap_rwsem twice.  The first take is a
i_mmap_lock_read() near the beginning of __dax_pmd_fault(), and the second
is __dax_pmd_fault() -> unmap_mapping_range() -> i_mmap_lock_write().

We are re-working the way that DAX does its locking for v4.4, so for now
just disable DAX PMD faults and fall back to PAGE_SIZE faults to make sure
we don't hit this deadlock.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/dax.c~dax-temporarily-disable-dax-pmd-fault-path fs/dax.c
--- a/fs/dax.c~dax-temporarily-disable-dax-pmd-fault-path
+++ a/fs/dax.c
@@ -534,6 +534,13 @@ int __dax_pmd_fault(struct vm_area_struc
 	unsigned long pfn;
 	int result = 0;
 
+	/*
+	 * There is currently a deadlock in the DAX PMD fault path.  Disable
+	 * this path and fall back to the normal dax_fault() path for now
+	 * while we rework locking.
+	 */
+	return VM_FAULT_FALLBACK;
+
 	/* Fall back to PTEs if we're going to COW */
 	if (write && !(vma->vm_flags & VM_SHARED))
 		return VM_FAULT_FALLBACK;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


