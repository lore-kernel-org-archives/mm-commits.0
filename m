Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE33C4338F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 01:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4EF161056
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 01:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhHTB4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 21:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTB4p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 21:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525C660EBC;
        Fri, 20 Aug 2021 01:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629424568;
        bh=RtpBWDNLwD9716STfIykEWhAZuKB5jIOgDsOMBNMdVU=;
        h=Date:From:To:Subject:From;
        b=M4ku+oKxIZcJhhG8NpWIXBBech8fwfJzYoO+oVnGcg9+PKpgLWKSgaiEWNJDc1K3R
         eJPAlB4+UhS0xrWW6wQIiyEIApyarzeuMhe6eRXtHhn3e9Nwvi3ahGAuCvL8Cc6uv2
         B7y+cwuttsJUqWEkf0OAbVOW5f7FYNqFJjSCo6gw=
Date:   Thu, 19 Aug 2021 18:56:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        songmuchun@bytedance.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mhocko@suse.com, naoya.horiguchi@nec.com
Subject:  [folded-merged]
 mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch removed from
 -mm tree
Message-ID: <20210820015608.lvU8G%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-retry-with-shake_page-for-unhandlable-pages-v2.patch

This patch was dropped because it was folded into mm-hwpoison-retry-with-shake_page-for-unhandlable-pages.patch

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
mm-sparse-set-section_nid_shift-to-6.patch

