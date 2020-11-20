Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F5AC56202
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2463F24171
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A2XF063b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgKTX67 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTX67 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:58:59 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C690A23A6B;
        Fri, 20 Nov 2020 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916738;
        bh=WGtN4N7vfpSGkj+sIoivGQoBpvorEjtY0qDPv8UNmhA=;
        h=Date:From:To:Subject:From;
        b=A2XF063boO/rC8Xh9VK93EH1Da99uP2qccRTgyz/R5LN3q9GW5IwfHze4M2F1nX3L
         nH4yt1vNRxB8F4v5nbUaWURb7Fun6MIWqlFJvaoT1FJg6Ha+ivM6IIRH2gxlVf0l3t
         M7YVogm898Y/sNnPcrXlf35r1bgWE6cXERrxRzK8=
Date:   Fri, 20 Nov 2020 15:58:58 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 mmmadvise-call-soft_offline_page-without-mf_count_increased.patch added to
 -mm tree
Message-ID: <20201120235858.sT1j0SdM4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,madvise: call soft_offline_page() without MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mmmadvise-call-soft_offline_page-without-mf_count_increased.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmmadvise-call-soft_offline_page-without-mf_count_increased.patch

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
Subject: mm,madvise: call soft_offline_page() without MF_COUNT_INCREASED

The call to get_user_pages_fast is only to get the pointer to a struct
page of a given address, pinning it is memory-poisoning handler's job, so
drop the refcount grabbed by get_user_pages_fast().

Note that the target page is still pinned after this put_page() because
the current process should have refcount from mapping.

Link: https://lkml.kernel.org/r/20201119105716.5962-4-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/mm/madvise.c~mmmadvise-call-soft_offline_page-without-mf_count_increased
+++ a/mm/madvise.c
@@ -900,20 +900,23 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
+		/*
+		 * The get_user_pages_fast() is just to get the pfn of the
+		 * given address, and the refcount has nothing to do with
+		 * what we try to test, so it should be released immediately.
+		 * This is racy but it's intended because the real hardware
+		 * errors could happen at any moment and memory error handlers
+		 * must properly handle the race.
+		 */
+		put_page(page);
+
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
+			ret = soft_offline_page(pfn, 0);
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			/*
-			 * Drop the page reference taken by get_user_pages_fast(). In
-			 * the absence of MF_COUNT_INCREASED the memory_failure()
-			 * routine is responsible for pinning the page to prevent it
-			 * from being released back to the page allocator.
-			 */
-			put_page(page);
 			ret = memory_failure(pfn, 0);
 		}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

