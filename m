From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:24:09 -0800
Message-ID: <58519c59.u7qxe6oOqI/gJJ0V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756530AbcLNTYK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:24:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, sfr@canb.auug.org.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: simplify /proc/vmallocinfo implementation
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zijun_hu <zijun_hu@htc.com>
Subject: mm/vmalloc.c: simplify /proc/vmallocinfo implementation

Many seq_file helpers exist for simplifying implementation of virtual
files especially, for /proc nodes.  however, the helpers for iteration
over list_head are available but aren't adopted to implement
/proc/vmallocinfo currently.

Simplify /proc/vmallocinfo implementation by using existing seq_file
helpers.

Link: http://lkml.kernel.org/r/57FDF2E5.1000201@zoho.com
Signed-off-by: zijun_hu <zijun_hu@htc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-simplify-proc-vmallocinfo-implementation mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-simplify-proc-vmallocinfo-implementation
+++ a/mm/vmalloc.c
@@ -2574,32 +2574,13 @@ void pcpu_free_vm_areas(struct vm_struct
 static void *s_start(struct seq_file *m, loff_t *pos)
 	__acquires(&vmap_area_lock)
 {
-	loff_t n = *pos;
-	struct vmap_area *va;
-
 	spin_lock(&vmap_area_lock);
-	va = list_first_entry(&vmap_area_list, typeof(*va), list);
-	while (n > 0 && &va->list != &vmap_area_list) {
-		n--;
-		va = list_next_entry(va, list);
-	}
-	if (!n && &va->list != &vmap_area_list)
-		return va;
-
-	return NULL;
-
+	return seq_list_start(&vmap_area_list, *pos);
 }
 
 static void *s_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	struct vmap_area *va = p, *next;
-
-	++*pos;
-	next = list_next_entry(va, list);
-	if (&next->list != &vmap_area_list)
-		return next;
