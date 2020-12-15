Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2690C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6BE224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgLODP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbgLODM4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:56 -0500
Date:   Mon, 14 Dec 2020 19:11:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001889;
        bh=yR1rQfYtS35biGasnWNBZbNQg2Vk/2H3wRm01eBmOYw=;
        h=From:To:Subject:In-Reply-To:From;
        b=KWiLnDcpehvynv//OU5im+HUpDMzDQTNnaMvz3Y1yJ/iEIuUcgWkxUIrbNDQ7yxCY
         Is3XF9F1wE9EpDZF2YmkcfZcLSxHiPlKdPXPrEW5M3qPGyuCKh2sL0bZCP7dohvpLq
         TuRwYNMn876HYcgrl0X6tCFjSpXuQai0aWO8CgkQ=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org
Subject:  [patch 138/200] mm,hwpoison: drain pcplists before
 bailing out for non-buddy zero-refcount page
Message-ID: <20201215031128.S-l3RVou2%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: drain pcplists before bailing out for non-buddy zero-refcount page

Patch series "HWpoison: further fixes and cleanups", v5.

This patchset includes some more fixes and a cleanup.

Patch#2 and patch#3 are both fixes for taking a HWpoison page off a buddy
freelist, since having them there has proved to be bad (see [1] and
pathch#2's commit log).  Patch#3 does the same for hugetlb pages.

[1] https://lkml.org/lkml/2020/9/22/565


This patch (of 4):

A page with 0-refcount and !PageBuddy could perfectly be a pcppage. 
Currently, we bail out with an error if we encounter such a page, meaning
that we do not handle pcppages neither from hard-offline nor from
soft-offline path.

Fix this by draining pcplists whenever we find this kind of page and retry
the check again.  It might be that pcplists have been spilled into the
buddy allocator and so we can handle it.

Link: https://lkml.kernel.org/r/20201013144447.6706-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20201013144447.6706-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page
+++ a/mm/memory-failure.c
@@ -946,13 +946,13 @@ static int page_action(struct page_state
 }
 
 /**
- * get_hwpoison_page() - Get refcount for memory error handling:
+ * __get_hwpoison_page() - Get refcount for memory error handling:
  * @page:	raw error page (hit by memory error)
  *
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-static int get_hwpoison_page(struct page *page)
+static int __get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -982,6 +982,26 @@ static int get_hwpoison_page(struct page
 	return 0;
 }
 
+static int get_hwpoison_page(struct page *p)
+{
+	int ret;
+	bool drained = false;
+
+retry:
+	ret = __get_hwpoison_page(p);
+	if (!ret && !is_free_buddy_page(p) && !page_count(p) && !drained) {
+		/*
+		 * The page might be in a pcplist, so try to drain those
+		 * and see if we are lucky.
+		 */
+		drain_all_pages(page_zone(p));
+		drained = true;
+		goto retry;
+	}
+
+	return ret;
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
_
