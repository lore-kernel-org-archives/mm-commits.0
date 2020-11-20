Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A63DC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED0D22416E
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BPbDQZ10"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgKTX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTX65 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:58:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9BEB22470;
        Fri, 20 Nov 2020 23:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916737;
        bh=MAp64t4erOHG55mP6plPt7GYvpggvDuU+bv1GE/+fhA=;
        h=Date:From:To:Subject:From;
        b=BPbDQZ10FlRQYEOpC6+to48GfLWVikwbpKgQEoi+7RVfiuTwK+3wI7urbl1DF/LvN
         4otaAhvcag/1toXGG0nkd5LLrgJmCB9i/j32OhQyUpQoWFj5bU2BVwRxYlUmLOoVfs
         Eo14EQY6UuZoNMi1Fh+nw1ZlhQyQFM688WhkEvXc=
Date:   Fri, 20 Nov 2020 15:58:56 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  + mmhwpoison-drop-pfn-parameter.patch added to -mm tree
Message-ID: <20201120235856.3Se-Z4kqj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drop pfn parameter
has been added to the -mm tree.  Its filename is
     mmhwpoison-drop-pfn-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-drop-pfn-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-drop-pfn-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: drop pfn parameter

pfn parameter is no longer needed, drop it.

Link: https://lkml.kernel.org/r/20201119105716.5962-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-drop-pfn-parameter
+++ a/mm/memory-failure.c
@@ -1712,7 +1712,7 @@ EXPORT_SYMBOL(unpoison_memory);
  * We only incremented refcount in case the page was already in-use and it is
  * a known type we can handle.
  */
-static int get_any_page(struct page *p, unsigned long pfn, int flags)
+static int get_any_page(struct page *p, int flags)
 {
 	int ret = 0, pass = 0;
 
@@ -1926,7 +1926,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_any_page(page, pfn, flags);
+	ret = get_any_page(page, flags);
 	put_online_mems();
 
 	if (ret > 0) {
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-drop-pfn-parameter.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmhugetlb-remove-unneded-initialization.patch

