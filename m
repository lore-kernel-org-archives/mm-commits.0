From: akpm@linux-foundation.org
Subject: + mm-swapfilec-fix-comment-typos.patch added to -mm tree
Date: Mon, 07 Oct 2013 14:57:14 -0700
Message-ID: <52532e3a.tFwMq0j14dqcHkXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3JGV5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 17:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com

Subject: + mm-swapfilec-fix-comment-typos.patch added to -mm tree
To: sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 14:57:14 -0700


The patch titled
     Subject: mm/swapfile.c: fix comment typos
has been added to the -mm tree.  Its filename is
     mm-swapfilec-fix-comment-typos.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-fix-comment-typos.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-fix-comment-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: mm/swapfile.c: fix comment typos

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~mm-swapfilec-fix-comment-typos mm/swapfile.c
--- a/mm/swapfile.c~mm-swapfilec-fix-comment-typos
+++ a/mm/swapfile.c
@@ -707,7 +707,7 @@ noswap:
 	return (swp_entry_t) {0};
 }
 
-/* The only caller of this function is now susupend routine */
+/* The only caller of this function is now suspend routine */
 swp_entry_t get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si;
@@ -845,7 +845,7 @@ static unsigned char swap_entry_free(str
 }
 
 /*
- * Caller has made sure that the swapdevice corresponding to entry
+ * Caller has made sure that the swap device corresponding to entry
  * is still around or has not been recycled.
  */
 void swap_free(swp_entry_t entry)
@@ -947,7 +947,7 @@ int try_to_free_swap(struct page *page)
 	 * original page might be freed under memory pressure, then
 	 * later read back in from swap, now with the wrong data.
 	 *
-	 * Hibration suspends storage while it is writing the image
+	 * Hibernation suspends storage while it is writing the image
 	 * to disk so check that here.
 	 */
 	if (pm_suspended_storage())
@@ -1179,7 +1179,7 @@ static int unuse_pte_range(struct vm_are
 	 * some architectures (e.g. x86_32 with PAE) we might catch a glimpse
 	 * of unmatched parts which look like swp_pte, so unuse_pte must
 	 * recheck under pte lock.  Scanning without pte lock lets it be
-	 * preemptible whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
+	 * preemptable whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
 	 */
 	pte = pte_offset_map(pmd, addr);
 	do {
@@ -1932,7 +1932,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	vfree(swap_map);
 	vfree(cluster_info);
 	vfree(frontswap_map);
-	/* Destroy swap account informatin */
+	/* Destroy swap account information */
 	swap_cgroup_swapoff(type);
 
 	inode = mapping->host;
@@ -2784,8 +2784,8 @@ int add_swap_count_continuation(swp_entr
 
 	/*
 	 * We are fortunate that although vmalloc_to_page uses pte_offset_map,
-	 * no architecture is using highmem pages for kernel pagetables: so it
-	 * will not corrupt the GFP_ATOMIC caller's atomic pagetable kmaps.
+	 * no architecture is using highmem pages for kernel page tables: so it
+	 * will not corrupt the GFP_ATOMIC caller's atomic page table kmaps.
 	 */
 	head = vmalloc_to_page(si->swap_map + offset);
 	offset &= ~PAGE_MASK;
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

documentation-vm-zswaptxt-fix-typos.patch
mm-swapfilec-fix-comment-typos.patch

