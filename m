From: akpm@linux-foundation.org
Subject: [merged] cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:47 -0800
Message-ID: <201111072026.pA7KQlHe026623@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab1KGU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:26:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, catalin.marinas@arm.com, jrnieder@gmail.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup/kmemleak: Annotate alloc_page() for cgroup allocations
has been removed from the -mm tree.  Its filename was
     cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: cgroup/kmemleak: Annotate alloc_page() for cgroup allocations

When the cgroup base was allocated with kmalloc, it was necessary to
annotate the variable with kmemleak_not_leak().  But because it has
recently been changed to be allocated with alloc_page() (which skips
kmemleak checks) causes a warning on boot up.

I was triggering this output:

 allocated 8388608 bytes of page_cgroup
 please try 'cgroup_disable=memory' option if you don't want memory cgroups
 kmemleak: Trying to color unknown object at 0xf5840000 as Grey
 Pid: 0, comm: swapper Not tainted 3.0.0-test #12
 Call Trace:
  [<c17e34e6>] ? printk+0x1d/0x1f^M
  [<c10e2941>] paint_ptr+0x4f/0x78
  [<c178ab57>] kmemleak_not_leak+0x58/0x7d
  [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
  [<c1cdb462>] kmemleak_init+0x19d/0x1e9
  [<c1cbf771>] start_kernel+0x346/0x3ec
  [<c1cbf1b4>] ? loglevel+0x18/0x18
  [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0

After a bit of debugging I tracked the object 0xf840000 (and others) down
to the cgroup code.  The change from allocating base with kmalloc to
alloc_page() has the base not calling kmemleak_alloc() which adds the
pointer to the object_tree_root, but kmemleak_not_leak() adds it to the
crt_early_log[] table.  On kmemleak_init(), the entry is found in the
early_log[] but not the object_tree_root, and this error message is
displayed.

If alloc_page() fails then it defaults back to vmalloc() which still uses
the kmemleak_alloc() which makes us still need the kmemleak_not_leak()
call.  The solution is to call the kmemleak_alloc() directly if the
alloc_page() succeeds.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations mm/page_cgroup.c
--- a/mm/page_cgroup.c~cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations
+++ a/mm/page_cgroup.c
@@ -133,10 +133,13 @@ struct page *lookup_cgroup_page(struct p
 static void *__meminit alloc_page_cgroup(size_t size, int nid)
 {
 	void *addr = NULL;
+	gfp_t flags = GFP_KERNEL | __GFP_NOWARN;
 
-	addr = alloc_pages_exact_nid(nid, size, GFP_KERNEL | __GFP_NOWARN);
-	if (addr)
+	addr = alloc_pages_exact_nid(nid, size, flags);
+	if (addr) {
+		kmemleak_alloc(addr, size, 1, flags);
 		return addr;
+	}
 
 	if (node_state(nid, N_HIGH_MEMORY))
 		addr = vmalloc_node(size, nid);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch

