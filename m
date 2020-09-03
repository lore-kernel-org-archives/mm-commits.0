Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D128DC2BD0F
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA5F2083B
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168840;
	bh=2lCx+kuyPv3bj6xLebyk/4G3coUSlAa/UeU3GqgSvQI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oLF3E/yUDsLNTYUr3Q6Qi+DGZU2uDYXAfMzOZGN3qgABFAneHhBHX1p+A8oo2jKhX
	 VpWNSYw1yPSJMGWuRbwB95K+/9XFdSPV7Dul9XixYeKX4T/gNBpg8NjAbc4CXKy9oU
	 Lye6OpJoi0eu+78dmcNKA1kGp8Oxf5W+c6cJXVfc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgICVeA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICVd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:33:58 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A0C206E7;
        Thu,  3 Sep 2020 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168837;
        bh=2lCx+kuyPv3bj6xLebyk/4G3coUSlAa/UeU3GqgSvQI=;
        h=Date:From:To:Subject:From;
        b=sc52n/6DWYO2BNkn16gtJliRjLR8wgfH6ZjKPOejAX8L1Hvy7vC1auhDVs02dUh4z
         ybZ5qkbGrChOn34v93VrAX3U09I5mg+s39S3+ZgvKqweH3UaxLD+ZiDblIOACo8ioz
         jykknMjmuqB9tKDw8Jx5ZhuYnp/zHgL+Eb8Keaj0=
Date:   Thu, 03 Sep 2020 14:33:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, mhocko@kernel.org, osalvador@suse.de
Subject:  + mmhwpoison-drop-unneeded-pcplist-draining.patch added to
 -mm tree
Message-ID: <20200903213357.swOXm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
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

Link: https://lkml.kernel.org/r/20200902094510.10727-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining
+++ a/mm/madvise.c
@@ -914,10 +914,6 @@ static int madvise_inject_error(int beha
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

