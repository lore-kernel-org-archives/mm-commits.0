From: akpm@linux-foundation.org
Subject: + thp-transparent-hugepage-sysfs-meminfo.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:15 -0800
Message-ID: <201012152358.oBFNwFe3013692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937Ab0LOX63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: transparent hugepage sysfs meminfo
has been added to the -mm tree.  Its filename is
     thp-transparent-hugepage-sysfs-meminfo.patch

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
Subject: thp: transparent hugepage sysfs meminfo
From: David Rientjes <rientjes@google.com>

Add hugepage statistics to per-node sysfs meminfo

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/base/node.c~thp-transparent-hugepage-sysfs-meminfo drivers/base/node.c
--- a/drivers/base/node.c~thp-transparent-hugepage-sysfs-meminfo
+++ a/drivers/base/node.c
@@ -117,12 +117,21 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d WritebackTmp:   %8lu kB\n"
 		       "Node %d Slab:           %8lu kB\n"
 		       "Node %d SReclaimable:   %8lu kB\n"
-		       "Node %d SUnreclaim:     %8lu kB\n",
+		       "Node %d SUnreclaim:     %8lu kB\n"
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		       "Node %d AnonHugePages:  %8lu kB\n"
+#endif
+			,
 		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_ANON_PAGES)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			HPAGE_PMD_NR
+#endif
+		       ),
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
@@ -133,7 +142,13 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
+		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			, nid,
+			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			HPAGE_PMD_NR)
+#endif
+		       );
 	n += hugetlb_report_node_meminfo(nid, buf + n);
 	return n;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-remove-unused-get_vm_area_node.patch
mm-remove-gfp-mask-from-pcpu_get_vm_areas.patch
mm-unify-module_alloc-code-for-vmalloc.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
thp-transparent-hugepage-sysfs-meminfo.patch
flex_array-export-symbols-to-modules.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch
proc-use-single_open-correctly.patch

