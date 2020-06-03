From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 121/131] include/linux/memblock.h: fix minor typo
 and unclear comment
Date: Wed, 03 Jun 2020 16:03:28 -0700
Message-ID: <20200603230328.Z7PnzTsuY%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

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
