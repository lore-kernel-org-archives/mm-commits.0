From: akpm@linux-foundation.org
Subject: + mm-thp-khugepaged-add-policy-for-finding-target-node.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 18:08:21 -0700
Message-ID: <52438905.pGf8lm9Zf3DdlWEm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IZBIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 21:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidoff@qedmf.net, bob.liu@oracle.com, aarcange@redhat.com, lliubbo@gmail.com

Subject: + mm-thp-khugepaged-add-policy-for-finding-target-node.patch added to -mm tree
To: lliubbo@gmail.com,aarcange@redhat.com,bob.liu@oracle.com,davidoff@qedmf.net,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 18:08:21 -0700


The patch titled
     Subject: mm: thp: khugepaged: add policy for finding target node
has been added to the -mm tree.  Its filename is
     mm-thp-khugepaged-add-policy-for-finding-target-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-khugepaged-add-policy-for-finding-target-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-khugepaged-add-policy-for-finding-target-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: thp: khugepaged: add policy for finding target node

Khugepaged will scan/free HPAGE_PMD_NR normal pages and replace with a
hugepage which is allocated from the node of the first scanned normal
page, but this policy is too rough and may end with unexpected result to
upper users.

The problem is the original page-balancing among all nodes will be broken
after hugepaged started.  Thinking about the case if the first scanned
normal page is allocated from node A, most of other scanned normal pages
are allocated from node B or C..  But hugepaged will always allocate
hugepage from node A which will cause extra memory pressure on node A
which is not the situation before khugepaged started.

This patch try to fix this problem by making khugepaged allocate hugepage
from the node which have max record of scaned normal pages hit, so that
the effect to original page-balancing can be minimized.

The other problem is if normal scanned pages are equally allocated from
Node A,B and C, after khugepaged started Node A will still suffer extra
memory pressure.

Andrew Davidoff reported a related issue several days ago.  He wanted his
application interleaving among all nodes and "numactl --interleave=all
./test" was used to run the testcase, but the result wasn't not as
expected.

cat /proc/2814/numa_maps:
7f50bd440000 interleave:0-3 anon=51403 dirty=51403 N0=435 N1=435 N2=435
N3=50098
The end result showed that most pages are from Node3 instead of interleave
among node0-3 which was unreasonable.

This patch also fix this issue by allocating hugepage round robin from all
nodes have the same record, after this patch the result was as expected:
7f78399c0000 interleave:0-3 anon=51403 dirty=51403 N0=12723 N1=12723
N2=13235 N3=12722

The simple testcase is like this:

int main() {
	char *p;
	int i;
	int j;

	for (i=0; i < 200; i++) {
		p = (char *)malloc(1048576);
		printf("malloc done\n");

		if (p == 0) {
			printf("Out of memory\n");
			return 1;
		}
		for (j=0; j < 1048576; j++) {
			p[j] = 'A';
		}
		printf("touched memory\n");

		sleep(1);
	}
	printf("enter sleep\n");
	while(1) {
		sleep(100);
	}
}

Reported-by: Andrew Davidoff <davidoff@qedmf.net>
Tested-by: Andrew Davidoff <davidoff@qedmf.net>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   52 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-khugepaged-add-policy-for-finding-target-node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-khugepaged-add-policy-for-finding-target-node
+++ a/mm/huge_memory.c
@@ -2132,7 +2132,33 @@ static void khugepaged_alloc_sleep(void)
 			msecs_to_jiffies(khugepaged_alloc_sleep_millisecs));
 }
 
+static int khugepaged_node_load[MAX_NUMNODES];
 #ifdef CONFIG_NUMA
+static int last_khugepaged_target_node = NUMA_NO_NODE;
+static int khugepaged_find_target_node(void)
+{
+	int nid, target_node = 0, max_value = 0;
+
+	/* find first node with max normal pages hit */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		if (khugepaged_node_load[nid] > max_value) {
+			max_value = khugepaged_node_load[nid];
+			target_node = nid;
+		}
+
+	/* do some balance if several nodes have the same hit record */
+	if (target_node <= last_khugepaged_target_node)
+		for (nid = last_khugepaged_target_node + 1; nid < MAX_NUMNODES;
+				nid++)
+			if (max_value == khugepaged_node_load[nid]) {
+				target_node = nid;
+				break;
+			}
+
+	last_khugepaged_target_node = target_node;
+	return target_node;
+}
+
 static bool khugepaged_prealloc_page(struct page **hpage, bool *wait)
 {
 	if (IS_ERR(*hpage)) {
@@ -2166,9 +2192,8 @@ static struct page
 	 * mmap_sem in read mode is good idea also to allow greater
 	 * scalability.
 	 */
-	*hpage  = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
-				      node, __GFP_OTHER_NODE);
-
+	*hpage = alloc_pages_exact_node(node, alloc_hugepage_gfpmask(
+		khugepaged_defrag(), __GFP_OTHER_NODE), HPAGE_PMD_ORDER);
 	/*
 	 * After allocating the hugepage, release the mmap_sem read lock in
 	 * preparation for taking it in write mode.
@@ -2184,6 +2209,11 @@ static struct page
 	return *hpage;
 }
 #else
+static int khugepaged_find_target_node(void)
+{
+	return 0;
+}
+
 static inline struct page *alloc_hugepage(int defrag)
 {
 	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
@@ -2396,6 +2426,7 @@ static int khugepaged_scan_pmd(struct mm
 	if (pmd_trans_huge(*pmd))
 		goto out;
 
+	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
@@ -2412,12 +2443,13 @@ static int khugepaged_scan_pmd(struct mm
 		if (unlikely(!page))
 			goto out_unmap;
 		/*
-		 * Chose the node of the first page. This could
-		 * be more sophisticated and look at more pages,
-		 * but isn't for now.
+		 * Record which node the original page is from and save this
+		 * information to khugepaged_node_load[].
+		 * Khupaged will allocate hugepage from the node has the max
+		 * hit record.
 		 */
-		if (node == NUMA_NO_NODE)
-			node = page_to_nid(page);
+		node = page_to_nid(page);
+		khugepaged_node_load[node]++;
 		VM_BUG_ON(PageCompound(page));
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;
@@ -2432,9 +2464,11 @@ static int khugepaged_scan_pmd(struct mm
 		ret = 1;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret)
+	if (ret) {
+		node = khugepaged_find_target_node();
 		/* collapse_huge_page will return with the mmap_sem released */
 		collapse_huge_page(mm, address, hpage, vma, node);
+	}
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from lliubbo@gmail.com are

mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch

