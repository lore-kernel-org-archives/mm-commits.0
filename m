Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56B5C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A88A611CB
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhEVWLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 18:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhEVWLK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 18:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C856610A2;
        Sat, 22 May 2021 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621721385;
        bh=p/ijnhUNRzgiNvTIXdMzepSd8QjJt6YCBsBzqmfv/I8=;
        h=Date:From:To:Subject:From;
        b=K0oRWQQ32nIrRm6FlmgPzFPEKNYsSOTQyJ9RSI534xm/U2jjpNr4EF4XUtEzdhi/e
         m3c4u7bEu2sHDD0nITfOIwTy+y8ZU6MewPkSRFzv0ZqlVIfTY7+WjcNaWP3vwfmEmv
         rXMh0cX8p1nKFH1eLmRBJNp0Pl/lFodXp5c+H7Uw=
Date:   Sat, 22 May 2021 15:09:44 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, bp@suse.de, david@redhat.com, juew@google.com,
        luto@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        yaoaili@kingsoft.com
Subject:  +
 mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch added to
 -mm tree
Message-ID: <20210522220944.IAnPuLnAQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: use a mutex to avoid memory_failure() races
has been added to the -mm tree.  Its filename is
     mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memory-failure: use a mutex to avoid memory_failure() races

Patch series "mm,hwpoison: fix sending SIGBUS for Action Required MCE", v5.

I wrote this patchset to materialize what I think is the current allowable
solution mentioned by the previous discussion [1].  I simply borrowed
Tony's mutex patch and Aili's return code patch, then I queued another one
to find error virtual address in the best effort manner.  I know that this
is not a perfect solution, but should work for some typical case.

[1]: https://lore.kernel.org/linux-mm/20210331192540.2141052f@alex-virtual-machine/


This patch (of 3):

There can be races when multiple CPUs consume poison from the same page. 
The first into memory_failure() atomically sets the HWPoison page flag and
begins hunting for tasks that map this page.  Eventually it invalidates
those mappings and may send a SIGBUS to the affected tasks.

But while all that work is going on, other CPUs see a "success" return
code from memory_failure() and so they believe the error has been handled
and continue executing.

Fix by wrapping most of the internal parts of memory_failure() in a mutex.

Link: https://lkml.kernel.org/r/20210521030156.2612074-1-nao.horiguchi@gmail.com
Link: https://lkml.kernel.org/r/20210521030156.2612074-2-nao.horiguchi@gmail.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races
+++ a/mm/memory-failure.c
@@ -1397,6 +1397,8 @@ out:
 	return rc;
 }
 
+static DEFINE_MUTEX(mf_mutex);
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1420,7 +1422,7 @@ int memory_failure(unsigned long pfn, in
 	struct page *hpage;
 	struct page *orig_head;
 	struct dev_pagemap *pgmap;
-	int res;
+	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
 
@@ -1440,13 +1442,18 @@ int memory_failure(unsigned long pfn, in
 		return -ENXIO;
 	}
 
+	mutex_lock(&mf_mutex);
+
 try_again:
-	if (PageHuge(p))
-		return memory_failure_hugetlb(pfn, flags);
+	if (PageHuge(p)) {
+		res = memory_failure_hugetlb(pfn, flags);
+		goto unlock_mutex;
+	}
+
 	if (TestSetPageHWPoison(p)) {
 		pr_err("Memory failure: %#lx: already hardware poisoned\n",
 			pfn);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	orig_head = hpage = compound_head(p);
@@ -1479,17 +1486,19 @@ try_again:
 				res = MF_FAILED;
 			}
 			action_result(pfn, MF_MSG_BUDDY, res);
-			return res == MF_RECOVERED ? 0 : -EBUSY;
+			res = res == MF_RECOVERED ? 0 : -EBUSY;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
 		}
+		goto unlock_mutex;
 	}
 
 	if (PageTransHuge(hpage)) {
 		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			return -EBUSY;
+			res = -EBUSY;
+			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
@@ -1513,7 +1522,7 @@ try_again:
 	if (PageCompound(p) && compound_head(p) != orig_head) {
 		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1533,14 +1542,14 @@ try_again:
 		num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
-		return 0;
+		goto unlock_mutex;
 	}
 
 	if (!PageTransTail(p) && !PageLRU(p))
@@ -1559,7 +1568,7 @@ try_again:
 	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 	/*
@@ -1568,13 +1577,15 @@ try_again:
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
 		action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		res = -EBUSY;
-		goto out;
+		goto unlock_page;
 	}
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
-out:
+unlock_page:
 	unlock_page(p);
+unlock_mutex:
+	mutex_unlock(&mf_mutex);
 	return res;
 }
 EXPORT_SYMBOL_GPL(memory_failure);
_

Patches currently in -mm which might be from tony.luck@intel.com are

mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch

