Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09323C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jan 2022 00:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245677AbiAFAAf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 19:00:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39014 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiAFAA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 19:00:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5356C61849
        for <mm-commits@vger.kernel.org>; Thu,  6 Jan 2022 00:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2619C36AE9;
        Thu,  6 Jan 2022 00:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641427226;
        bh=B2OKwa+u/j3sRjwQfhpJWs8F0xXcGSGt+sWESNhz/q8=;
        h=Date:From:To:Subject:From;
        b=al1JqxrSnQI15r8+kSkTjkFd9NX8Z7JAZPDo72nqlIBLukH//hoxDQptDB4sCtZdM
         HFcsuZsATObFFI4huncTfeUEuKKv7nOto0EW5EJm2VV1BIHmW08hnJ95ZqosrdMfH3
         obL3M0QyNIshSONha6oj/nhDLaQ8Jt6xnePv4Y/Y=
Date:   Wed, 05 Jan 2022 16:00:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        willy@infradead.org
Subject:  +
 mm-page-mapping-folio-mapping-should-have-the-same-offset.patch added to
 -mm tree
Message-ID: <20220106000026.RcSbH_ykw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page->mapping folio->mapping should have the same offset
has been added to the -mm tree.  Its filename is
     mm-page-mapping-folio-mapping-should-have-the-same-offset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-mapping-folio-mapping-should-have-the-same-offset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-mapping-folio-mapping-should-have-the-same-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: page->mapping folio->mapping should have the same offset

In commit 7b230db3b8d3 ("mm: Introduce struct folio"), folio is
introduced.  This is a folio of page, so we need to make sure those
members of folio should be at the same offset in page.

The offset of mapping is not checked. This patch just adds it.

Link: https://lkml.kernel.org/r/20220104011734.21714-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm_types.h~mm-page-mapping-folio-mapping-should-have-the-same-offset
+++ a/include/linux/mm_types.h
@@ -289,6 +289,7 @@ static_assert(sizeof(struct page) == siz
 	static_assert(offsetof(struct page, pg) == offsetof(struct folio, fl))
 FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
+FOLIO_MATCH(mapping, mapping);
 FOLIO_MATCH(compound_head, lru);
 FOLIO_MATCH(index, index);
 FOLIO_MATCH(private, private);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page-mapping-folio-mapping-should-have-the-same-offset.patch

