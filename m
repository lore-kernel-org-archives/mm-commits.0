Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9A7C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBDA221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486027;
	bh=7ZeVhE7WF0Y+3roOnbTSixV57L076m+UsTKBMmqxYF8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YeRHlRNaPvut8hykrSMvyDc97uK9ZC24HipSpsL4VRCzjVv0yL+bROEcj61wVdCni
	 PHBK7vfHbKlQ4OSx+qXvr2R/d6p1ZBjIl5HgpCvitfY6obPD3VwJGOx+eBcDYEpd4I
	 armNeGz+fFdjs2bDP3FoKjAnWsySDvnSc7s4HO5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgISD1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgISD1G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:27:06 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2342C21534;
        Sat, 19 Sep 2020 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486026;
        bh=7ZeVhE7WF0Y+3roOnbTSixV57L076m+UsTKBMmqxYF8=;
        h=Date:From:To:Subject:From;
        b=nuWmJBKtaj52h42+mJ++8u9JCjF6qU3kYqR5j2mZ8SEVt91HlBjSYvPZO/w6PueGX
         yjrWhR+cUEUJyE/QR5i04mUfMcV8lHXl16UVoQjvVc7OSuxT7JxnPpJnCgCEPi62j5
         6sjLwPrjyEgja/iE8lGiDYw3Je+pUTpDuJ2qf8dQ=
Date:   Fri, 18 Sep 2020 20:27:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        hch@lst.de, dan.j.williams@intel.com, akpm@linux-foundation.org,
        rcampbell@nvidia.com
Subject:  + mm-move-call-to-compound_head-in-release_pages.patch
 added to -mm tree
Message-ID: <20200919032705.WTP9v%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move call to compound_head() in release_pages()
has been added to the -mm tree.  Its filename is
     mm-move-call-to-compound_head-in-release_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-call-to-compound_head-in-release_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-call-to-compound_head-in-release_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: move call to compound_head() in release_pages()

The function is_huge_zero_page() doesn't call compound_head() to make sure
the page pointer is a head page. The call to is_huge_zero_page() in
release_pages() is made before compound_head() is called so the test would
fail if release_pages() was called with a tail page of the huge_zero_page
and put_page_testzero() would be called releasing the page.
This is unlikely to be happening in normal use or we would be seeing all
sorts of process data corruption when accessing a THP zero page.

Looking at other places where is_huge_zero_page() is called, all seem to
only pass a head page so I think the right solution is to move the call
to compound_head() in release_pages() to a point before calling
is_huge_zero_page().

Link: https://lkml.kernel.org/r/20200917173938.16420-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-move-call-to-compound_head-in-release_pages
+++ a/mm/swap.c
@@ -848,6 +848,7 @@ void release_pages(struct page **pages,
 			locked_pgdat = NULL;
 		}
 
+		page = compound_head(page);
 		if (is_huge_zero_page(page))
 			continue;
 
@@ -869,7 +870,6 @@ void release_pages(struct page **pages,
 			}
 		}
 
-		page = compound_head(page);
 		if (!put_page_testzero(page))
 			continue;
 
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-thp-fix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-test-use-the-new-skip-macro.patch
hmm-test-remove-unused-dmirror_zero_page.patch
mm-move-call-to-compound_head-in-release_pages.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

