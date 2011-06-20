From: akpm@linux-foundation.org
Subject: + mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch added to -mm tree
Date: Mon, 20 Jun 2011 13:02:16 -0700
Message-ID: <201106202002.p5KK2GY3015361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1FTUC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 16:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com


The patch titled
     mm/page_cgroup.c: simplify code by using SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macros
has been added to the -mm tree.  Its filename is
     mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch

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
Subject: mm/page_cgroup.c: simplify code by using SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macros
From: Daniel Kiper <dkiper@net-space.pl>

git commit a539f3533b78e3 ("mm: add SECTION_ALIGN_UP() and
SECTION_ALIGN_DOWN() macro") introduced SECTION_ALIGN_UP() and
SECTION_ALIGN_DOWN() macro.  Use those macros to increase code
readability.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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

mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch

