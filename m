Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE02C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4994E21D43
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600488377;
	bh=WLrj/cvIQsp2utr7BvuYDjfd3wWd3iRAiUX22PqgJRQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OntyxPmvZIv+nl67PFITor5804Fda7nh0TWxqpfNHc0dvJrzTB9YVXgbhsxITDi15
	 SsPQpKedCsnXRrb/rm27XlXeBQhJVcAIu2ilBizrvNf57zHtbkrCtRcbd9sv/3iE+R
	 KkwmkqS6TPj2OwYPf+O7xJro+vtHZPhEQSk/hkqQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgISEGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgISEGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:06:16 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FA621897;
        Sat, 19 Sep 2020 04:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600488376;
        bh=WLrj/cvIQsp2utr7BvuYDjfd3wWd3iRAiUX22PqgJRQ=;
        h=Date:From:To:Subject:From;
        b=MwaedCvzX8UrKHUfwUnFwrKIdXmwqSIo81PZNMcc/V+5MitqIvi2FAhCHK29+vCFO
         CCF9rrc6nZ8iyN2tA9TH45y5AsTQbMFb6rJLEhmPRxUShy1qC+dCM1fy4/dFTCdD2I
         144Z4qL6M5wC5Ss5SkhOj7mqPfArpnTA5DJ9hjLo=
Date:   Fri, 18 Sep 2020 21:06:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jrdr.linux@gmail.com,
        ira.weiny@intel.com, dan.carpenter@oracle.com, jhubbard@nvidia.com
Subject:  +
 mm-gup-protect-unpin_user_pages-against-npages==-errno.patch added to -mm
 tree
Message-ID: <20200919040614.EWADC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: protect unpin_user_pages() against npages==-ERRNO
has been added to the -mm tree.  Its filename is
     mm-gup-protect-unpin_user_pages-against-npages==-errno.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-protect-unpin_user_pages-against-npages%3D%3D-errno.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-protect-unpin_user_pages-against-npages%3D%3D-errno.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
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

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages==-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch

