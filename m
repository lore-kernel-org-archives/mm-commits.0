Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60739C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C46F2225E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709532;
	bh=BBkACAs3TstUB6J2J+JRQ4Sf2yoPIAvoYUoqhj4nJxY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NJWzVBUAlgO/w8CZZud7xnXlSIl3l1vEG1cG7hKIPrmruyr+taUHGhs1BQ3FhGv2K
	 zehLTELnIsJCEbMS3NNiZPmCMHct263KxXcL53znDxE+hVr94nqR1mgeqUj8LoPHR+
	 Vnof+xnxh4AsbWS51aECgJxkeh3EHcnkXiMqtqKg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgJNVFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgJNVFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:05:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B1EF206B2;
        Wed, 14 Oct 2020 21:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709530;
        bh=BBkACAs3TstUB6J2J+JRQ4Sf2yoPIAvoYUoqhj4nJxY=;
        h=Date:From:To:Subject:From;
        b=LS71ddJhmGXBxjg67kK7cT7wFrozvAMiX6heLQG/amDXzFPOhR7ZSxvLh9kaaOOCL
         ZfmqxzlrHswffkvX9nF1O/E6kqdtsWepaVw3z9UhyUxbmyIWtTp4oQuisF4Ar3ibm9
         rReB6rAzCMVrYk3wJueZvL8/+LBnCbrgkhTVczys=
Date:   Wed, 14 Oct 2020 14:05:30 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, ira.weiny@intel.com, jhubbard@nvidia.com,
        jrdr.linux@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-gup-protect-unpin_user_pages-against-npages==-errno.patch removed from
 -mm tree
Message-ID: <20201014210530.Dsj4MlgEV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: protect unpin_user_pages() against npages==-ERRNO
has been removed from the -mm tree.  Its filename was
     mm-gup-protect-unpin_user_pages-against-npages==-errno.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: protect unpin_user_pages() against npages==-ERRNO

As suggested by Dan Carpenter, fortify unpin_user_pages() just a bit,
against a typical caller mistake: check if the npages arg is really a
-ERRNO value, which would blow up the unpinning loop: WARN and return.

If this new WARN_ON() fires, then the system *might* be leaking pages (by
leaving them pinned), but probably not.  More likely, gup/pup returned a
hard -ERRNO error to the caller, who erroneously passed it here.

Link: https://lkml.kernel.org/r/20200917065706.409079-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/gup.c~mm-gup-protect-unpin_user_pages-against-npages==-errno
+++ a/mm/gup.c
@@ -329,6 +329,13 @@ void unpin_user_pages(struct page **page
 	unsigned long index;
 
 	/*
+	 * If this WARN_ON() fires, then the system *might* be leaking pages (by
+	 * leaving them pinned), but probably not. More likely, gup/pup returned
+	 * a hard -ERRNO error to the caller, who erroneously passed it here.
+	 */
+	if (WARN_ON(IS_ERR_VALUE(npages)))
+		return;
+	/*
 	 * TODO: this can be optimized for huge pages: if a series of pages is
 	 * physically contiguous and part of the same compound page, then a
 	 * single operation to the head page should suffice.
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

