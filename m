From: akpm@linux-foundation.org
Subject: + hugetlb-fix-race-when-reading-proc-meminfo.patch added to -mm tree
Date: Tue, 01 Jul 2008 13:54:07 -0700
Message-ID: <200807012054.m61Ks7JI014198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489AbYGAUzq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 16:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, agl@us.ibm.com, apw@shadowen.org, hannes@saeurebad.de, hugh@veritas.com, mel@csn.ul.ie, wli@holomorphy.com


The patch titled
     hugetlb: fix race when reading proc meminfo
has been added to the -mm tree.  Its filename is
     hugetlb-fix-race-when-reading-proc-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix race when reading proc meminfo
From: Eric Paris <eparis@redhat.com>

minor nit that hugetlb_report_{,node_}meminfo() does not lock the reading
of nr_huge_pages, free_huge_pages, and friends so this is not an atomic
set of information put into the buffer.  If /proc/meminfo is read while
the number of hugetlb pages is in flux it is possible to get incorrect
output such as:

HugePages_Total:     7
HugePages_Free:      8
HugePages_Rsvd:      0
Hugepagesize:     4096 kB

(test available at https://bugzilla.redhat.com/attachment.cgi?id=309864)

With the patch we beat on a number of boxes for hours with the above test
and saw no inconsistencies in the meminfo output.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-race-when-reading-proc-meminfo mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-race-when-reading-proc-meminfo
+++ a/mm/hugetlb.c
@@ -1455,7 +1455,10 @@ int hugetlb_overcommit_handler(struct ct
 int hugetlb_report_meminfo(char *buf)
 {
 	struct hstate *h = &default_hstate;
-	return sprintf(buf,
+	int ret;
+
+	spin_lock(&hugetlb_lock);
+	ret = sprintf(buf,
 			"HugePages_Total: %5lu\n"
 			"HugePages_Free:  %5lu\n"
 			"HugePages_Rsvd:  %5lu\n"
@@ -1466,18 +1469,25 @@ int hugetlb_report_meminfo(char *buf)
 			h->resv_huge_pages,
 			h->surplus_huge_pages,
 			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+	spin_unlock(&hugetlb_lock);
+	return ret;
 }
 
 int hugetlb_report_node_meminfo(int nid, char *buf)
 {
 	struct hstate *h = &default_hstate;
-	return sprintf(buf,
+	int ret;
+
+	spin_lock(&hugetlb_lock);
+	ret = sprintf(buf,
 		"Node %d HugePages_Total: %5u\n"
 		"Node %d HugePages_Free:  %5u\n"
 		"Node %d HugePages_Surp:  %5u\n",
 		nid, h->nr_huge_pages_node[nid],
 		nid, h->free_huge_pages_node[nid],
 		nid, h->surplus_huge_pages_node[nid]);
+	spin_unlock(&hugetlb_lock);
+	return ret;
 }
 
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
_

Patches currently in -mm which might be from eparis@redhat.com are

kernel-auditc-nlh-nlmsg_type-is-gotten-more-than-once.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch

