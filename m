From: akpm@linux-foundation.org
Subject: [folded-merged]
 thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment-fix.patch
 removed from -mm tree
Date: Mon, 13 Jan 2020 16:21:43 -0800
Message-ID: <20200114002143.cz9Wj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgANAVp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 19:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, thomas.willhalm@intel.com, otto.g.bruggeman@intel.com, dan.j.williams@intel.com, aneesh.kumar@linux.vnet.ibm.com, kirill@shutemov.name


The patch titled
     Subject: thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment-fix
has been removed from the -mm tree.  Its filename was
     thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment-fix.patch

This patch was dropped because it was folded into thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment-fix

Ouch, I forgot to fold in a fixup:

Link: http://lkml.kernel.org/r/20191223231309.t6bh5hkbmokihpfu@box
Cc: "Willhalm, Thomas" <thomas.willhalm@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Bruggeman, Otto G" <otto.g.bruggeman@intel.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment-fix
+++ a/mm/shmem.c
@@ -2144,7 +2144,7 @@ unsigned long shmem_get_unmapped_area(st
 	if (inflated_len < len)
 		return addr;
 
-	inflated_addr = get_area(uaddr, 0, inflated_len, 0, flags);
+	inflated_addr = get_area(NULL, uaddr, inflated_len, 0, flags);
 	if (IS_ERR_VALUE(inflated_addr))
 		return addr;
 	if (inflated_addr & ~PAGE_MASK)
_

Patches currently in -mm which might be from kirill@shutemov.name are

thp-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment.patch
thp-shmem-fix-conflict-of-above-47bit-hint-address-and-pmd-alignment.patch
mm-page_alloc-skip-non-present-sections-on-zone-initialization.patch
