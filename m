From: akpm@google.com
Subject: + cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch added to -mm tree
Date: Fri, 30 Sep 2011 16:03:22 -0700
Message-ID: <201109302303.p8UN3Mqq021454@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:11054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1I3XEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2011 19:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, catalin.marinas@arm.com, jrnieder@gmail.com, mhocko@suse.cz


The patch titled
     Subject: cgroup/kmemleak: Annotate alloc_page() for cgroup allocations
has been added to the -mm tree.  Its filename is
     cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: cgroup/kmemleak: Annotate alloc_page() for cgroup allocations

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix-fix.patch
cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch
memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch

