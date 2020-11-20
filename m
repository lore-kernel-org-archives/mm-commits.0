Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51D5C6379D
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDDB2415B
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Juh68nB2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgKTX7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTX7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:59:04 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D737C24101;
        Fri, 20 Nov 2020 23:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916743;
        bh=GQSbNBWziYJY8zHVXZBiXEKAYM4GuZVb1hIB/t95cx8=;
        h=Date:From:To:Subject:From;
        b=Juh68nB2xFkbfGWeHROUdINZV8NJ0wgDXFnfSyJ4yQOpbMm5PCLN14IZZun1ew61U
         79m6GEV7lS2EHRhva2EJISVlmiB09gzOAeu0h3M3LvlP+bCUkjJk9PAze9ci9t1usv
         UIz1sG00DbfeXU4QFh9Sn0Ae2j8Ku63xk+IHc74k=
Date:   Fri, 20 Nov 2020 15:59:02 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch added to
 -mm tree
Message-ID: <20201120235902.3YIJdXUp5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove flag argument from soft offline functions
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: remove flag argument from soft offline functions

The argument @flag no longer affects the behavior of soft_offline_page()
and its variants, so let's remove them.

Link: https://lkml.kernel.org/r/20201119105716.5962-6-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 include/linux/mm.h    |    2 +-
 mm/madvise.c          |    2 +-
 mm/memory-failure.c   |    9 ++++-----
 4 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/drivers/base/memory.c
@@ -464,7 +464,7 @@ static ssize_t soft_offline_page_store(s
 	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = soft_offline_page(pfn, 0);
+	ret = soft_offline_page(pfn);
 	return ret == 0 ? count : ret;
 }
 
--- a/include/linux/mm.h~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/include/linux/mm.h
@@ -3038,7 +3038,7 @@ extern int sysctl_memory_failure_early_k
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t num_poisoned_pages __read_mostly;
-extern int soft_offline_page(unsigned long pfn, int flags);
+extern int soft_offline_page(unsigned long pfn);
 
 
 /*
--- a/mm/madvise.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/mm/madvise.c
@@ -913,7 +913,7 @@ static int madvise_inject_error(int beha
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = soft_offline_page(pfn, 0);
+			ret = soft_offline_page(pfn);
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/mm/memory-failure.c
@@ -1572,7 +1572,7 @@ static void memory_failure_work_func(str
 		if (!gotten)
 			break;
 		if (entry.flags & MF_SOFT_OFFLINE)
-			soft_offline_page(entry.pfn, entry.flags);
+			soft_offline_page(entry.pfn);
 		else
 			memory_failure(entry.pfn, entry.flags);
 	}
@@ -1712,7 +1712,7 @@ EXPORT_SYMBOL(unpoison_memory);
  * We only incremented refcount in case the page was already in-use and it is
  * a known type we can handle.
  */
-static int get_any_page(struct page *p, int flags)
+static int get_any_page(struct page *p)
 {
 	int ret = 0, pass = 0;
 
@@ -1882,7 +1882,6 @@ static int soft_offline_free_page(struct
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
- * @flags: flags. Same as memory_failure().
  *
  * Returns 0 on success, otherwise negated errno.
  *
@@ -1901,7 +1900,7 @@ static int soft_offline_free_page(struct
  * This is not a 100% solution for all memory, but tries to be
  * ``good enough'' for the majority of memory.
  */
-int soft_offline_page(unsigned long pfn, int flags)
+int soft_offline_page(unsigned long pfn)
 {
 	int ret;
 	struct page *page;
@@ -1921,7 +1920,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_any_page(page, flags);
+	ret = get_any_page(page);
 	put_online_mems();
 
 	if (ret > 0) {
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

