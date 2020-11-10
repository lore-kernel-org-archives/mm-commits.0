Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B9CC388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D47E20674
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoAjf360"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgKJT3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJT3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:29:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FDF20656;
        Tue, 10 Nov 2020 19:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605036592;
        bh=0zGplApPPVOHCiH0mG7LGI5KplDXqVEIM52whU5QaEc=;
        h=Date:From:To:Subject:From;
        b=ZoAjf360gDIkSrPiRTgHX0B59+e7TLTpW+NPOm6vhGIpv5JMeDpEnnTzYfXL7VxHp
         u709ggD204LOfjCNGRrWfxclmjhs33iI1ikMJ9CK8WEEZkgMPHVhmqIvPJPl037KdQ
         cmSTVzYji8T7I6u/77P+UpOIlkpyztjy61BjrN5g=
Date:   Tue, 10 Nov 2020 11:29:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 =?US-ASCII?Q?mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-?=
 =?US-ASCII?Q?zero-refcount-page.patch?= added to -mm tree
Message-ID: <20201110192951.uREXR2kXw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drain pcplists before bailing out for non-buddy zero-refcount page
has been added to the -mm tree.  Its filename is
     mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch

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

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

