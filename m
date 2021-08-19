Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074EAC4338F
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 00:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42F9610A6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Aug 2021 00:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhHSA3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhHSA3p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 20:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A357D610A5;
        Thu, 19 Aug 2021 00:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629332949;
        bh=uZPxWGxXh6nbz6WzgHX9l+6OTCKSaerfWJH53fBhxmg=;
        h=Date:From:To:Subject:From;
        b=mP5Or7NbfdeSwHfPYsBGZCkzrqz2nO7EhS5DIUlTaMaTZ8djPe4qkwdDF+ddf7rx6
         XyYC8si1lLiAMd1+gep5gg128ypyqjLd3XWuXE9nDyk+WhCs2zPG0fJ/a+QWFhpirs
         5WilUpQBZxER90Oc2aUZGFkAGfP0/m4sss0vviSI=
Date:   Wed, 18 Aug 2021 17:29:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        songmuchun@bytedance.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, naoya.horiguchi@nec.com
Subject:  +
 mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch added to -mm
 tree
Message-ID: <20210819002907.oTt0d%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2
has been added to the -mm tree.  Its filename is
     mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch

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
Subject: mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2

get_any_page(): return -EIO when retry limit reached

Link: https://lkml.kernel.org/r/20210819001958.2365157-1-naoya.horiguchi@linux.dev
Fixes: 25182f05ffed ("mm,hwpoison: fix race with hugetlb page allocation")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2
+++ a/mm/memory-failure.c
@@ -1207,6 +1207,7 @@ try_again:
 				shake_page(p, 1);
 				goto try_again;
 			}
+			ret = -EIO;
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch
mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch
mm-sparse-set-section_nid_shift-to-6.patch

