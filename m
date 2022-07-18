Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87532C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiGRARq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233111AbiGRARI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75EE12A8B
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93A51B80DAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441F1C3411E;
        Mon, 18 Jul 2022 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103418;
        bh=KyXmo8ej8Ry9BdwYjoQ+omv45XPqxfrF6eSp8Ws9RwU=;
        h=Date:To:From:Subject:From;
        b=vhEHQESEkbS4oqkJ5h474YTUh6S4LQKsWOsP6fZV8Fk84DKZHfZlhEEja4u8edSCp
         iYXW+SmiA/PP8yYeVUBx34u+Hkf9CA2Sh902dKaLcq+A2NoGkRBNPefL8xSvoUpowk
         +e76OjAzaIaDqY5SkIHj7S3E+7+Zwtxr41nfVbAM=
Date:   Sun, 17 Jul 2022 17:16:57 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, shy828301@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch removed from -mm tree
Message-Id: <20220718001658.441F1C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: khugepaged: check THP flag in hugepage_vma_check()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-check-thp-flag-in-hugepage_vma_check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: khugepaged: check THP flag in hugepage_vma_check()
Date: Thu, 16 Jun 2022 10:48:34 -0700

Patch series "Cleanup transhuge_xxx helpers", v5.

This series is the follow-up of the discussion about cleaning up
transhuge_xxx helpers at
https://lore.kernel.org/linux-mm/627a71f8-e879-69a5-ceb3-fc8d29d2f7f1@suse.cz/.

THP has a bunch of helpers that do VMA sanity check for different paths,
they do the similar checks for the most callsites and have a lot duplicate
codes.  And it is confusing what helpers should be used at what
conditions.

This series reorganized and cleaned up the code so that we could
consolidate all the checks into hugepage_vma_check().

The transhuge_vma_enabled(), transparent_hugepage_active() and
__transparent_hugepage_enabled() are killed by this series.


This patch (of 7):

Currently the THP flag check in hugepage_vma_check() will fallthrough if
the flag is NEVER and VM_HUGEPAGE is set.  This is not a problem for now
since all the callers have the flag checked before or can't be invoked if
the flag is NEVER.

However, the following patch will call hugepage_vma_check() in more
places, for example, page fault, so this flag must be checked in
hugepge_vma_check().

Link: https://lkml.kernel.org/r/20220616174840.1202070-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20220616174840.1202070-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-check-thp-flag-in-hugepage_vma_check
+++ a/mm/khugepaged.c
@@ -451,6 +451,9 @@ bool hugepage_vma_check(struct vm_area_s
 	if (shmem_file(vma->vm_file))
 		return shmem_huge_enabled(vma);
 
+	if (!khugepaged_enabled())
+		return false;
+
 	/* THP settings require madvise. */
 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
 		return false;
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-khugepaged-dont-carry-huge-page-to-the-next-loop-for-config_numa.patch

