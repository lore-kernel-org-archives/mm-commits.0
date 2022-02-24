Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6D1C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 02:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiBXC7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 21:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiBXC7D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 21:59:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A98B820B
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 18:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB724615C9
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 02:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB3FC340E7;
        Thu, 24 Feb 2022 02:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645671513;
        bh=sPnsXq5UK6bunG7cMKQ8cx9s5cpdoF+1DaHvJzKClMw=;
        h=Date:To:From:Subject:From;
        b=bw+ukh6VQOxfgJKwZ9FVNNC5Zwsw2aZBL2IYssASq8UEf69iZk2vBL6ynQG8d/tRq
         1gzRGovochrhXKv/ROKyVhSOrwfrzTlQQVvU/T4/OdLsu6z/M4JekCoFlds4sVuOli
         ua2kAbVH+eYinxHipMhqVA1lQS6SHzKZSERdUvcU=
Date:   Wed, 23 Feb 2022 18:58:32 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, luofei@unicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch added to -mm tree
Message-Id: <20220224025833.0CB3FC340E7@smtp.kernel.org>
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
should return a value(-EHWPOISON), otherwise mce handler regards the error
page has been identified and isolated, which may lead to calling
set_mce_nospec() to change page attribute, etc.

Here a new MF_MCE_HANDLE flag is introduced to identify the call from the
mce handler and instruct hwpoison_filter() to return -EHWPOISON, otherwise
return 0 for compatibility with the hwpoison injector.

Link: https://lkml.kernel.org/r/20220221021415.2328992-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mce/core.c |   15 +++++++++------
 include/linux/mm.h             |    1 +
 mm/memory-failure.c            |   14 ++++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/arch/x86/kernel/cpu/mce/core.c
@@ -612,7 +612,7 @@ static int uc_decode_notifier(struct not
 		return NOTIFY_DONE;
 
 	pfn = mce->addr >> PAGE_SHIFT;
-	if (!memory_failure(pfn, 0)) {
+	if (!memory_failure(pfn, MF_MCE_HANDLE)) {
 		set_mce_nospec(pfn, whole_page(mce));
 		mce->kflags |= MCE_HANDLED_UC;
 	}
@@ -1286,7 +1286,7 @@ static void kill_me_now(struct callback_
 static void kill_me_maybe(struct callback_head *cb)
 {
 	struct task_struct *p = container_of(cb, struct task_struct, mce_kill_me);
-	int flags = MF_ACTION_REQUIRED;
+	int flags = MF_ACTION_REQUIRED | MF_MCE_HANDLE;
 	int ret;
 
 	p->mce_count = 0;
@@ -1303,9 +1303,12 @@ static void kill_me_maybe(struct callbac
 	}
 
 	/*
-	 * -EHWPOISON from memory_failure() means that it already sent SIGBUS
-	 * to the current process with the proper error info, so no need to
-	 * send SIGBUS here again.
+	 * -EHWPOISON from memory_failure() means that memory_failure() did
+	 * not handle the error event for the following reason:
+	 *  - SIGBUS has already been sent to the current process with the
+	 *    proper error info, or
+	 *  - hwpoison_filter() filtered the event,
+	 * so no need to deal with it more.
 	 */
 	if (ret == -EHWPOISON)
 		return;
@@ -1320,7 +1323,7 @@ static void kill_me_never(struct callbac
 
 	p->mce_count = 0;
 	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
-	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, 0))
+	if (!memory_failure(p->mce_addr >> PAGE_SHIFT, MF_MCE_HANDLE))
 		set_mce_nospec(p->mce_addr >> PAGE_SHIFT, p->mce_whole_page);
 }
 
--- a/include/linux/mm.h~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/include/linux/mm.h
@@ -3177,6 +3177,7 @@ enum mf_flags {
 	MF_MUST_KILL = 1 << 2,
 	MF_SOFT_OFFLINE = 1 << 3,
 	MF_UNPOISON = 1 << 4,
+	MF_MCE_HANDLE = 1 << 5,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/mm/memory-failure.c~mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler
+++ a/mm/memory-failure.c
@@ -1515,7 +1515,10 @@ static int memory_failure_hugetlb(unsign
 				if (TestClearPageHWPoison(head))
 					num_poisoned_pages_dec();
 				unlock_page(head);
-				return 0;
+				if (flags & MF_MCE_HANDLE)
+					return -EHWPOISON;
+				else
+					return 0;
 			}
 			unlock_page(head);
 			res = MF_FAILED;
@@ -1602,7 +1605,10 @@ static int memory_failure_dev_pagemap(un
 		goto out;
 
 	if (hwpoison_filter(page)) {
-		rc = 0;
+		if (flags & MF_MCE_HANDLE)
+			rc = -EHWPOISON;
+		else
+			rc = 0;
 		goto unlock;
 	}
 
@@ -1836,6 +1842,10 @@ try_again:
 			num_poisoned_pages_dec();
 		unlock_page(p);
 		put_page(p);
+		if (flags & MF_MCE_HANDLE)
+			res = -EHWPOISON;
+		else
+			res = 0;
 		goto unlock_mutex;
 	}
 
_

Patches currently in -mm which might be from luofei@unicloud.com are

mm-hwpoison-avoid-the-impact-of-hwpoison_filter-return-value-on-mce-handler.patch
mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

