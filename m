Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47C3C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFF42222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633142;
	bh=5q4yq1WqrA1fxYozEfb1M0AZwwgjjeqV0S0X3cFTOAs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NUH8MFhDA6SD2sygXrZzolzGF9Hq3f54x/al2hZAUwG4XoSG5CT9JpgNHHq9uACoY
	 YDLVsyXVVjLGBLhiwipvRQrOFWTRRzyJXF5hxXdxTAc5GRa6+UFwwX2Zu0YE3d85pO
	 iSUW+rj3y9x5kRxgEnBZkur91gGgGKAYpEOlFkkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgJMXwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgJMXwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 362C422200;
        Tue, 13 Oct 2020 23:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633122;
        bh=5q4yq1WqrA1fxYozEfb1M0AZwwgjjeqV0S0X3cFTOAs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xqcGkgKJbGa1y4iIfQlVMfEI1rqpprAVTRPec32R/Fq1a1HA8EP8tKZ3xD5dGntZs
         9xIqIb2IAMaX3usC3wTuxlRXW7AQIARol41CErmAlB13bW8NtlHcWTxp2s+v8HQDrC
         8s7Ubzb0HsBJfbuqz8SmPaGyzHaYBDvIBJf/0pa0=
Date:   Tue, 13 Oct 2020 16:52:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ira.weiny@intel.com, jhubbard@nvidia.com, jrdr.linux@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 067/181] mm/gup: protect unpin_user_pages()
 against npages==-ERRNO
Message-ID: <20201013235201.FZrZ9P783%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
