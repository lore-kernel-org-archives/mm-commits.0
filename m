Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24096C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjBJA53 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjBJAzd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477B57431E
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0D79B82396
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94042C433EF;
        Fri, 10 Feb 2023 00:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990469;
        bh=/n+TwvdeB8Drr8bQCx9HG/P2N2ccyVu9fmS1JnVq4tQ=;
        h=Date:To:From:Subject:From;
        b=KMlDdzaPEuEIY2ICb17Cb2SSnYDslLGt6TySnkKQ9HU1ue+ZyN4spXbloc8fQJjz8
         BQP+J65Kwq57I3FcSeG9fHiAsIIxu4CCivTFLgA/y407pZd/0AhzF8rERZkKwRBK4m
         nfSxzQdBbQoJ2gwHPNcGviy7J+3KnbcFUZQTBHcU=
Date:   Thu, 09 Feb 2023 16:54:29 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-obsolete-foll_longterm-comment.patch removed from -mm tree
Message-Id: <20230210005429.94042C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: remove obsolete FOLL_LONGTERM comment
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-obsolete-foll_longterm-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: remove obsolete FOLL_LONGTERM comment
Date: Tue, 24 Jan 2023 16:34:23 -0400

These days FOLL_LONGTERM is not allowed at all on any get_user_pages*()
functions, it must be only be used with pin_user_pages*(), plus it now has
universal support for all the pin_user_pages*() functions.

Link: https://lkml.kernel.org/r/2-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
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

 include/linux/mm_types.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/mm_types.h~mm-gup-remove-obsolete-foll_longterm-comment
+++ a/include/linux/mm_types.h
@@ -1053,12 +1053,6 @@ typedef unsigned int __bitwise zap_flags
  * specifically failed.  Filesystem pages are still subject to bugs and use of
  * FOLL_LONGTERM should be avoided on those pages.
  *
- * FIXME: Also NOTE that FOLL_LONGTERM is not supported in every GUP call.
- * Currently only get_user_pages() and get_user_pages_fast() support this flag
- * and calls to get_user_pages_[un]locked are specifically not allowed.  This
- * is due to an incompatibility with the FS DAX check and
- * FAULT_FLAG_ALLOW_RETRY.
- *
  * In the CMA case: long term pins in a CMA region would unnecessarily fragment
  * that region.  And so, CMA attempts to migrate the page before pinning, when
  * FOLL_LONGTERM is specified.
_

Patches currently in -mm which might be from jgg@nvidia.com are


