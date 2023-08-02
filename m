Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B686CC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 17:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjHBRrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbjHBRrH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 13:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3268635B7
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 10:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E8861A74
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 17:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3B6C433C8;
        Wed,  2 Aug 2023 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690998388;
        bh=9EyEUajdvTEp/7wn0+FaNAZk9bm1K4aL674phxf1wY0=;
        h=Date:To:From:Subject:From;
        b=iTsFzJdbArKVeQMiPn2kn6kNaXrL0JI2ks+dLL1ilLWVBOP2HbviRiZWTEad4XSqb
         XeBbf09QW3lwENEA8QUClRqf9u2IXtio5j9rfp8em/8FSwFkdAWRqpjGhC43TJSah5
         KPCdBsn8mSvSDruPODHxSBCk5su7rc3XhpfI7G2s=
Date:   Wed, 02 Aug 2023 10:46:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        agruenba@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch added to mm-unstable branch
Message-Id: <20230802174628.1F3B6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: memcpy_{from,to}_folio() fix
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch

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
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: highmem: memcpy_{from,to}_folio() fix
Date: Wed, 2 Aug 2023 16:43:54 +0200

memcpy_to_folio() and memcpy_from_folio() compute the size of the chunk
of memory they can copy for each page, but then they don't use the chunk
size in the actual memcpy.  Fix that.

Also, git rid of superfluous parentheses in these two functions.

Link: https://lkml.kernel.org/r/20230802144354.1023099-1-agruenba@redhat.com
Fixes: 520a10fe2d72 ("highmem: add memcpy_to_folio() and memcpy_from_folio()")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/highmem.h~highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix
+++ a/include/linux/highmem.h
@@ -445,13 +445,13 @@ static inline void memcpy_from_folio(cha
 	VM_BUG_ON(offset + len > folio_size(folio));
 
 	do {
-		char *from = kmap_local_folio(folio, offset);
+		const char *from = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
 		if (folio_test_highmem(folio) &&
-		    (chunk > (PAGE_SIZE - offset_in_page(offset))))
+		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
-		memcpy(to, from, len);
+		memcpy(to, from, chunk);
 		kunmap_local(from);
 
 		from += chunk;
@@ -470,9 +470,9 @@ static inline void memcpy_to_folio(struc
 		size_t chunk = len;
 
 		if (folio_test_highmem(folio) &&
-		    (chunk > (PAGE_SIZE - offset_in_page(offset))))
+		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
-		memcpy(to, from, len);
+		memcpy(to, from, chunk);
 		kunmap_local(to);
 
 		from += chunk;
_

Patches currently in -mm which might be from agruenba@redhat.com are

highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch

