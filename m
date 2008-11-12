From: akpm@linux-foundation.org
Subject: + memcg-bugfix-for-memory-hotplug.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:55:38 -0800
Message-ID: <200811120055.mAC0tcR3026264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYKLA4C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 19:56:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, pbadari@us.ibm.com


The patch titled
     memcg: bugfix for memory hotplug
has been added to the -mm tree.  Its filename is
     memcg-bugfix-for-memory-hotplug.patch

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
Subject: memcg: bugfix for memory hotplug
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

The start pfn calculation in page_cgroup's memory hotplug notifier chain
is wrong.

Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~memcg-bugfix-for-memory-hotplug mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-bugfix-for-memory-hotplug
+++ a/mm/page_cgroup.c
@@ -165,7 +165,7 @@ int online_page_cgroup(unsigned long sta
 	unsigned long start, end, pfn;
 	int fail = 0;
 
-	start = start_pfn & (PAGES_PER_SECTION - 1);
+	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
@@ -188,7 +188,7 @@ int offline_page_cgroup(unsigned long st
 {
 	unsigned long start, end, pfn;
 
-	start = start_pfn & (PAGES_PER_SECTION - 1);
+	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-bugfix-for-memory-hotplug.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch

