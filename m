From: akpm@linux-foundation.org
Subject: + mm-remove-__vmalloc_node_flags_caller-fix.patch added
 to -mm tree
Date: Mon, 20 Apr 2020 14:36:41 -0700
Message-ID: <20200420213641.0-O3V52fQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgDTVgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 17:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org, sfr@canb.auug.org.au


The patch titled
     Subject: mm-remove-__vmalloc_node_flags_caller-fix
has been added to the -mm tree.  Its filename is
     mm-remove-__vmalloc_node_flags_caller-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-__vmalloc_node_flags_caller-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-__vmalloc_node_flags_caller-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-__vmalloc_node_flags_caller-fix

fix nommu build

Cc: Christoph Hellwig <hch@lst.de>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~mm-remove-__vmalloc_node_flags_caller-fix
+++ a/mm/nommu.c
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(__vmalloc);
 void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller)
 {
-	return __vmalloc(size, flags);
+	return __vmalloc(size, gfp_mask);
 }
 
 static void *__vmalloc_user_flags(unsigned long size, gfp_t flags)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
