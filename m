Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FD7C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 07:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523B660EB4
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 07:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbhJ0HxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 03:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240676AbhJ0HxO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 03:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF88961039;
        Wed, 27 Oct 2021 07:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321050;
        bh=83y1SJUmyP4TAP5EHxUego+TlD5JWrm3R7NYeOQlRCQ=;
        h=Date:From:To:Subject:From;
        b=qQCJmHEBt3qGqo5gZvJPQfqAuIIdau4hYofb4DinTZbMp/dajwHWe18BYnhAGcph9
         zSotMLiU4eqSgWvRrrxptH/YAKpoZg+tIKkUo3NIvAfU3zMYsADeWlSxhaeAR5vzlb
         FffmP3Didp6+6/gyWlDAqqCSsQm3HALHZtAe99Uk=
Date:   Wed, 27 Oct 2021 00:50:49 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com,
        songmuchun@bytedance.com, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?hugetlb-remove-unnecessary-set=5Fpage=5Fcount-in-prep=5Fcomp?=
 =?US-ASCII?Q?ound=5Fgigantic=5Fpage.patch?= added to -mm tree
Message-ID: <20211027075049.3mo_ydyDe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page
has been added to the -mm tree.  Its filename is
     hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: remove unnecessary set_page_count in prep_compound_gigantic_page

In commit 7118fc2906e29 ("hugetlb: address ref count racing in
prep_compound_gigantic_page"), page_ref_freeze is used to atomically zero
the ref count of tail pages iff they are 1.  The unconditional call to
set_page_count(0) was left in the code.  This call is after
page_ref_freeze so it is really a noop.

Remove redundant and unnecessary set_page_count call.

Link: https://lkml.kernel.org/r/20211026220635.35187-1-mike.kravetz@oracle.com
Fixes: 7118fc2906e29 ("hugetlb: address ref count racing in prep_compound_gigantic_page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page
+++ a/mm/hugetlb.c
@@ -1792,7 +1792,6 @@ static bool __prep_compound_gigantic_pag
 		} else {
 			VM_BUG_ON_PAGE(page_count(p), p);
 		}
-		set_page_count(p, 0);
 		set_compound_head(p, page);
 	}
 	atomic_set(compound_mapcount_ptr(page), -1);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-add-hugetlb-demote-page-support-v4.patch
hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

