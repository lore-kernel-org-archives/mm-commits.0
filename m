From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-fix-minor-typo-and-unclear-comment.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:21:19 -0700
Message-ID: <20200604172119.ayVp1eOeR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRVU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenqiwu@xiaomi.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com


The patch titled
     Subject: include/linux/memblock.h: fix minor typo and unclear comment
has been removed from the -mm tree.  Its filename was
     mm-memblock-fix-minor-typo-and-unclear-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: include/linux/memblock.h: fix minor typo and unclear comment

Fix a minor typo "usabe->usable" for the current discription of member
variable "memory" in struct memblock.

BTW, I think it's unclear the member variable "base" in struct
memblock_type is currently described as the physical address of memory
region, change it to base address of the region is clearer since the
variable is decorated as phys_addr_t.

Link: http://lkml.kernel.org/r/1588846952-32166-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memblock.h~mm-memblock-fix-minor-typo-and-unclear-comment
+++ a/include/linux/memblock.h
@@ -41,7 +41,7 @@ enum memblock_flags {
 
 /**
  * struct memblock_region - represents a memory region
- * @base: physical address of the region
+ * @base: base address of the region
  * @size: size of the region
  * @flags: memory region attributes
  * @nid: NUMA node id
@@ -75,7 +75,7 @@ struct memblock_type {
  * struct memblock - memblock allocator metadata
  * @bottom_up: is bottom up direction?
  * @current_limit: physical address of the current allocation limit
- * @memory: usabe memory regions
+ * @memory: usable memory regions
  * @reserved: reserved memory regions
  * @physmem: all physical memory
  */
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-replace-zero-length-array-with-flexible-array-member.patch
