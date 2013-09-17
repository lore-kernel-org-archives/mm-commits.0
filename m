From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch added to
 -mm tree
Date: Tue, 17 Sep 2013 13:11:56 -0700
Message-ID: <5238b78c.sYi0XJ0v1AJSFHrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3IQUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 16:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com

Subject: + mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 13:11:56 -0700


The patch titled
     Subject: mm/vmalloc: don't warn about vmalloc allocation failure twice
has been added to the -mm tree.  Its filename is
     mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/vmalloc: don't warn about vmalloc allocation failure twice

Don't warn twice in __vmalloc_area_node and __vmalloc_node_range if
__vmalloc_area_node allocation fails.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice
+++ a/mm/vmalloc.c
@@ -1635,7 +1635,7 @@ void *__vmalloc_node_range(unsigned long
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		goto fail;
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
revert-mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice.patch
mm-vmalloc-dont-warn-about-vmalloc-allocation-failure-twice-fix.patch
mm-vmalloc-move-vm_uninitialized-to-just-before-show_numa_info.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

