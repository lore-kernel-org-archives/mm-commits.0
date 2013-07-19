From: akpm@linux-foundation.org
Subject: + mm-replace-strict_strtoul-with-kstrtoul.patch added to -mm tree
Date: Fri, 19 Jul 2013 15:02:06 -0700
Message-ID: <51e9b75e.eQ42vSCVvOU5v2lf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3GSWCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + mm-replace-strict_strtoul-with-kstrtoul.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:02:06 -0700


The patch titled
     Subject: mm: replace strict_strtoul() with kstrtoul()
has been added to the -mm tree.  Its filename is
     mm-replace-strict_strtoul-with-kstrtoul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-strict_strtoul-with-kstrtoul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-strict_strtoul-with-kstrtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: mm: replace strict_strtoul() with kstrtoul()

The use of strict_strtoul() is not preferred, because strict_strtoul() is
obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++----
 mm/hugetlb.c     |    4 ++--
 mm/kmemleak.c    |    2 +-
 mm/ksm.c         |    6 +++---
 mm/slub.c        |    8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/huge_memory.c~mm-replace-strict_strtoul-with-kstrtoul mm/huge_memory.c
--- a/mm/huge_memory.c~mm-replace-strict_strtoul-with-kstrtoul
+++ a/mm/huge_memory.c
@@ -417,7 +417,7 @@ static ssize_t scan_sleep_millisecs_stor
 	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
+	err = kstrtoul(buf, 10, &msecs);
 	if (err || msecs > UINT_MAX)
 		return -EINVAL;
 
@@ -444,7 +444,7 @@ static ssize_t alloc_sleep_millisecs_sto
 	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
+	err = kstrtoul(buf, 10, &msecs);
 	if (err || msecs > UINT_MAX)
 		return -EINVAL;
 
@@ -470,7 +470,7 @@ static ssize_t pages_to_scan_store(struc
 	int err;
 	unsigned long pages;
 
-	err = strict_strtoul(buf, 10, &pages);
+	err = kstrtoul(buf, 10, &pages);
 	if (err || !pages || pages > UINT_MAX)
 		return -EINVAL;
 
@@ -538,7 +538,7 @@ static ssize_t khugepaged_max_ptes_none_
 	int err;
 	unsigned long max_ptes_none;
 
-	err = strict_strtoul(buf, 10, &max_ptes_none);
+	err = kstrtoul(buf, 10, &max_ptes_none);
 	if (err || max_ptes_none > HPAGE_PMD_NR-1)
 		return -EINVAL;
 
diff -puN mm/hugetlb.c~mm-replace-strict_strtoul-with-kstrtoul mm/hugetlb.c
--- a/mm/hugetlb.c~mm-replace-strict_strtoul-with-kstrtoul
+++ a/mm/hugetlb.c
@@ -1526,7 +1526,7 @@ static ssize_t nr_hugepages_store_common
 	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
-	err = strict_strtoul(buf, 10, &count);
+	err = kstrtoul(buf, 10, &count);
 	if (err)
 		goto out;
 
@@ -1617,7 +1617,7 @@ static ssize_t nr_overcommit_hugepages_s
 	if (h->order >= MAX_ORDER)
 		return -EINVAL;
 
-	err = strict_strtoul(buf, 10, &input);
+	err = kstrtoul(buf, 10, &input);
 	if (err)
 		return err;
 
diff -puN mm/kmemleak.c~mm-replace-strict_strtoul-with-kstrtoul mm/kmemleak.c
--- a/mm/kmemleak.c~mm-replace-strict_strtoul-with-kstrtoul
+++ a/mm/kmemleak.c
@@ -1639,7 +1639,7 @@ static ssize_t kmemleak_write(struct fil
 	else if (strncmp(buf, "scan=", 5) == 0) {
 		unsigned long secs;
 
-		ret = strict_strtoul(buf + 5, 0, &secs);
+		ret = kstrtoul(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
 		stop_scan_thread();
diff -puN mm/ksm.c~mm-replace-strict_strtoul-with-kstrtoul mm/ksm.c
--- a/mm/ksm.c~mm-replace-strict_strtoul-with-kstrtoul
+++ a/mm/ksm.c
@@ -2194,7 +2194,7 @@ static ssize_t sleep_millisecs_store(str
 	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
+	err = kstrtoul(buf, 10, &msecs);
 	if (err || msecs > UINT_MAX)
 		return -EINVAL;
 
@@ -2217,7 +2217,7 @@ static ssize_t pages_to_scan_store(struc
 	int err;
 	unsigned long nr_pages;
 
-	err = strict_strtoul(buf, 10, &nr_pages);
+	err = kstrtoul(buf, 10, &nr_pages);
 	if (err || nr_pages > UINT_MAX)
 		return -EINVAL;
 
@@ -2239,7 +2239,7 @@ static ssize_t run_store(struct kobject
 	int err;
 	unsigned long flags;
 
-	err = strict_strtoul(buf, 10, &flags);
+	err = kstrtoul(buf, 10, &flags);
 	if (err || flags > UINT_MAX)
 		return -EINVAL;
 	if (flags > KSM_RUN_UNMERGE)
diff -puN mm/slub.c~mm-replace-strict_strtoul-with-kstrtoul mm/slub.c
--- a/mm/slub.c~mm-replace-strict_strtoul-with-kstrtoul
+++ a/mm/slub.c
@@ -4423,7 +4423,7 @@ static ssize_t order_store(struct kmem_c
 	unsigned long order;
 	int err;
 
-	err = strict_strtoul(buf, 10, &order);
+	err = kstrtoul(buf, 10, &order);
 	if (err)
 		return err;
 
@@ -4451,7 +4451,7 @@ static ssize_t min_partial_store(struct
 	unsigned long min;
 	int err;
 
-	err = strict_strtoul(buf, 10, &min);
+	err = kstrtoul(buf, 10, &min);
 	if (err)
 		return err;
 
@@ -4471,7 +4471,7 @@ static ssize_t cpu_partial_store(struct
 	unsigned long objects;
 	int err;
 
-	err = strict_strtoul(buf, 10, &objects);
+	err = kstrtoul(buf, 10, &objects);
 	if (err)
 		return err;
 	if (objects && !kmem_cache_has_cpu_partial(s))
@@ -4787,7 +4787,7 @@ static ssize_t remote_node_defrag_ratio_
 	unsigned long ratio;
 	int err;
 
-	err = strict_strtoul(buf, 10, &ratio);
+	err = kstrtoul(buf, 10, &ratio);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
linux-next.patch

