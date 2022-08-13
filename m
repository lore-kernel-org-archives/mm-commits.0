Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7641CC19F2D
	for <mm-commits@archiver.kernel.org>; Sat, 13 Aug 2022 23:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiHMX1n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiHMX1m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 13 Aug 2022 19:27:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1175989822
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 16:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8863B80AC0
        for <mm-commits@vger.kernel.org>; Sat, 13 Aug 2022 23:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C3C433C1;
        Sat, 13 Aug 2022 23:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660433258;
        bh=0DCC/+ldFT5dAke8OZGSRYW2JwzKEmQiU48kCbm+ol4=;
        h=Date:To:From:Subject:From;
        b=hfpQH2i4exy1eZ+qJZXVW336UfVeto1aFU7EtOR4E7Lt9em9Yk1I13FqZTQsjVxlU
         1kcQrt+2BK5yOayI+56eqM/mC7GkKMXvBHDJUZ2iZ7CGKMCPxHFnaLu4bTAWIxdTGj
         1nNIshfzoJJLbIH448D7giWYklFlEjNddCuUfwOY=
Date:   Sat, 13 Aug 2022 16:27:37 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, linmiaohe@huawei.com, david@redhat.com,
        haiyue.wang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch added to mm-unstable branch
Message-Id: <20220813232738.3F5C3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migration: fix the FOLL_GET failure on following huge page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Haiyue Wang <haiyue.wang@intel.com>
Subject: mm: migration: fix the FOLL_GET failure on following huge page
Date: Fri, 12 Aug 2022 16:49:21 +0800

Not all huge page APIs support FOLL_GET option, so the __NR_move_pages
will fail to get the page node information for huge page.

This is an temporary solution to mitigate the racing fix.

After supporting follow huge page by FOLL_GET is done, this fix can be
reverted safely.

Link: https://lkml.kernel.org/r/20220812084921.409142-1-haiyue.wang@intel.com
Fixes: 4cd614841c06 ("mm: migration: fix possible do_pages_stat_array racing with memory offline")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-fix-the-foll_get-failure-on-following-huge-page
+++ a/mm/migrate.c
@@ -1852,6 +1852,7 @@ static void do_pages_stat_array(struct m
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
+		unsigned int foll_flags = FOLL_DUMP;
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
@@ -1860,8 +1861,12 @@ static void do_pages_stat_array(struct m
 		if (!vma)
 			goto set_status;
 
+		/* Not all huge page follow APIs support 'FOLL_GET' */
+		if (!is_vm_hugetlb_page(vma))
+			foll_flags |= FOLL_GET;
+
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		page = follow_page(vma, addr, foll_flags);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -1869,7 +1874,8 @@ static void do_pages_stat_array(struct m
 
 		if (page && !is_zone_device_page(page)) {
 			err = page_to_nid(page);
-			put_page(page);
+			if (foll_flags & FOLL_GET)
+				put_page(page);
 		} else {
 			err = -ENOENT;
 		}
_

Patches currently in -mm which might be from haiyue.wang@intel.com are

mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch

