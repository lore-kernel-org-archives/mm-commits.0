From: akpm@linux-foundation.org
Subject: + mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch
 added to -mm tree
Date: Tue, 18 Oct 2016 15:21:45 -0700
Message-ID: <5806a079.FIdDlVCoDsoFHs2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932719AbcJRWVq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 18:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zijun_hu@htc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, sfr@canb.auug.org.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: simplify /proc/vmallocinfo implementation
has been added to the -mm tree.  Its filename is
     mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2540,32 +2540,13 @@ void pcpu_free_vm_areas(struct vm_struct
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
-
-	return NULL;
+	return seq_list_next(p, &vmap_area_list, pos);
 }
 
 static void s_stop(struct seq_file *m, void *p)
@@ -2600,9 +2581,11 @@ static void show_numa_info(struct seq_fi
 
 static int s_show(struct seq_file *m, void *p)
 {
-	struct vmap_area *va = p;
+	struct vmap_area *va;
 	struct vm_struct *v;
 
+	va = list_entry(p, struct vmap_area, list);
+
 	/*
 	 * s_show can encounter race with remove_vm_area, !VM_VM_AREA on
 	 * behalf of vmap area is being tear down or vm_map_ram allocation.
_

Patches currently in -mm which might be from zijun_hu@htc.com are

mm-vmallocc-simplify-proc-vmallocinfo-implementation.patch
mm-percpuc-fix-panic-triggered-by-bug_on-falsely.patch

