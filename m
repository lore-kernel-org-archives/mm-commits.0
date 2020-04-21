From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-mmapc-add-more-sanity-checks-to-get_unmapped_area.patch added to -mm
 tree
Date: Mon, 20 Apr 2020 19:59:19 -0700
Message-ID: <20200421025919.uPKXBui17%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDUC7U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 22:59:20 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agordeev@linux.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: add more sanity checks to get_unmapped_area()
has been added to the -mm tree.  Its filename is
     mm-mmapc-add-more-sanity-checks-to-get_unmapped_area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmapc-add-more-sanity-checks-to-get_unmapped_area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmapc-add-more-sanity-checks-to-get_unmapped_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: mm/mmap.c: add more sanity checks to get_unmapped_area()

Generic get_unmapped_area() function does sanity checks of address and
length of the area to be mapped.  Yet, it lacks checking against
mmap_min_addr and mmap_end limits.

At the same time the default implementation of functions
arch_get_unmapped_area[_topdown]() and some architecture callbacks do
mmap_min_addr and mmap_end checks on their own.

Put additional checks into the generic code and do not let architecture
callbacks to get away with a possible area outside of the allowed limits.

That could also relieve arch_get_unmapped_area[_topdown]() callbacks of
own address and length sanity checks.

Link: http://lkml.kernel.org/r/d14f2cff3c891ef2c4b0337d737c6f04beacb124.1584958099.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmapc-add-more-sanity-checks-to-get_unmapped_area
+++ a/mm/mmap.c
@@ -2208,12 +2208,13 @@ get_unmapped_area(struct file *file, uns
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
 
+	const unsigned long mmap_end = arch_get_mmap_end(addr);
 	unsigned long error = arch_mmap_check(addr, len, flags);
 	if (error)
 		return error;
 
 	/* Careful about overflows.. */
-	if (len > TASK_SIZE)
+	if (len > mmap_end - mmap_min_addr)
 		return -ENOMEM;
 
 	get_area = current->mm->get_unmapped_area;
@@ -2234,7 +2235,7 @@ get_unmapped_area(struct file *file, uns
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
-	if (addr > TASK_SIZE - len)
+	if ((addr < mmap_min_addr) || (addr > mmap_end - len))
 		return -ENOMEM;
 	if (offset_in_page(addr))
 		return -EINVAL;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-mmapc-add-more-sanity-checks-to-get_unmapped_area.patch
mm-mmapc-do-not-allow-mappings-outside-of-allowed-limits.patch
