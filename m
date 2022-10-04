Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A0CC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  4 Oct 2022 19:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJDTlv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Oct 2022 15:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJDTlt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2022 15:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0E95C9D9
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 12:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA70614FF
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 19:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD0EC433C1;
        Tue,  4 Oct 2022 19:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664912507;
        bh=dwhgW6zOF7dyuXM1MjjtOxrnLYnS2TfJDWaAr5MfNpo=;
        h=Date:To:From:Subject:From;
        b=ttWwbgbl+6NpA3wvtvZqHnuTZ1zvf0fLj2dPIfTivTyG+pB+UY2bk627V57Rzpnj/
         38iuJ9ReL32bTUdV3DYhuQe7KtgP3hxZCcoxbppDIHa0gngtWiJTpCW/OHQir6t5Ni
         IaNhIhBc8qRERZ2uXGcEpugrQjHbvYI/s3F3fKg8=
Date:   Tue, 04 Oct 2022 12:41:46 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch added to mm-unstable branch
Message-Id: <20221004194147.8FD0EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use hugetlb_pte_stable in migration race check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch

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
Subject: mm/hugetlb: use hugetlb_pte_stable in migration race check
Date: Tue, 4 Oct 2022 15:33:59 -0400

After hugetlb_pte_stable() introduced, we can also rewrite the migration
race condition against page allocation to use the new helper too.

Link: https://lkml.kernel.org/r/20221004193400.110155-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check
+++ a/mm/hugetlb.c
@@ -5623,11 +5623,10 @@ static vm_fault_t hugetlb_no_page(struct
 			 * here.  Before returning error, get ptl and make
 			 * sure there really is no pte entry.
 			 */
-			ptl = huge_pte_lock(h, mm, ptep);
-			ret = 0;
-			if (huge_pte_none(huge_ptep_get(ptep)))
+			if (hugetlb_pte_stable(h, mm, ptep, old_pte))
 				ret = vmf_error(PTR_ERR(page));
-			spin_unlock(ptl);
+			else
+				ret = 0;
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch
mm-hugetlb-fix-race-condition-of-uffd-missing-minor-handling.patch
mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch
mm-selftest-uffd-explain-the-write-missing-fault-check.patch

