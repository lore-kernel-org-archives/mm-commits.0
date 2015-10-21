From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-optimize-when-numa=n.patch added to -mm tree
Date: Wed, 21 Oct 2015 13:41:21 -0700
Message-ID: <5627f871.JOcMfFrlN+rc2tKv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbJUUlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlbfs: optimize when NUMA=n
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-optimize-when-numa=n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-optimize-when-numa%3Dn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-optimize-when-numa%3Dn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm, hugetlbfs: optimize when NUMA=n

My recent patch "mm, hugetlb: use memory policy when available" added some
bloat to hugetlb.o.  This patch aims to get some of the bloat back,
especially when NUMA is not in play.

It does this with an implicit #ifdef and marking some things static that
should have been static in my first patch.  It also makes the warnings
only VM_WARN_ON()s.  They were responsible for a pretty big chunk of the
bloat.

Doing this gets our NUMA=n text size back to a wee bit _below_ where we
started before the original patch.

It also shaves a bit of space off the NUMA=y case, but not much. 
Enforcing the mempolicy definitely takes some text and it's hard to avoid.

size(1) output:

   text	   data	    bss	    dec	    hex	filename
  30745	   3433	   2492	  36670	   8f3e	hugetlb.o.nonuma.baseline
  31305	   3755	   2492	  37552	   92b0	hugetlb.o.nonuma.patch1
  30713	   3433	   2492	  36638	   8f1e	hugetlb.o.nonuma.patch2 (this patch)
  25235	    473	  41276	  66984	  105a8	hugetlb.o.numa.baseline
  25715	    475	  41276	  67466	  1078a	hugetlb.o.numa.patch1
  25491	    473	  41276	  67240	  106a8	hugetlb.o.numa.patch2 (this patch)

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbfs-optimize-when-numa=n mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbfs-optimize-when-numa=n
+++ a/mm/hugetlb.c
@@ -1455,9 +1455,14 @@ static struct page *__hugetlb_alloc_budd
 
 	/*
 	 * We need a VMA to get a memory policy.  If we do not
-	 * have one, we use the 'nid' argument
+	 * have one, we use the 'nid' argument.
+	 *
+	 * The mempolicy stuff below has some non-inlined bits
+	 * and calls ->vm_ops.  That makes it hard to optimize at
+	 * compile-time, even when NUMA is off and it does
+	 * nothing.  This helps the compiler optimize it out.
 	 */
-	if (!vma) {
+	if (!IS_ENABLED(CONFIG_NUMA) || !vma) {
 		/*
 		 * If a specific node is requested, make sure to
 		 * get memory from there, but only when a node
@@ -1474,7 +1479,8 @@ static struct page *__hugetlb_alloc_budd
 
 	/*
 	 * OK, so we have a VMA.  Fetch the mempolicy and try to
-	 * allocate a huge page with it.
+	 * allocate a huge page with it.  We will only reach this
+	 * when CONFIG_NUMA=y.
 	 */
 	do {
 		struct page *page;
@@ -1515,8 +1521,8 @@ static struct page *__alloc_buddy_huge_p
 		return NULL;
 
 	if (vma || addr) {
-		WARN_ON_ONCE(!addr || addr == -1);
-		WARN_ON_ONCE(nid != NUMA_NO_NODE);
+		VM_WARN_ON_ONCE(!addr || addr == -1);
+		VM_WARN_ON_ONCE(nid != NUMA_NO_NODE);
 	}
 	/*
 	 * Assume we will successfully allocate the surplus page to
@@ -1580,6 +1586,7 @@ static struct page *__alloc_buddy_huge_p
  * NUMA_NO_NODE, which means that it may be allocated
  * anywhere.
  */
+static
 struct page *__alloc_buddy_huge_page_no_mpol(struct hstate *h, int nid)
 {
 	unsigned long addr = -1;
@@ -1590,6 +1597,7 @@ struct page *__alloc_buddy_huge_page_no_
 /*
  * Use the VMA's mpolicy to allocate a huge page from the buddy.
  */
+static
 struct page *__alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

inotify-hide-internal-kernel-bits-from-fdinfo.patch
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch
mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlbfs-optimize-when-numa=n.patch

