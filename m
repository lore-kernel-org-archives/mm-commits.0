From: akpm@linux-foundation.org
Subject: [merged] mm-page_cgroupc-mark-functions-as-static.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:46 -0700
Message-ID: <533f08a2.DWg+CEH6b3b7jeHK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaDDTbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-page_cgroupc-mark-functions-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:46 -0700


The patch titled
     Subject: mm/page_cgroup.c: mark functions as static
has been removed from the -mm tree.  Its filename was
     mm-page_cgroupc-mark-functions-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/page_cgroup.c: mark functions as static

Mark functions as static in page_cgroup.c because they are not used
outside this file.

This eliminates the following warning in mm/page_cgroup.c:
mm/page_cgroup.c:177:6: warning: no previous prototype for `__free_page_cgroup' [-Wmissing-prototypes]
mm/page_cgroup.c:190:15: warning: no previous prototype for `online_page_cgroup' [-Wmissing-prototypes]
mm/page_cgroup.c:225:15: warning: no previous prototype for `offline_page_cgroup' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_cgroup.c~mm-page_cgroupc-mark-functions-as-static mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroupc-mark-functions-as-static
+++ a/mm/page_cgroup.c
@@ -175,7 +175,7 @@ static void free_page_cgroup(void *addr)
 	}
 }
 
-void __free_page_cgroup(unsigned long pfn)
+static void __free_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *ms;
 	struct page_cgroup *base;
@@ -188,9 +188,9 @@ void __free_page_cgroup(unsigned long pf
 	ms->page_cgroup = NULL;
 }
 
-int __meminit online_page_cgroup(unsigned long start_pfn,
-			unsigned long nr_pages,
-			int nid)
+static int __meminit online_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages,
+				int nid)
 {
 	unsigned long start, end, pfn;
 	int fail = 0;
@@ -223,8 +223,8 @@ int __meminit online_page_cgroup(unsigne
 	return -ENOMEM;
 }
 
-int __meminit offline_page_cgroup(unsigned long start_pfn,
-		unsigned long nr_pages, int nid)
+static int __meminit offline_page_cgroup(unsigned long start_pfn,
+				unsigned long nr_pages, int nid)
 {
 	unsigned long start, end, pfn;
 
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

