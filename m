From: akpm@linux-foundation.org
Subject: [merged] mm-update-comments-for-struct-pagemapping.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:01 -0800
Message-ID: <20171116200001.iyNPGHWZl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934366AbdKPUAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update comments for struct page.mapping
has been removed from the -mm tree.  Its filename was
     mm-update-comments-for-struct-pagemapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changbin Du <changbin.du@intel.com>
Subject: mm: update comments for struct page.mapping

struct page.mapping can be NULL or points to one object of type
address_space, anon_vma or KSM private structure.

Link: http://lkml.kernel.org/r/1506485067-15954-1-git-send-email-changbin.du@intel.com
Signed-off-by: Changbin Du <changbin.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_types.h~mm-update-comments-for-struct-pagemapping include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-update-comments-for-struct-pagemapping
+++ a/include/linux/mm_types.h
@@ -48,8 +48,10 @@ struct page {
 						 * inode address_space, or NULL.
 						 * If page mapped as anonymous
 						 * memory, low bit is set, and
-						 * it points to anon_vma object:
-						 * see PAGE_MAPPING_ANON below.
+						 * it points to anon_vma object
+						 * or KSM private structure. See
+						 * PAGE_MAPPING_ANON and
+						 * PAGE_MAPPING_KSM.
 						 */
 		void *s_mem;			/* slab first object */
 		atomic_t compound_mapcount;	/* first tail page */
_

Patches currently in -mm which might be from changbin.du@intel.com are


