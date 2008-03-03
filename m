From: akpm@linux-foundation.org
Subject: + slub-fix-possible-null-pointer-dereference.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:15:57 -0800
Message-ID: <200803030815.m238FvDK006290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbYCCIQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:16:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     slub: fix possible NULL pointer dereference
has been added to the -mm tree.  Its filename is
     slub-fix-possible-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: fix possible NULL pointer dereference
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix possible NULL pointer dereference if kzalloc failed.  To be able to return
proper error code the function return type is changed to ssize_t (according to
callees and sysfs definitions).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-possible-null-pointer-dereference mm/slub.c
--- a/mm/slub.c~slub-fix-possible-null-pointer-dereference
+++ a/mm/slub.c
@@ -274,7 +274,7 @@ static inline struct kmem_cache_cpu *get
 }
 
 /* Determine the maximum number of objects that a slab page can hold */
-static inline unsigned long slab_objects(struct kmem_cache *s, struct page *page)
+static inline ssize_t slab_objects(struct kmem_cache *s, struct page *page)
 {
 	if (PageCompound(page))
 		return page[1].inuse;
@@ -3586,6 +3586,8 @@ static unsigned long show_slab_objects(s
 	unsigned long *per_cpu;
 
 	nodes = kzalloc(2 * sizeof(unsigned long) * nr_node_ids, GFP_KERNEL);
+	if (!nodes)
+		return -ENOMEM;
 	per_cpu = nodes + nr_node_ids;
 
 	for_each_possible_cpu(cpu) {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-avr32.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

