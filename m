From: akpm@linux-foundation.org
Subject: + mm-vmalloc-remove-vm_vpages.patch added to -mm tree
Date: Thu, 19 Nov 2015 11:57:45 -0800
Message-ID: <564e29b9.Uac9gUhRP/w+Owse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbKST5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 14:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: remove VM_VPAGES
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-vm_vpages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-vm_vpages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-vm_vpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, vmalloc: remove VM_VPAGES

VM_VPAGES is unnecessary, it's easier to check is_vmalloc_addr() when
reading /proc/vmallocinfo.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    1 -
 mm/vmalloc.c            |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/vmalloc.h~mm-vmalloc-remove-vm_vpages include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-vmalloc-remove-vm_vpages
+++ a/include/linux/vmalloc.h
@@ -14,7 +14,6 @@ struct vm_area_struct;		/* vma defining
 #define VM_ALLOC		0x00000002	/* vmalloc() */
 #define VM_MAP			0x00000004	/* vmap()ed pages */
 #define VM_USERMAP		0x00000008	/* suitable for remap_vmalloc_range */
-#define VM_VPAGES		0x00000010	/* buffer for pages was vmalloc'ed */
 #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not fully initialized */
 #define VM_NO_GUARD		0x00000040      /* don't add guard page */
 #define VM_KASAN		0x00000080      /* has allocated kasan shadow memory */
diff -puN mm/vmalloc.c~mm-vmalloc-remove-vm_vpages mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-vm_vpages
+++ a/mm/vmalloc.c
@@ -1589,7 +1589,6 @@ static void *__vmalloc_area_node(struct
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
 				PAGE_KERNEL, node, area->caller);
-		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
@@ -2647,7 +2646,7 @@ static int s_show(struct seq_file *m, vo
 	if (v->flags & VM_USERMAP)
 		seq_puts(m, " user");
 
-	if (v->flags & VM_VPAGES)
+	if (is_vmalloc_addr(v->pages))
 		seq_puts(m, " vpages");
 
 	show_numa_info(m, v);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-vmalloc-remove-vm_vpages.patch

