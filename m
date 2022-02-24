Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ACFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiBXEjE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiBXEjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:39:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D371E2FF0
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:38:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC7356177F
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E872C340E9;
        Thu, 24 Feb 2022 04:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677513;
        bh=um1GVrr9JVyVsaXCqCmuIiGR/iKPidGXPbGVv0VYFpI=;
        h=Date:To:From:Subject:From;
        b=ZvOijgiLMOWouPSXvbjOhdjJFriv77ridFQMyp/54swpcVrWRUpasD6DtKTuGHJ5L
         ulW7wGtXIJsqC73wvso9smywsyOcrJtV5P8sDIwJOD+J7Nd7lbZ5ktCKvPb+C2qmKB
         cFOgQ96QGz+1ygG66KM4w9kHJ5sEGuU2I4b+7Ezo=
Date:   Wed, 23 Feb 2022 20:38:32 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@suse.de, luofei@unicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch added to -mm tree
Message-Id: <20220224043833.2E872C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler
has been added to the -mm tree.  Its filename is
     mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: avoid the impact of hwpoison_filter() return value on mce handler

When the hwpoison page meets the filter conditions, it should not be
regarded as successful memory_failure() processing for mce handler, but
should return a distinct value, otherwise mce handler regards the error
page has been identified and isolated, which may lead to calling
set_mce_nospec() to change page attribute, etc.

Here memory_failure() return -EOPNOTSUPP to indicate that the error event
is filtered, mce handler should not take any action for this situation and
hwpoison injector should treat as correct.

Link: https://lkml.kernel.org/r/20220223082135.2769649-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |    8 +++++---
 drivers/base/memory.c          |    2 ++
 mm/hwpoison-inject.c           |    3 ++-
 mm/madvise.c                   |    2 ++
 mm/memory-failure.c            |    9 +++++++--
 5 files changed, 18 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -1304,10 +1304,12 @@ static void kill_me_maybe(struct callbac
 
 	/*
 	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
-	 * to the current process with the proper error info, so no need to
-	 * send SIGBUS here again.
+	 * to the current process with the proper error info,
+	 * -EOPNOTSUPP means hwpoison_filter() filtered the error event,
+	 *
+	 * In both cases, no further processing is required.
 	 */
-	if (ret == -EHWPOISON)
+	if (ret == -EHWPOISON || ret == -EOPNOTSUPP)
 		return;
 
 	pr_err("Memory error not recovered");
--- a/drivers/base/memory.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/drivers/base/memory.c
@@ -555,6 +555,8 @@ static ssize_t hard_offline_page_store(s
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
 	ret = memory_failure(pfn, 0);
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
 	return ret ? ret : count;
 }
 
--- a/mm/hwpoison-inject.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/hwpoison-inject.c
@@ -48,7 +48,8 @@ static int hwpoison_inject(void *data, u
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	return memory_failure(pfn, 0);
+	err = memory_failure(pfn, 0);
+	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
--- a/mm/madvise.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/madvise.c
@@ -1067,6 +1067,8 @@ static int madvise_inject_error(int beha
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
 			ret = memory_failure(pfn, MF_COUNT_INCREASED);
+			if (ret == -EOPNOTSUPP)
+				ret = 0;
 		}
 
 		if (ret)
--- a/mm/memory-failure.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/memory-failure.c
@@ -1515,7 +1515,7 @@ static int memory_failure_hugetlb(unsign
 				if (TestClearPageHWPoison(head))
 					num_poisoned_pages_dec();
 				unlock_page(head);
-				return 0;
+				return -EOPNOTSUPP;
 			}
 			unlock_page(head);
 			res = MF_FAILED;
@@ -1602,7 +1602,7 @@ static int memory_failure_dev_pagemap(un
 		goto out;
 
 	if (hwpoison_filter(page)) {
-		rc = 0;
+		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
 
@@ -1671,6 +1671,10 @@ static DEFINE_MUTEX(mf_mutex);
  *
  * Must run in process context (e.g. a work queue) with interrupts
  * enabled and no spinlocks hold.
+ *
+ * Return: 0 for successfully handled the memory error,
+ *         -EOPNOTSUPP for memory_filter() filtered the error event,
+ *         < 0(except -EOPNOTSUPP) on failure.
  */
 int memory_failure(unsigned long pfn, int flags)
 {
@@ -1836,6 +1840,7 @@ try_again:
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
+		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from luofei@unicloud.com are

mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

