Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0B3C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiILDaG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiILD2y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9429D27CED
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F5761179
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69917C433D6;
        Mon, 12 Sep 2022 03:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953330;
        bh=VkDxs9ZpKdiI+JF6ILJnJNb+lBTbyd2dasW+k/vOX1Y=;
        h=Date:To:From:Subject:From;
        b=fuJbIh9twpGutAX7nBOJ0W2Mu/nhL1L7lHaQenzZv7WwNnELUqVSAdFDN1R1+wE5i
         OqYYVb9Hbf+G4jv8p/wN/PB830eDB9No1GOSxCBeSgPkqNR77hzDXKN9jlR/8auEuw
         bSI850P6Xd9a7DpNsOecmOOgYbeRvziROzzR5fkg=
Date:   Sun, 11 Sep 2022 20:28:49 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        songmuchun@bytedance.com, linmiaohe@huawei.com, david@redhat.com,
        baolin.wang@linux.alibaba.com, haiyue.wang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch removed from -mm tree
Message-Id: <20220912032850.69917C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migration: fix the FOLL_GET failure on following huge page
has been removed from the -mm tree.  Its filename was
     mm-migration-fix-the-foll_get-failure-on-following-huge-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haiyue Wang <haiyue.wang@intel.com>
Subject: mm: migration: fix the FOLL_GET failure on following huge page
Date: Fri, 12 Aug 2022 16:49:21 +0800

Not all huge page APIs support FOLL_GET option, so move_pages() syscall
will fail to get the page node information for some huge pages.

Like x86 on linux 5.19 with 1GB huge page API follow_huge_pud(), it will
return NULL page for FOLL_GET when calling move_pages() syscall with the
NULL 'nodes' parameter, the 'status' parameter has '-2' error in array.

Note: follow_huge_pud() now supports FOLL_GET in linux 6.0.
      Link: https://lore.kernel.org/all/20220714042420.1847125-3-naoya.horiguchi@linux.dev

But these huge page APIs don't support FOLL_GET:
  1. follow_huge_pud() in arch/s390/mm/hugetlbpage.c
  2. follow_huge_addr() in arch/ia64/mm/hugetlbpage.c
     It will cause WARN_ON_ONCE for FOLL_GET.
  3. follow_huge_pgd() in mm/hugetlb.c

This is an temporary solution to mitigate the side effect of the race
condition fix by calling follow_page() with FOLL_GET set for huge pages.

After supporting follow huge page by FOLL_GET is done, this fix can be
reverted safely.

Link: https://lkml.kernel.org/r/20220823135841.934465-2-haiyue.wang@intel.com
Link: https://lkml.kernel.org/r/20220812084921.409142-1-haiyue.wang@intel.com
Fixes: 4cd614841c06 ("mm: migration: fix possible do_pages_stat_array racing with memory offline")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migration-fix-the-foll_get-failure-on-following-huge-page
+++ a/mm/migrate.c
@@ -1848,6 +1848,7 @@ static void do_pages_stat_array(struct m
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)(*pages);
+		unsigned int foll_flags = FOLL_DUMP;
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
@@ -1856,8 +1857,12 @@ static void do_pages_stat_array(struct m
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
@@ -1865,7 +1870,8 @@ static void do_pages_stat_array(struct m
 
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

mm-fix-the-handling-non-lru-pages-returned-by-follow_page.patch

