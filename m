Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DBFC388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B5C20674
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3c0YHla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJTaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgKJTaD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:30:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2BD20665;
        Tue, 10 Nov 2020 19:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605036601;
        bh=sultLcybbVOS8bTCmMwem0pfFv+PA3MiUTamTcALpzY=;
        h=Date:From:To:Subject:From;
        b=l3c0YHla6dLH7hHKz5BUOESS9MN2JrWeDqdN4LW5Y0tA0tDe1kRkh8lrNLqYb6dmk
         qzIY+i8kk3XFoxe49z3Y/x8EPArxfa0p6QNnLoGFtPgMeAJSew6ow2x1+aDVE73Yur
         COfIC2TMDee9M7hTfAATuXZnoIHQO0zsnwcogV9Q=
Date:   Tue, 10 Nov 2020 11:30:00 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  + mmhwpoison-drop-unneeded-pcplist-draining.patch added
 to -mm tree
Message-ID: <20201110193000.BMLNZGRZ0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: drop unneeded pcplist draining
has been added to the -mm tree.  Its filename is
     mmhwpoison-drop-unneeded-pcplist-draining.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-drop-unneeded-pcplist-draining.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-drop-unneeded-pcplist-draining.patch

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
Subject: mm,hwpoison: drop unneeded pcplist draining

memory_failure and soft_offline_path paths now drain pcplists by calling
get_hwpoison_page.

memory_failure flags the page as HWPoison before, so that page cannot
longer go into a pcplist, and soft_offline_page only flags a page as
HWPoison if 1) we took the page off a buddy freelist 2) the page was
in-use and we migrated it 3) was a clean pagecache.

Because of that, a page cannot longer be poisoned and be in a pcplist.

Link: https://lkml.kernel.org/r/20201013144447.6706-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining
+++ a/mm/madvise.c
@@ -877,7 +877,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct zone *zone;
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -922,10 +921,6 @@ static int madvise_inject_error(int beha
 			return ret;
 	}
 
-	/* Ensure that all poisoned pages are removed from per-cpu lists */
-	for_each_populated_zone(zone)
-		drain_all_pages(zone);
-
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

