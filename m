From: akpm@linux-foundation.org
Subject: + mm-use-early_pfn_to_nid-in-page_ext_init.patch added to -mm
 tree
Date: Thu, 26 May 2016 13:59:42 -0700
Message-ID: <574763be.a8DfXizekfbnpQBg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbcEZU7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 16:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use early_pfn_to_nid in page_ext_init
has been added to the -mm tree.  Its filename is
     mm-use-early_pfn_to_nid-in-page_ext_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-early_pfn_to_nid-in-page_ext_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-early_pfn_to_nid-in-page_ext_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: use early_pfn_to_nid in page_ext_init

page_ext_init() checks suitable pages with pfn_to_nid(), but pfn_to_nid()
depends on memmap which will not be setup fully until
page_alloc_init_late() is done.  Use early_pfn_to_nid() instead of
pfn_to_nid() so that page extension could be still used early even though
CONFIG_ DEFERRED_STRUCT_PAGE_INIT is enabled and catch early page
allocation call sites.

Suggested by Joonsoo Kim [1], this fix basically undoes the change
introduced by commit b8f1a75d61d840 ("mm: call page_ext_init() after all
struct pages are initialized") and fixes the same problem with a better
approach.

[1] http://lkml.kernel.org/r/CAAmzW4OUmyPwQjvd7QUfc6W1Aic__TyAuH80MLRZNMxKy0-wPQ@mail.gmail.com

Link: http://lkml.kernel.org/r/1464198689-23458-1-git-send-email-yang.shi@linaro.org
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c   |    3 +--
 mm/page_ext.c |    4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN init/main.c~mm-use-early_pfn_to_nid-in-page_ext_init init/main.c
--- a/init/main.c~mm-use-early_pfn_to_nid-in-page_ext_init
+++ a/init/main.c
@@ -607,6 +607,7 @@ asmlinkage __visible void __init start_k
 		initrd_start = 0;
 	}
 #endif
+	page_ext_init();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
@@ -1003,8 +1004,6 @@ static noinline void __init kernel_init_
 	sched_init_smp();
 
 	page_alloc_init_late();
-	/* Initialize page ext after all struct pages are initializaed */
-	page_ext_init();
 
 	do_basic_setup();
 
diff -puN mm/page_ext.c~mm-use-early_pfn_to_nid-in-page_ext_init mm/page_ext.c
--- a/mm/page_ext.c~mm-use-early_pfn_to_nid-in-page_ext_init
+++ a/mm/page_ext.c
@@ -390,8 +390,10 @@ void __init page_ext_init(void)
 			 * We know some arch can have a nodes layout such as
 			 * -------------pfn-------------->
 			 * N0 | N1 | N2 | N0 | N1 | N2|....
+			 *
+			 * Take into account DEFERRED_STRUCT_PAGE_INIT.
 			 */
-			if (pfn_to_nid(pfn) != nid)
+			if (early_pfn_to_nid(pfn) != nid)
 				continue;
 			if (init_section_page_ext(pfn, nid))
 				goto oom;
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-make-config_deferred_struct_page_init-depends-on-flatmem-explicitly.patch
mm-use-early_pfn_to_nid-in-page_ext_init.patch
mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

