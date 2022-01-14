Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C45C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiANWJG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWJG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A7C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E03A3B825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40547C36AE5;
        Fri, 14 Jan 2022 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198143;
        bh=8YVev0luQKHfSKmGcdBlF001qT6IsletKbXz5bXpA98=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OTRHQqQnj2pX4SESqTWgsFLqYHEdBltIPHwFXzIie3Heq/G62exfY+MRBEOYrwvsG
         EC/lF1M2vsixT54b/bb+TFw6I/HoJT4SUH+GIRRr5CBbx1U5CvYPfDrpa7IjAJ0v+k
         PiD1SxpFE1+y5EvYVzma2KgxGNPwVOIHO4QC0JOQ=
Date:   Fri, 14 Jan 2022 14:09:02 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        david@redhat.com, dinghui@sangfor.com.cn, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterx@redhat.com,
        shy828301@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 111/146] mm/hwpoison: mf_mutex for soft offline
 and unpoison
Message-ID: <20220114220902.48bKohjgW%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: mf_mutex for soft offline and unpoison

Patch series "mm/hwpoison: fix unpoison_memory()", v4.

Main purpose of this series is to sync unpoison code to recent changes
around how hwpoison code takes page refcount.  Unpoison should work or
simply fail (without crash) if impossible.

The recent works of keeping hwpoison pages in shmem pagecache introduce a
new state of hwpoisoned pages, but unpoison for such pages is not
supported yet with this series.

It seems that soft-offline and unpoison can be used as general purpose
page offline/online mechanism (not in the context of memory error).  I
think that we need some additional works to realize it because currently
soft-offline and unpoison are assumed not to happen so frequently (print
out too many messages for aggressive usecases).  But anyway this could be
another interesting next topic.

v1: https://lore.kernel.org/linux-mm/20210614021212.223326-1-nao.horiguchi@gmail.com/
v2: https://lore.kernel.org/linux-mm/20211025230503.2650970-1-naoya.horiguchi@linux.dev/
v3: https://lore.kernel.org/linux-mm/20211105055058.3152564-1-naoya.horiguchi@linux.dev/


This patch (of 3):

Originally mf_mutex is introduced to serialize multiple MCE events, but it
is not that useful to allow unpoison to run in parallel with
memory_failure() and soft offline.  So apply mf_mutex to soft offline and
unpoison.  The memory failure handler and soft offline handler get simpler
with this.

Link: https://lkml.kernel.org/r/20211115084006.3728254-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20211115084006.3728254-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ding Hui <dinghui@sangfor.com.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   62 ++++++++++++------------------------------
 1 file changed, 18 insertions(+), 44 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-mf_mutex-for-soft-offline-and-unpoison
+++ a/mm/memory-failure.c
@@ -1502,14 +1502,6 @@ static int memory_failure_hugetlb(unsign
 	lock_page(head);
 	page_flags = head->flags;
 
-	if (!PageHWPoison(head)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
-		unlock_page(head);
-		put_page(head);
-		return 0;
-	}
-
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
@@ -1623,6 +1615,8 @@ out:
 	return rc;
 }
 
+static DEFINE_MUTEX(mf_mutex);
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1649,7 +1643,6 @@ int memory_failure(unsigned long pfn, in
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	static DEFINE_MUTEX(mf_mutex);
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1783,16 +1776,6 @@ try_again:
 	 */
 	page_flags = p->flags;
 
-	/*
-	 * unpoison always clear PG_hwpoison inside page lock
-	 */
-	if (!PageHWPoison(p)) {
-		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
-		num_poisoned_pages_dec();
-		unlock_page(p);
-		put_page(p);
-		goto unlock_mutex;
-	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
@@ -1973,6 +1956,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
+	int ret = 0;
 	unsigned long flags = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
@@ -1983,39 +1967,30 @@ int unpoison_memory(unsigned long pfn)
 	p = pfn_to_page(pfn);
 	page = compound_head(p);
 
+	mutex_lock(&mf_mutex);
+
 	if (!PageHWPoison(p)) {
 		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_count(page) > 1) {
 		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapped(page)) {
 		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (page_mapping(page)) {
 		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
-	}
-
-	/*
-	 * unpoison_memory() can encounter thp only when the thp is being
-	 * worked by memory_failure() and the page lock is not held yet.
-	 * In such case, we yield to memory_failure() and make unpoison fail.
-	 */
-	if (!PageHuge(page) && PageTransHuge(page)) {
-		unpoison_pr_info("Unpoison: Memory failure is now running on %#lx\n",
-				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (!get_hwpoison_page(p, flags)) {
@@ -2023,29 +1998,23 @@ int unpoison_memory(unsigned long pfn)
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
 				 pfn, &unpoison_rs);
-		return 0;
+		goto unlock_mutex;
 	}
 
-	lock_page(page);
-	/*
-	 * This test is racy because PG_hwpoison is set outside of page lock.
-	 * That's acceptable because that won't trigger kernel panic. Instead,
-	 * the PG_hwpoison page will be caught and isolated on the entrance to
-	 * the free buddy page pool.
-	 */
 	if (TestClearPageHWPoison(page)) {
 		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
 				 pfn, &unpoison_rs);
 		num_poisoned_pages_dec();
 		freeit = 1;
 	}
-	unlock_page(page);
 
 	put_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
 		put_page(page);
 
-	return 0;
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(unpoison_memory);
 
@@ -2226,9 +2195,12 @@ int soft_offline_page(unsigned long pfn,
 		return -EIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
 		put_ref_page(ref_page);
+		mutex_unlock(&mf_mutex);
 		return 0;
 	}
 
@@ -2247,5 +2219,7 @@ retry:
 		}
 	}
 
+	mutex_unlock(&mf_mutex);
+
 	return ret;
 }
_
