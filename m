From: akpm@linux-foundation.org
Subject: [merged] mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:47 -0700
Message-ID: <201107260751.p6Q7poNp002989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1GZHw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_cgroup.c: simplify code by using SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macros
has been removed from the -mm tree.  Its filename was
     mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_cgroup.c: simplify code by using SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macros
From: Daniel Kiper <dkiper@net-space.pl>

git commit a539f3533b78e3 ("mm: add SECTION_ALIGN_UP() and
SECTION_ALIGN_DOWN() macro") introduced SECTION_ALIGN_UP() and
SECTION_ALIGN_DOWN() macro.  Use those macros to increase code
readability.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_cgroup.c~mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros
+++ a/mm/page_cgroup.c
@@ -225,8 +225,8 @@ int __meminit online_page_cgroup(unsigne
 	unsigned long start, end, pfn;
 	int fail = 0;
 
-	start = start_pfn & ~(PAGES_PER_SECTION - 1);
-	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
 
 	if (nid == -1) {
 		/*
@@ -258,8 +258,8 @@ int __meminit offline_page_cgroup(unsign
 {
 	unsigned long start, end, pfn;
 
-	start = start_pfn & ~(PAGES_PER_SECTION - 1);
-	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_cgroup(pfn);
_

Patches currently in -mm which might be from dkiper@net-space.pl are

origin.patch

