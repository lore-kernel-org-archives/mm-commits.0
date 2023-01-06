Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A20C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 00:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbjAFArI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbjAFArH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 19:47:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2E511C3A
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 16:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 578C2B81C0C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 00:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E67FC433EF;
        Fri,  6 Jan 2023 00:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672966023;
        bh=8xGkzJX3+4SD+uQKJuZBundgLaIaULATgeMikZewQWc=;
        h=Date:To:From:Subject:From;
        b=f65zpHPnz+CC5DfAfNFTQdHJaYfYOMghFqy2jKa1LKFX63cqHuqEz9qz1TcmKZ4Oq
         xHDKHSbEYEJWArtJyAR3HLwehgXYXSl3UAO3bdt8M9HHfdEXxLuF6g602JKgeEensS
         E3XZQcLWsQOGRPtNLtTLWI3QT0oFsf521MijkkVU=
Date:   Thu, 05 Jan 2023 16:47:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        ira.weiny@intel.com, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-two-spelling-mistakes-in-highmemh.patch added to mm-unstable branch
Message-Id: <20230106004703.0E67FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix two spelling mistakes in highmem.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-two-spelling-mistakes-in-highmemh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-two-spelling-mistakes-in-highmemh.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm: fix two spelling mistakes in highmem.h
Date: Thu, 5 Jan 2023 13:13:05 +0100

Substitute two occurrencies of "higmem" with "highmem" in highmem.h.

Link: https://lkml.kernel.org/r/20230105121305.30714-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~mm-fix-two-spelling-mistakes-in-highmemh
+++ a/include/linux/highmem.h
@@ -86,7 +86,7 @@ static inline void kmap_flush_unused(voi
  * virtual address of the direct mapping. Only real highmem pages are
  * temporarily mapped.
  *
- * While it is significantly faster than kmap() for the higmem case it
+ * While it is significantly faster than kmap() for the highmem case it
  * comes with restrictions about the pointer validity.
  *
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
@@ -119,7 +119,7 @@ static inline void *kmap_local_page(stru
  * virtual address of the direct mapping. Only real highmem pages are
  * temporarily mapped.
  *
- * While it is significantly faster than kmap() for the higmem case it
+ * While it is significantly faster than kmap() for the highmem case it
  * comes with restrictions about the pointer validity. Only use when really
  * necessary.
  *
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch
mm-fix-two-spelling-mistakes-in-highmemh.patch

