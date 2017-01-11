From: akpm@linux-foundation.org
Subject: + mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch added to -mm tree
Date: Wed, 11 Jan 2017 15:42:43 -0800
Message-ID: <5876c2f3.dBieZH1f0YToy0pR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757626AbdAKXnG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: skip readahead for unreferenced swap slots
has been added to the -mm tree.  Its filename is
     mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap: skip readahead for unreferenced swap slots

We can avoid needlessly allocating page for swap slots that are not used
by anyone.  No pages have to be read in for these slots.

Link: http://lkml.kernel.org/r/0784b3f20b9bd3aa5552219624cb78dc4ae710c9.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++++
 mm/swap_state.c      |    4 +++
 mm/swapfile.c        |   47 +++++++++++++++++++++++++++++++++++------
 3 files changed, 51 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-swap-skip-read-ahead-for-unreferenced-swap-slots include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-skip-read-ahead-for-unreferenced-swap-slots
+++ a/include/linux/swap.h
@@ -397,6 +397,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern bool reuse_swap_page(struct page *, int *);
@@ -490,6 +491,11 @@ static inline int page_swapcount(struct
 {
 	return 0;
 }
+
+static inline int __swp_swapcount(swp_entry_t entry)
+{
+	return 0;
+}
 
 static inline int swp_swapcount(swp_entry_t entry)
 {
diff -puN mm/swap_state.c~mm-swap-skip-read-ahead-for-unreferenced-swap-slots mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-skip-read-ahead-for-unreferenced-swap-slots
+++ a/mm/swap_state.c
@@ -323,6 +323,10 @@ struct page *__read_swap_cache_async(swp
 		if (found_page)
 			break;
 
+		/* Just skip read ahead for unused swap slot */
+		if (!__swp_swapcount(entry))
+			return NULL;
+
 		/*
 		 * Get a new page to read into from swap.
 		 */
diff -puN mm/swapfile.c~mm-swap-skip-read-ahead-for-unreferenced-swap-slots mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-skip-read-ahead-for-unreferenced-swap-slots
+++ a/mm/swapfile.c
@@ -803,7 +803,7 @@ swp_entry_t get_swap_page_of_type(int ty
 	return (swp_entry_t) {0};
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
+static struct swap_info_struct *__swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 	unsigned long offset, type;
@@ -819,13 +819,8 @@ static struct swap_info_struct *_swap_in
 	offset = swp_offset(entry);
 	if (offset >= p->max)
 		goto bad_offset;
-	if (!p->swap_map[offset])
-		goto bad_free;
 	return p;
 
-bad_free:
-	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
-	goto out;
 bad_offset:
 	pr_err("swap_info_get: %s%08lx\n", Bad_offset, entry.val);
 	goto out;
@@ -838,6 +833,24 @@ out:
 	return NULL;
 }
 
+static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
+{
+	struct swap_info_struct *p;
+
+	p = __swap_info_get(entry);
+	if (!p)
+		goto out;
+	if (!p->swap_map[swp_offset(entry)])
+		goto bad_free;
+	return p;
+
+bad_free:
+	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
+	goto out;
+out:
+	return NULL;
+}
+
 static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
@@ -990,6 +1003,28 @@ int page_swapcount(struct page *page)
 	}
 	return count;
 }
+
+/*
+ * How many references to @entry are currently swapped out?
+ * This does not give an exact answer when swap count is continued,
+ * but does include the high COUNT_CONTINUED flag to allow for that.
+ */
+int __swp_swapcount(swp_entry_t entry)
+{
+	int count = 0;
+	pgoff_t offset;
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+
+	si = __swap_info_get(entry);
+	if (si) {
+		offset = swp_offset(entry);
+		ci = lock_cluster_or_swap_info(si, offset);
+		count = swap_count(si->swap_map[offset]);
+		unlock_cluster_or_swap_info(si, ci);
+	}
+	return count;
+}
 
 /*
  * How many references to @entry are currently swapped out?
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
mm-swap-allocate-swap-slots-in-batches.patch
mm-swap-free-swap-slots-in-batch.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-enable-swap-slots-cache-usage.patch

