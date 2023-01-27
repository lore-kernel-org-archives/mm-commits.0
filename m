Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3DDC38142
	for <mm-commits@archiver.kernel.org>; Fri, 27 Jan 2023 23:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjA0XE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Jan 2023 18:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjA0XEZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2023 18:04:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6F58BBB8
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 15:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C334B8220D
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 23:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E536C433EF;
        Fri, 27 Jan 2023 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674860661;
        bh=m5LZrQnL2OIn8KAv7764IDmtbWkGdiFxi0foyNpkOA8=;
        h=Date:To:From:Subject:From;
        b=OtHh+2rzbQrWs+dLkSSaJnKbzg+p1uZ0PoU/7L57TZSv1arfq+wkqUZmXQkM11Nl2
         GHDJQQMWtsdS7WEZznYL5Wbu2Xf/xXKMXCHSlLEAEXvp6Y2xWASs0qZVQDOUNr7OxJ
         Jwl+4rbmtTv7kDLJZmYXkBZcrC+qS3ePUNO+/PLs=
Date:   Fri, 27 Jan 2023 15:04:20 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, songmuchun@bytedance.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230127230421.1E536C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
Date: Fri Jan 27 03:00:32 PM PST 2023

simplification, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -745,18 +745,10 @@ static int smaps_hugetlb_range(pte_t *pt
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else {
-			if (hugetlb_pmd_shared(pte))
-				mss->shared_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-			else
-				mss->private_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-		}
+		else
+			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

