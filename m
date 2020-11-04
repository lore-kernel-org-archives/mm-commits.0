Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AD3C388F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EBA22403
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604452267;
	bh=DDlat8DVHQvG8D2HOf5DT0H/b3r9Ghx21ShnVhi3ZgE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pGKdMsJ0S+Z3WnoemQdclCxjUDOyggFncAd0m6XVf81Y1QwnmYg+HhztFzpRycfQb
	 vds5HSoLn6uXW4vvbC1ziGRpzgmzCFQR8PwyQVInUtkVqEn5wc+RiIeZB8IFhYrrtb
	 UkAPv9Cd+D1gQ1vRr4kZ/Nd9ffs8LYFjznYwPUNw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgKDBLG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729144AbgKDBLG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:11:06 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B51223C7;
        Wed,  4 Nov 2020 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604452265;
        bh=DDlat8DVHQvG8D2HOf5DT0H/b3r9Ghx21ShnVhi3ZgE=;
        h=Date:From:To:Subject:From;
        b=shgLBMdseoQTukVS8AukbZ3y5cpXvrabyuhrY54O0wCVSYsYtQJItOQ10MGSzHO+r
         RpIBGuUS47wkH2G8datMH4IPvYO00eoSZHpXoLj/LTo0fT3JIwL6rrU2/HkUCZf3Gv
         1OY6vHfVliQw2AsAn5KNElqWZptgQkMx0fhLgmXM=
Date:   Tue, 03 Nov 2020 17:11:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com, dsterba@suse.com,
        willy@infradead.org
Subject:  + mm-fix-readahead_page_batch-for-retry-entries.patch added
 to -mm tree
Message-ID: <20201104011105.bODAN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix readahead_page_batch for retry entries
has been added to the -mm tree.  Its filename is
     mm-fix-readahead_page_batch-for-retry-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-readahead_page_batch-for-retry-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-readahead_page_batch-for-retry-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix readahead_page_batch for retry entries

Both btrfs and fuse have reported faults caused by seeing a retry entry
instead of the page they were looking for.  This was caused by a missing
check in the iterator.

Link: https://lkml.kernel.org/r/20201103142852.8543-1-willy@infradead.org
Fixes: 042124cc64c3 ("mm: add new readahead_control API")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: David Sterba <dsterba@suse.com>
Reported-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/pagemap.h~mm-fix-readahead_page_batch-for-retry-entries
+++ a/include/linux/pagemap.h
@@ -906,6 +906,8 @@ static inline unsigned int __readahead_b
 	xas_set(&xas, rac->_index);
 	rcu_read_lock();
 	xas_for_each(&xas, page, rac->_index + rac->_nr_pages - 1) {
+		if (xas_retry(&xas, page))
+			continue;
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		array[i++] = page;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch

