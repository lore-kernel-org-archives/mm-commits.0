From: akpm@linux-foundation.org
Subject: [merged] thp-set-recommended-min-free-kbytes.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:01 -0800
Message-ID: <201101142250.p0EMop8h005445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab1ANWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: set recommended min free kbytes
has been removed from the -mm tree.  Its filename was
     thp-set-recommended-min-free-kbytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: set recommended min free kbytes
From: Andrea Arcangeli <aarcange@redhat.com>

If transparent hugepage is enabled initialize min_free_kbytes to an
optimal value by default.  This moves the hugeadm algorithm in kernel.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff -puN mm/huge_memory.c~thp-set-recommended-min-free-kbytes mm/huge_memory.c
--- a/mm/huge_memory.c~thp-set-recommended-min-free-kbytes
+++ a/mm/huge_memory.c
@@ -85,6 +85,47 @@ struct khugepaged_scan {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
+
+static int set_recommended_min_free_kbytes(void)
+{
+	struct zone *zone;
+	int nr_zones = 0;
+	unsigned long recommended_min;
+	extern int min_free_kbytes;
+
+	if (!test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) &&
+	    !test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags))
+		return 0;
+
+	for_each_populated_zone(zone)
+		nr_zones++;
+
+	/* Make sure at least 2 hugepages are free for MIGRATE_RESERVE */
+	recommended_min = pageblock_nr_pages * nr_zones * 2;
+
+	/*
+	 * Make sure that on average at least two pageblocks are almost free
+	 * of another type, one for a migratetype to fall back to and a
+	 * second to avoid subsequent fallbacks of other types There are 3
+	 * MIGRATE_TYPES we care about.
+	 */
+	recommended_min += pageblock_nr_pages * nr_zones *
+			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
+
+	/* don't ever allow to reserve more than 5% of the lowmem */
+	recommended_min = min(recommended_min,
+			      (unsigned long) nr_free_buffer_pages() / 20);
+	recommended_min <<= (PAGE_SHIFT-10);
+
+	if (recommended_min > min_free_kbytes)
+		min_free_kbytes = recommended_min;
+	setup_per_zone_wmarks();
+	return 0;
+}
+late_initcall(set_recommended_min_free_kbytes);
+
 static int start_khugepaged(void)
 {
 	int err = 0;
@@ -108,6 +149,8 @@ static int start_khugepaged(void)
 		mutex_unlock(&khugepaged_mutex);
 		if (wakeup)
 			wake_up_interruptible(&khugepaged_wait);
+
+		set_recommended_min_free_kbytes();
 	} else
 		/* wakeup to exit */
 		wake_up_interruptible(&khugepaged_wait);
@@ -177,6 +220,13 @@ static ssize_t enabled_store(struct kobj
 			ret = err;
 	}
 
+	if (ret > 0 &&
+	    (test_bit(TRANSPARENT_HUGEPAGE_FLAG,
+		      &transparent_hugepage_flags) ||
+	     test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+		      &transparent_hugepage_flags)))
+		set_recommended_min_free_kbytes();
+
 	return ret;
 }
 static struct kobj_attribute enabled_attr =
@@ -464,6 +514,8 @@ static int __init hugepage_init(void)
 
 	start_khugepaged();
 
+	set_recommended_min_free_kbytes();
+
 out:
 	return err;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

