From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch added to -mm tree
Date: Wed, 18 Sep 2013 13:41:32 -0700
Message-ID: <523a0ffc.j61XWrTF5A25of48%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3IRUlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch added to -mm tree
To: akpm@linux-foundation.org,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:41:32 -0700


The patch titled
     Subject: mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix

avoid error-prone `return' in the middle of the function

Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix
+++ a/mm/vmalloc.c
@@ -1626,16 +1626,16 @@ void *__vmalloc_node_range(unsigned long
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
-		goto fail;
+		goto warn;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNINITIALIZED,
 				  start, end, node, gfp_mask, caller);
 	if (!area)
-		goto fail;
+		goto warn;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 	if (!addr)
-		return NULL;
+		goto fail;
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
@@ -1653,10 +1653,11 @@ void *__vmalloc_node_range(unsigned long
 
 	return addr;
 
-fail:
+warn:
 	warn_alloc_failed(gfp_mask, 0,
 			  "vmalloc: allocation failure: %lu bytes\n",
 			  real_size);
+fail:
 	return NULL;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

