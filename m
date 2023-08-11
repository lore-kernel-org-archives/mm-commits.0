Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5049AC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjHKWdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbjHKWdF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:33:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529B1195
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65A56534C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E719C433C7;
        Fri, 11 Aug 2023 22:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793184;
        bh=j0VUFnBVb6Sr11TJ1St1ltbVvwy/UarpBfQGlUi3CbM=;
        h=Date:To:From:Subject:From;
        b=Sn6vp93uj2EkhK0S/wS2uylJcaxuWCc/J1nVhlBO4FhUCWm2xHek4lL4hUB2a9Uo9
         58JO51hhHlRGj1GjYhTpQlIzLpDLfx552JCqPKR8Nbyx/Qi7oe3RMob6ypvSewra62
         0gWev1SDpkDzaUPGIbq6y2fzkTVedWG004HFkvAA=
Date:   Fri, 11 Aug 2023 15:33:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        agruenba@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch removed from -mm tree
Message-Id: <20230811223304.3E719C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem: memcpy_{from,to}_folio() fix
has been removed from the -mm tree.  Its filename was
     highmem-add-memcpy_to_folio-and-memcpy_from_folio-fix.patch

This patch was dropped because it was folded into highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch

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

highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch

