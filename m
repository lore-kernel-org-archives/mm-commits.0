Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAEDC433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0533F20578
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598818796;
	bh=AExmUO9i3wUHOyW12IfGDapmduIKH76ptpQ3Z79uf5c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PH/923X8XPflRMZsA3NXqNg6PZzPg3SMDm3pl4c5K4TGdnq0uS0xbcNqmutrKt4AV
	 Ptzddmj3sA+smD92vGFZThGkxt9NnvSKHOHwuH8GTuRVWAHSuyUZlTHlIN7ytkNjLJ
	 Cuy+2FvArpt8cD7ziz+wd52V/iatuk2sxmwu+3CE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgH3UTz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgH3UTz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 16:19:55 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01A84204EA;
        Sun, 30 Aug 2020 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598818794;
        bh=AExmUO9i3wUHOyW12IfGDapmduIKH76ptpQ3Z79uf5c=;
        h=Date:From:To:Subject:From;
        b=KC4JIuMWSJw5iXG3ekMQ3c4WJM3hlmG58JoC7vwTK18nWfhfixMfEFNYUd0zOd2+h
         5zvbEX681DA/tTihMPWlRg8dMqoFZVHCWdtsQ+ZciE/iF2Smv4GWPG7WpBpzk8lxeu
         +kdNIpHbJMjMWhAT20xiN1dVeK+CwkzH51b3IFsE=
Date:   Sun, 30 Aug 2020 13:19:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, dan.j.williams@intel.com, cai@lca.pw,
        songmuchun@bytedance.com
Subject:  +
 mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch
 added to -mm tree
Message-ID: <20200830201953.NYFTD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: fix return wrong value when isolate page fail
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memory-failure: fix return wrong value when isolate page fail

When we isolate page fail, we should not return 0, because we do not
set page HWPoison on any page.

Link: https://lore.kernel.org/lkml/20200811220643.GB39857@lca.pw/
Link: http://lkml.kernel.org/r/20200830081053.64981-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Qian Cai <cai@lca.pw>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2
+++ a/mm/memory-failure.c
@@ -1847,6 +1847,7 @@ static int __soft_offline_page(struct pa
 	} else {
 		pr_info("soft offline: %#lx: %s isolation failed: %d, page count %d, type %lx (%pGp)\n",
 			pfn, msg_page[huge], ret, page_count(page), page->flags, &page->flags);
+		ret = -EBUSY;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

