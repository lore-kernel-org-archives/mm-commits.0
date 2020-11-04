Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A400DC2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4D12236F
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604457698;
	bh=VUPxFkSVktWzkajE/BtsB2RVhxVu6vC9/wYUrTN8KlQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mg02bgUSdjuRylKig1Ok5KJift5Hlr4s8ghxinRqaRugVJsAIs0pFJuTkLRf25Dyi
	 47z0yaZuCObKVERiwULS73Cd8s1GJQ6D8IsRcG4PFotkcy49wCU9s5QIDRfcX1o1zm
	 mwjE03OsPP3Z2YFAgPlbXL/ObjDY79b1Sg7dsFC4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgKDCli (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgKDClh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 21:41:37 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C52EC22264;
        Wed,  4 Nov 2020 02:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604457697;
        bh=VUPxFkSVktWzkajE/BtsB2RVhxVu6vC9/wYUrTN8KlQ=;
        h=Date:From:To:Subject:From;
        b=fOxAY4ZsWn0Q75MbZ3XV6uPMytL4oHHwL76gKzrGKEtl9gMoBNb2HJYy4VrHgcVh+
         gVVdu6BCr80nAbt1LjEMS/X7gPe1Wri9PRCVjeHJqEcxtm2zzebAiIrg10QNY1GuUC
         2xEAiuToMIngZ4d74j0ZMyzxjHljKmqh7YPRoUbg=
Date:   Tue, 03 Nov 2020 18:41:36 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@kernel.org, jhubbard@nvidia.com,
        ira.weiny@intel.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, jgg@nvidia.com
Subject:  +
 mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch added to -mm tree
Message-ID: <20201104024136.xXrER%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: use unpin_user_pages() in __gup_longterm_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: use unpin_user_pages() in __gup_longterm_locked()

When FOLL_PIN is passed to __get_user_pages() the page list must be put
back using unpin_user_pages() otherwise the page pin reference persists in
a corrupted state.

There are two places in the unwind of __gup_longterm_locked() that put the
pages back without checking.  Normally on error this function would return
the partial page list making this the caller's responsibility, but in
these two cases the caller is not allowed to see these pages at all.

Link: https://lkml.kernel.org/r/0-v2-3ae7d9d162e2+2a7-gup_cma_fix_jgg@nvidia.com
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-use-unpin_user_pages-in-__gup_longterm_locked
+++ a/mm/gup.c
@@ -1647,8 +1647,11 @@ check_again:
 		/*
 		 * drop the above get_user_pages reference.
 		 */
-		for (i = 0; i < nr_pages; i++)
-			put_page(pages[i]);
+		if (gup_flags & FOLL_PIN)
+			unpin_user_pages(pages, nr_pages);
+		else
+			for (i = 0; i < nr_pages; i++)
+				put_page(pages[i]);
 
 		if (migrate_pages(&cma_page_list, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_CONTIG_RANGE)) {
@@ -1728,8 +1731,11 @@ static long __gup_longterm_locked(struct
 			goto out;
 
 		if (check_dax_vmas(vmas_tmp, rc)) {
-			for (i = 0; i < rc; i++)
-				put_page(pages[i]);
+			if (gup_flags & FOLL_PIN)
+				unpin_user_pages(pages, rc);
+			else
+				for (i = 0; i < rc; i++)
+					put_page(pages[i]);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-use-unpin_user_pages-in-__gup_longterm_locked.patch

