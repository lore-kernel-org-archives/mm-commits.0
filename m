Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AFBC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41BA365208
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 20:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhCHUC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhCHUB5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 15:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC8046525F;
        Mon,  8 Mar 2021 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615233717;
        bh=a3NQcHbGzl3sd6sVPTCNdGZ88Ab8U0XyNXvNVuxTglk=;
        h=Date:From:To:Subject:From;
        b=ABRw2Kaamk8w3gssZIepqaPVUKgaThqlpo8WrkIkUF6NZ19sgr2kmpEh/qf4lZR4P
         Pjid2JjfLCaVd7GqzSpLWxLmYX2Rxwx40q31vjeAcCYY0W+Y+6xnoIdNay7gQl5dK1
         8o27Rle5aQ4X4t+L7G+nkWYFIOrbPrH7nZBQWgX4=
Date:   Mon, 08 Mar 2021 12:01:56 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-simplify-the-code-when-alloc=5Fhuge=5Fpage-fai?=
 =?US-ASCII?Q?led-in-hugetlb=5Fno=5Fpage.patch?= added to -mm tree
Message-ID: <20210308200156.ABhAVpIUM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: simplify the code when alloc_huge_page() failed in hugetlb_no_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: simplify the code when alloc_huge_page() failed in hugetlb_no_page()

Rework the error handling code when alloc_huge_page() failed to remove
some duplicated code and simplify the code slightly.

Link: https://lkml.kernel.org/r/20210308112809.26107-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page
+++ a/mm/hugetlb.c
@@ -4396,13 +4396,10 @@ retry:
 			 * sure there really is no pte entry.
 			 */
 			ptl = huge_pte_lock(h, mm, ptep);
-			if (!huge_pte_none(huge_ptep_get(ptep))) {
-				ret = 0;
-				spin_unlock(ptl);
-				goto out;
-			}
+			ret = 0;
+			if (huge_pte_none(huge_ptep_get(ptep)))
+				ret = vmf_error(PTR_ERR(page));
 			spin_unlock(ptl);
-			ret = vmf_error(PTR_ERR(page));
 			goto out;
 		}
 		clear_huge_page(page, address, pages_per_huge_page(h));
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

hugetlb_cgroup-fix-imbalanced-css_get-and-css_put-pair-for-shared-mappings.patch
mm-hugetlb-remove-redundant-reservation-check-condition-in-alloc_huge_page.patch
mm-hugetlb-use-some-helper-functions-to-cleanup-code.patch
mm-hugetlb-optimize-the-surplus-state-transfer-code-in-move_hugetlb_state.patch
hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate.patch
mm-hugetlb-simplify-the-code-when-alloc_huge_page-failed-in-hugetlb_no_page.patch
mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case.patch

