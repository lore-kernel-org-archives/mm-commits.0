Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F645C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjASBU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjASBS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413DC6C576
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A13A61A53
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94799C433EF;
        Thu, 19 Jan 2023 01:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090969;
        bh=PCUGBCknHzPKWz9WaHg0W5KSM5M/mzjp1ocnPqF3rmI=;
        h=Date:To:From:Subject:From;
        b=G7eot/Ot/mkjB4PUOYmMySNDpg20Q8yfG3b6FczkakbIbM8ltW1/yQ4ez/7MedlkJ
         2ALJ4gKkg9xTyXNKYQak5WGP+6V1wtvqHyrfN3AIN854qwbcvexNyAF+ZLjjRqiz+y
         ce5B5rBm3Na6jub9ztCzvSoZMqWKO4rkHrVanEX0=
Date:   Wed, 18 Jan 2023 17:16:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch removed from -mm tree
Message-Id: <20230119011609.94799C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove an ambiguous sentence from kmap_local_folio() kdocs
has been removed from the -mm tree.  Its filename was
     mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm: remove an ambiguous sentence from kmap_local_folio() kdocs
Date: Thu, 5 Jan 2023 13:04:24 +0100

In the kdocs of kmap_local_folio() there is a an ambiguous sentence which
suggests to use this API "only when really necessary".

On the contrary, since kmap() and kmap_atomic() are deprecated, both
kmap_local_folio(), as well as kmap_local_page(), must be preferred to the
previous ones.

Therefore, remove the above-mentioned sentence exactly how it has
previously been done for the kmap_local_page() kdocs in commit
72f1c55adf70 ("highmem: delete a sentence from kmap_local_page() kdocs").

Link: https://lkml.kernel.org/r/20230105120424.30055-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/highmem.h~mm-remove-an-ambiguous-sentence-from-kmap_local_folio-kdocs
+++ a/include/linux/highmem.h
@@ -119,9 +119,8 @@ static inline void *kmap_local_page(stru
  * virtual address of the direct mapping. Only real highmem pages are
  * temporarily mapped.
  *
- * While it is significantly faster than kmap() for the higmem case it
- * comes with restrictions about the pointer validity. Only use when really
- * necessary.
+ * While it is significantly faster than kmap() for the highmem case it
+ * comes with restrictions about the pointer validity.
  *
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
  * disabling migration in order to keep the virtual address stable across
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch

