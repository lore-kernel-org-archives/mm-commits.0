Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726D4C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBJA5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBJAz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3BE74321
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D29FB82272
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7DEC433D2;
        Fri, 10 Feb 2023 00:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990472;
        bh=vOiUNcsB/8BiWkElTIMV30rY9iA2h+7PYcxuIGjOJGw=;
        h=Date:To:From:Subject:From;
        b=tvt4NDv6cqk5FWbuFVbLRQLjI6cmiRYiegTTquvxvSRP7SD0yEV0NkKfwLKCIswiU
         0AClTL7XdNziBjgzciYSuXg1QnfftSGT1M77zlw2EpPIHsCgbQac/S3KySK6CVZ1lj
         S6V/oAh1tu6eE15dQ3ypRClHX/PfxdunF1x8QHSc=
Date:   Thu, 09 Feb 2023 16:54:32 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-move-try_grab_page-to-mm-internalh.patch removed from -mm tree
Message-Id: <20230210005432.BB7DEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: move try_grab_page() to mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-gup-move-try_grab_page-to-mm-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: move try_grab_page() to mm/internal.h
Date: Tue, 24 Jan 2023 16:34:25 -0400

This is part of the internal function of gup.c and is only non-static so
that the parts of gup.c in the huge_memory.c and hugetlb.c can call it.

Put it in internal.h beside the similarly purposed try_grab_folio()

Link: https://lkml.kernel.org/r/4-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/internal.h      |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-gup-move-try_grab_page-to-mm-internalh
+++ a/include/linux/mm.h
@@ -1268,8 +1268,6 @@ static inline void get_page(struct page
 	folio_get(page_folio(page));
 }
 
-int __must_check try_grab_page(struct page *page, unsigned int flags);
-
 static inline __must_check bool try_get_page(struct page *page)
 {
 	page = compound_head(page);
--- a/mm/internal.h~mm-gup-move-try_grab_page-to-mm-internalh
+++ a/mm/internal.h
@@ -856,6 +856,7 @@ int migrate_device_coherent_page(struct
  * mm/gup.c
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
+int __must_check try_grab_page(struct page *page, unsigned int flags);
 
 extern bool mirrored_kernelcore;
 
_

Patches currently in -mm which might be from jgg@nvidia.com are


