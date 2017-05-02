From: akpm@linux-foundation.org
Subject: + mm-vmalloc-properly-track-vmalloc-users.patch added to -mm tree
Date: Tue, 02 May 2017 13:21:49 -0700
Message-ID: <5908ea5d.yWNlCy4YIHzxWmNy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdEBUVu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2017 16:21:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: properly track vmalloc users
has been added to the -mm tree.  Its filename is
     mm-vmalloc-properly-track-vmalloc-users.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-properly-track-vmalloc-users.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-properly-track-vmalloc-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmalloc: properly track vmalloc users

__vmalloc_node_flags used to be static inline but this has changed by "mm:
introduce kv[mz]alloc helpers" because kvmalloc_node needs to use it as
well and the code is outside of the vmalloc proper.  I haven't realized
that changing this will lead to a subtle bug though.  The function is
responsible to track the caller as well.  This caller is then printed by
/proc/vmallocinfo.  If __vmalloc_node_flags is not inline then we would
get only direct users of __vmalloc_node_flags as callers (e.g. 
v[mz]alloc) which reduces usefulness of this debugging feature
considerably.  It simply doesn't help to see that the given range belongs
to vmalloc as a caller:

0xffffc90002c79000-0xffffc90002c7d000   16384 vmalloc+0x16/0x18 pages=3 vmalloc N0=3
0xffffc90002c81000-0xffffc90002c85000   16384 vmalloc+0x16/0x18 pages=3 vmalloc N1=3
0xffffc90002c8d000-0xffffc90002c91000   16384 vmalloc+0x16/0x18 pages=3 vmalloc N1=3
0xffffc90002c95000-0xffffc90002c99000   16384 vmalloc+0x16/0x18 pages=3 vmalloc N1=3

We really want to catch the _caller_ of the vmalloc function.  Fix this
issue by making __vmalloc_node_flags static inline again.

Link: http://lkml.kernel.org/r/20170502134657.12381-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |   19 +++++++++++++++++++
 mm/vmalloc.c            |   12 +-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-properly-track-vmalloc-users include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-properly-track-vmalloc-users
+++ a/include/linux/vmalloc.h
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/llist.h>
 #include <asm/page.h>		/* pgprot_t */
+#include <asm/pgtable.h>	/* PAGE_KERNEL */
 #include <linux/rbtree.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
@@ -80,7 +81,25 @@ extern void *__vmalloc_node_range(unsign
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
 			const void *caller);
+#ifndef CONFIG_MMU
 extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
+#else
+extern void *__vmalloc_node(unsigned long size, unsigned long align,
+			    gfp_t gfp_mask, pgprot_t prot,
+			    int node, const void *caller);
+
+/*
+ * We really want to have this inlined due to caller tracking. This
+ * function is used by the highlevel vmalloc apis and so we want to track
+ * their callers and inlining will achieve that.
+ */
+static inline void *__vmalloc_node_flags(unsigned long size,
+					int node, gfp_t flags)
+{
+	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
+					node, __builtin_return_address(0));
+}
+#endif
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
diff -puN mm/vmalloc.c~mm-vmalloc-properly-track-vmalloc-users mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-properly-track-vmalloc-users
+++ a/mm/vmalloc.c
@@ -1649,9 +1649,6 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
-static void *__vmalloc_node(unsigned long size, unsigned long align,
-			    gfp_t gfp_mask, pgprot_t prot,
-			    int node, const void *caller);
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, int node)
 {
@@ -1794,7 +1791,7 @@ fail:
  *	with mm people.
  *
  */
-static void *__vmalloc_node(unsigned long size, unsigned long align,
+void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, const void *caller)
 {
@@ -1809,13 +1806,6 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-void *__vmalloc_node_flags(unsigned long size,
-					int node, gfp_t flags)
-{
-	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
-					node, __builtin_return_address(0));
-}
-
 /**
  *	vmalloc  -  allocate virtually contiguous memory
  *	@size:		allocation size
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
oom-improve-oom-disable-handling.patch
mm-introduce-kvalloc-helpers.patch
mm-vmalloc-properly-track-vmalloc-users.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch
mm-vmalloc-use-__gfp_highmem-implicitly.patch

