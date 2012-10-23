From: akpm@linux-foundation.org
Subject: + memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch added to -mm tree
Date: Tue, 23 Oct 2012 13:06:36 -0700
Message-ID: <20121023200636.BC869100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61538 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380Ab2JWUGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:06:37 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so532997yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:06:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE
has been added to the -mm tree.  Its filename is
     memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: make zone_pcp_reset independent of MEMORY_HOTREMOVE

340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
Since "memory-hotplug: allocate zone's pcp before onlining pages" the
function is also called from online_pages which is defined outside
CONFIG_MEMORY_HOTREMOVE which causes a linkage error.

The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
seems like universal enough so let's keep it at its current location
and only remove the HOTREMOVE guard.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix
+++ a/mm/page_alloc.c
@@ -5981,7 +5981,6 @@ void __meminit zone_pcp_update(struct zo
 }
 #endif
 
-#ifdef CONFIG_MEMORY_HOTREMOVE
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
@@ -6001,6 +6000,7 @@ void zone_pcp_reset(struct zone *zone)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be isolated before calling this.
  */
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-introduce-hugepage_get_pmd.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

