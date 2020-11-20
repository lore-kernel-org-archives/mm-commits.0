Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83758C63798
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF2D24137
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JKLbpEMJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgKTX7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTX7B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:59:01 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBBA322470;
        Fri, 20 Nov 2020 23:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916740;
        bh=fhCxAY+R25DY0/vb5baN5gnS9YHVdEdTMD7yuRJ6dFU=;
        h=Date:From:To:Subject:From;
        b=JKLbpEMJFbECuO+uuCIm2T6cGR9pC5usc0a5fZYxnrj7SfgrMiSx34gJ3brbSzGFF
         TDBN6yMUElVoOO3/EzNJuGP6Edeuq7jebVswAP3R27geku6wIPCEhsesFgkTftS7Fz
         BSyg5MLItQ2acWbSniPyo3E+c8vaX2cXrBNJl6fc=
Date:   Fri, 20 Nov 2020 15:59:00 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  + mmhwpoison-remove-mf_count_increased.patch added to -mm
 tree
Message-ID: <20201120235900.oVHOq-_ej%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-mf_count_increased.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-mf_count_increased.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-mf_count_increased.patch

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
Subject: mm,hwpoison: remove MF_COUNT_INCREASED

Now there's no user of MF_COUNT_INCREASED, so we can safely remove it from
all calling points.

Link: https://lkml.kernel.org/r/20201119105716.5962-5-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    7 +++----
 mm/memory-failure.c |    9 ++-------
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-remove-mf_count_increased
+++ a/include/linux/mm.h
@@ -3026,10 +3026,9 @@ void register_page_bootmem_memmap(unsign
 				  unsigned long nr_pages);
 
 enum mf_flags {
-	MF_COUNT_INCREASED = 1 << 0,
-	MF_ACTION_REQUIRED = 1 << 1,
-	MF_MUST_KILL = 1 << 2,
-	MF_SOFT_OFFLINE = 1 << 3,
+	MF_ACTION_REQUIRED = 1 << 0,
+	MF_MUST_KILL = 1 << 1,
+	MF_SOFT_OFFLINE = 1 << 2,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/mm/memory-failure.c~mmhwpoison-remove-mf_count_increased
+++ a/mm/memory-failure.c
@@ -1185,7 +1185,7 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		/*
 		 * Check "filter hit" and "race with other subpage."
 		 */
@@ -1387,7 +1387,7 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -1716,9 +1716,6 @@ static int get_any_page(struct page *p,
 {
 	int ret = 0, pass = 0;
 
-	if (flags & MF_COUNT_INCREASED)
-		return 1;
-
 try_again:
 	if (!get_hwpoison_page(p)) {
 		if (page_count(p)) {
@@ -1919,8 +1916,6 @@ int soft_offline_page(unsigned long pfn,
 
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
-		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

