From: akpm@linux-foundation.org
Subject: - memcg-bugfix-for-memory-hotplug.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:17 -0800
Message-ID: <200811132127.mADLRHvS027869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbYKMV1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: bugfix for memory hotplug
has been removed from the -mm tree.  Its filename was
     memcg-bugfix-for-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch

