Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF4EC63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B5122258
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 00:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgBYOqWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKNAXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKNAXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 19:23:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD772224D;
        Sat, 14 Nov 2020 00:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313413;
        bh=yPmU+OhoKhtglFJzoMPC3lo8qUr8KFTQNDpEbObytDA=;
        h=Date:From:To:Subject:From;
        b=HgBYOqWUtKbSbbYmi0IEGUYTk/Axh8WmjQCBMf6U753YQR22e1rsFHELblVEQdZya
         te7ODQPwszFN7GdduQsW5Pgsey23P6YBuotkTl2lIQuBr4bIXBgbC3CmKhwDexvWYC
         yVhbrScUWp7iEw3zBqAC2A+Dgcu0gdjq5fKbZ6Gw=
Date:   Fri, 13 Nov 2020 16:23:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-introduce-memfd=5Fsecret-system-call-to-create-secret-me?=
 =?US-ASCII?Q?mory-areas-fix.patch?= added to -mm tree
Message-ID: <20201114002332.05VCHXK1r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix

use find_get_page() in secretmem_fault()

Link: https://lkml.kernel.org/r/20201113135848.GF17076@casper.infradead.org
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix
+++ a/mm/secretmem.c
@@ -64,7 +64,7 @@ static vm_fault_t secretmem_fault(struct
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
-	page = find_get_entry(mapping, offset);
+	page = find_get_page(mapping, offset);
 	if (!page) {
 		page = secretmem_alloc_page(vmf->gfp_mask);
 		if (!page)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

