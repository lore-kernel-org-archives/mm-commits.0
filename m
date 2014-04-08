From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-enhance-vm_map_ram-comment.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:48:43 -0700
Message-ID: <534460ab.Aluz51ell21eZup/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, minchan@kernel.org, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, gioh.kim@lge.com

Subject: [merged] mm-vmallocc-enhance-vm_map_ram-comment.patch removed from -mm tree
To: gioh.kim@lge.com,hannes@cmpxchg.org,iamjoonsoo.kim@lge.com,minchan@kernel.org,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:48:43 -0700


The patch titled
     Subject: mm/vmalloc.c: enhance vm_map_ram() comment
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-enhance-vm_map_ram-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Gioh Kim" <gioh.kim@lge.com>
Subject: mm/vmalloc.c: enhance vm_map_ram() comment

vm_map_ram() has a fragmentation problem when it cannot purge a chunk(ie,
4M address space) if there is a pinning object in that addresss space.  So
it could consume all VMALLOC address space easily.

We can fix the fragmentation problem by using vmap instead of vm_map_ram()
but vmap() is known to be slow compared to vm_map_ram().  Minchan said
vm_map_ram is 5 times faster than vmap in his tests.  So I thought we
should fix fragment problem of vm_map_ram because our proprietary GPU
driver has used it heavily.

On second thought, it's not an easy because we should reuse freed space
for solving the problem and it could make more IPI and bitmap operation
for searching hole.  It could mitigate API's goal which is very fast
mapping.  And even fragmentation problem wouldn't show in 64 bit machine.

Another option is that the user should separate long-life and short-life
object and use vmap for long-life but vm_map_ram for short-life.  If we
inform the user about the characteristic of vm_map_ram the user can choose
one according to the page lifetime.

Let's add some notice messages to user.

[akpm@linux-foundation.org: tweak comment text]
Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/vmalloc.c~mm-vmallocc-enhance-vm_map_ram-comment mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-enhance-vm_map_ram-comment
+++ a/mm/vmalloc.c
@@ -1085,6 +1085,12 @@ EXPORT_SYMBOL(vm_unmap_ram);
  * @node: prefer to allocate data structures on this node
  * @prot: memory protection to use. PAGE_KERNEL for regular RAM
  *
+ * If you use this function for less than VMAP_MAX_ALLOC pages, it could be
+ * faster than vmap so it's good.  But if you mix long-life and short-life
+ * objects with vm_map_ram(), it could consume lots of address space through
+ * fragmentation (especially on a 32bit machine).  You could see failures in
+ * the end.  Please use this function for short-lived objects.
+ *
  * Returns: a pointer to the address that has been mapped, or %NULL on failure
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t prot)
_

Patches currently in -mm which might be from gioh.kim@lge.com are

origin.patch

