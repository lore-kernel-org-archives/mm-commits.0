Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56414C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345922AbjKXTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345799AbjKXTVV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:21:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C13F30E4
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:21:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D20C433C7;
        Fri, 24 Nov 2023 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700853687;
        bh=75Tt6WhQuKQzl3eNynOa0RzUQJ5TIjk7fK8xS3ujVms=;
        h=Date:To:From:Subject:From;
        b=M4FT7OQLxnGBdRs+rdIbKEnbPhdju4iSGwuOvtRrc9+IJC4Gfdd332vwhTAib+zbI
         D3G4qerYaBwhEHxChRVMPNqygMiB3BcItyInqBbMQDIavSXxpfdfPWiAD/1wyTcWFW
         yL9yFABJ3MEoVqC8Cqq/cAc84u98/SK3BrUWs5dc=
Date:   Fri, 24 Nov 2023 11:21:27 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, mgorman@suse.de,
        hch@lst.de, dan.j.williams@intel.com,
        aneesh.kumar@linux.vnet.ibm.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch added to mm-unstable branch
Message-Id: <20231124192127.C8D20C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fix follow_devmap_p[mu]d() on page==NULL handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: fix follow_devmap_p[mu]d() on page==NULL handling
Date: Thu, 23 Nov 2023 13:02:22 -0500

This is a bug found not by any report but only by code observations.

When GUP sees a devpmd/devpud and if page==NULL is returned, it means a
fault is probably required.  Here falling through when page==NULL can
cause unexpected behavior.

Fix both cases by catching the page==NULL cases with no_page_table().

Link: https://lkml.kernel.org/r/20231123180222.1048297-1-peterx@redhat.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Fixes: 080dbb618b4b ("mm/follow_page_mask: split follow_page_mask to smaller functions.")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/gup.c~mm-gup-fix-follow_devmap_pd-on-page==null-handling
+++ a/mm/gup.c
@@ -710,6 +710,7 @@ static struct page *follow_pmd_mask(stru
 		spin_unlock(ptl);
 		if (page)
 			return page;
+		return no_page_table(vma, flags);
 	}
 	if (likely(!pmd_trans_huge(pmdval)))
 		return follow_page_pte(vma, address, pmd, flags, &ctx->pgmap);
@@ -758,6 +759,7 @@ static struct page *follow_pud_mask(stru
 		spin_unlock(ptl);
 		if (page)
 			return page;
+		return no_page_table(vma, flags);
 	}
 	if (unlikely(pud_bad(*pud)))
 		return no_page_table(vma, flags);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-pagemap-fix-ioctlpagemap_scan-on-vma-check.patch
mm-pagemap-fix-wr-protect-even-if-pm_scan_wp_matching-not-set.patch
mm-selftests-fix-pagemap_ioctl-memory-map-test.patch
mm-kconfig-make-userfaultfd-a-menuconfig.patch
fs-kconfig-make-hugetlbfs-a-menuconfig.patch
mm-gup-fix-follow_devmap_pd-on-page==null-handling.patch

