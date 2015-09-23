From: akpm@linux-foundation.org
Subject: + dax-fix-deadlock-in-__dax_fault.patch added to -mm tree
Date: Wed, 23 Sep 2015 13:48:32 -0700
Message-ID: <56031020.xd6p1E0kzv00f3LB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbIWUsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 16:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix deadlock in __dax_fault()
has been added to the -mm tree.  Its filename is
     dax-fix-deadlock-in-__dax_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-deadlock-in-__dax_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-deadlock-in-__dax_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix deadlock in __dax_fault()

Fix the deadlock exposed by xfstests generic/075.  Here is the sequence
that was causing us to deadlock:

1) enter __dax_fault()
2) page = find_get_page() gives us a page, so skip
	i_mmap_lock_write(mapping)
3) if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page)
	passes, enter this block
4) if (vmf->flags & FAULT_FLAG_WRITE) fails, so do the else case and
	i_mmap_unlock_write(mapping);
	return dax_load_hole(mapping, page, vmf);

This causes us to up_write() a semaphore that we weren't holding.

The up_write() on a semaphore we didn't down_write() happens twice in
a row, and then the next time we try and i_mmap_lock_write(), we hang.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-fix-deadlock-in-__dax_fault fs/dax.c
--- a/fs/dax.c~dax-fix-deadlock-in-__dax_fault
+++ a/fs/dax.c
@@ -405,7 +405,8 @@ int __dax_fault(struct vm_area_struct *v
 			if (error)
 				goto unlock;
 		} else {
-			i_mmap_unlock_write(mapping);
+			if (!page)
+				i_mmap_unlock_write(mapping);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-null-pointer-in-__dax_pmd_fault.patch
dax-fix-deadlock-in-__dax_fault.patch

