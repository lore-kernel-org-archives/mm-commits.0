Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1E1C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJLW6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJLW60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE6212C8A0
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB07B81CAC
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483A3C433D7;
        Wed, 12 Oct 2022 22:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615465;
        bh=haVB/vq41fjvC/2wQmFd5B8LhYT4DpiC0TY9wOhP6gE=;
        h=Date:To:From:Subject:From;
        b=P8BW2/uGYJFoWkA37WXVBAI+mq//fDjhQTiNq/pzw2mz6RPxON8x0/YTPjmq3ujfr
         WDrn3mlPM3cIECf1FHweWfcVvKQ853nSaheYYg3E3lWcU8bLx45wxm+G+HdwXiFJfE
         GNGbHxL2n938cAZdP9qji/GGPYtEyWNr857EK2hg=
Date:   Wed, 12 Oct 2022 15:57:44 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch removed from -mm tree
Message-Id: <20221012225745.483A3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: use hugetlb_pte_stable in migration race check
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-hugetlb_pte_stable-in-migration-race-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5634,11 +5634,10 @@ static vm_fault_t hugetlb_no_page(struct
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

mm-selftest-uffd-explain-the-write-missing-fault-check.patch

