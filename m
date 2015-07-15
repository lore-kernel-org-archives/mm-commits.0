From: akpm@linux-foundation.org
Subject: + mm-cma_debug-fix-debugging-alloc-free-interface.patch added to
 -mm tree
Date: Wed, 15 Jul 2015 14:18:06 -0700
Message-ID: <55a6ce0e.JqO8VpTvm/jHhoIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbbGOVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, sasha.levin@oracle.com, stefan.strogin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug: fix debugging alloc/free interface
has been added to the -mm tree.  Its filename is
     mm-cma_debug-fix-debugging-alloc-free-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma_debug-fix-debugging-alloc-free-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma_debug-fix-debugging-alloc-free-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/cma_debug: fix debugging alloc/free interface

CMA has alloc/free interface for debugging.  It is intended that
alloc/free occurs in specific CMA region, but, currently, alloc/free
interface is on root dir due to the bug so we can't select CMA region
where alloc/free happens.

This patch fixes this problem by making alloc/free interface per
CMA region.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma_debug.c~mm-cma_debug-fix-debugging-alloc-free-interface mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma_debug-fix-debugging-alloc-free-interface
+++ a/mm/cma_debug.c
@@ -170,10 +170,10 @@ static void cma_debugfs_add_one(struct c
 
 	tmp = debugfs_create_dir(name, cma_debugfs_root);
 
-	debugfs_create_file("alloc", S_IWUSR, cma_debugfs_root, cma,
+	debugfs_create_file("alloc", S_IWUSR, tmp, cma,
 				&cma_alloc_fops);
 
-	debugfs_create_file("free", S_IWUSR, cma_debugfs_root, cma,
+	debugfs_create_file("free", S_IWUSR, tmp, cma,
 				&cma_free_fops);
 
 	debugfs_create_file("base_pfn", S_IRUGO, tmp,
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch
mm-cma_debug-fix-debugging-alloc-free-interface.patch
mm-cma_debug-correct-size-input-to-bitmap-function.patch

