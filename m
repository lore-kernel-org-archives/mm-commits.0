From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:32:16 -0700
Message-ID: <20120418223216.90C84A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46377 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2DRWcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:32:18 -0400
Received: by eekc41 with SMTP id c41so381005eek.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:32:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: use scnprintf instead of sprintf
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: memcg: use scnprintf instead of sprintf

Make sure we don't overflow.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf mm/memcontrol.c
--- a/mm/memcontrol.c~hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf
+++ a/mm/memcontrol.c
@@ -5196,14 +5196,14 @@ static void mem_cgroup_destroy(struct cg
 }
 
 #ifdef CONFIG_MEM_RES_CTLR_HUGETLB
-static char *mem_fmt(char *buf, unsigned long n)
+static char *mem_fmt(char *buf, int size, unsigned long hsize)
 {
-	if (n >= (1UL << 30))
-		sprintf(buf, "%luGB", n >> 30);
-	else if (n >= (1UL << 20))
-		sprintf(buf, "%luMB", n >> 20);
+	if (hsize >= (1UL << 30))
+		scnprintf(buf, size, "%luGB", hsize >> 30);
+	else if (hsize >= (1UL << 20))
+		scnprintf(buf, size, "%luMB", hsize >> 20);
 	else
-		sprintf(buf, "%luKB", n >> 10);
+		scnprintf(buf, size, "%luKB", hsize >> 10);
 	return buf;
 }
 
@@ -5214,7 +5214,7 @@ int __init mem_cgroup_hugetlb_file_init(
 	struct hstate *h = &hstates[idx];
 
 	/* format the size */
-	mem_fmt(buf, huge_page_size(h));
+	mem_fmt(buf, 32, huge_page_size(h));
 
 	/* Add the limit file */
 	cft = &h->mem_cgroup_files[0];
_
Subject: Subject: memcg: use scnprintf instead of sprintf

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

