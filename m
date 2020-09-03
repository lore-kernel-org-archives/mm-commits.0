Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A993C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20950206D4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168839;
	bh=LfSJdcA89MJlYpIAKzYFnKJUCAZh+zWIvy4ZiTR3pMA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=onRyS89rQO51jKB4tOIvM1TN2ZYie8Zm4Ymnpab/VwWz+THG/N/YT+NWgTa39FUwy
	 XLMYFV3v5yejyfPZsaJh4uNweYgCBgmbku0twODAV532MhECE88SYxevVu8IQAkGKZ
	 cmuxZlQsVZ2dE3EFuGXBptQxi80XRucwpQJVpO1g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgICVd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgICVd4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:33:56 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D54206D4;
        Thu,  3 Sep 2020 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168835;
        bh=LfSJdcA89MJlYpIAKzYFnKJUCAZh+zWIvy4ZiTR3pMA=;
        h=Date:From:To:Subject:From;
        b=CRq0yZRkCUKzazytADQ4nusdy4wvYYVAvD/xzv0tD+tmL7E6hVIByP086hK3BwnMn
         0rN58AE+7UVDOwqivPqksNNdYXgGWJD6C4Bn6wcA3XbUR8utou/37zXngQsyG0dXQt
         tdti9skpnWZWRs5u5N6TKMpogb3JbfVeoTISsFDY=
Date:   Thu, 03 Sep 2020 14:33:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, mhocko@kernel.org, osalvador@suse.de
Subject:  +
 =?us-ascii?Q?mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-?=
 =?us-ascii?Q?zero-refcount-page.patch?= added to -mm tree
Message-ID: <20200903213355.Fs4sh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
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

A page with 0-refcount and !PageBuddy could perfectly be a pcppage. 
Currently, we bail out with an error if we encounter such a page, meaning
that we do not handle pcppages neither from hard-offline nor from
soft-offline path.

Fix this by draining pcplists whenever we find this kind of page and retry
the check again.  It might be that pcplists have been spilled into the
buddy allocator and so we can handle it.

Link: https://lkml.kernel.org/r/20200902094510.10727-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page
+++ a/mm/memory-failure.c
@@ -950,13 +950,13 @@ static int page_action(struct page_state
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
 
@@ -986,6 +986,26 @@ static int get_hwpoison_page(struct page
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

mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

