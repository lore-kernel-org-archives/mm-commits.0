Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9EFC727A0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241186AbjHXXWa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244073AbjHXXVy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07382A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9665363676
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB7DC433C7;
        Thu, 24 Aug 2023 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919307;
        bh=SW60VAh0vzGpMPidktAlrOFKjj4m3AuTG7Yvvgq90oM=;
        h=Date:To:From:Subject:From;
        b=R9LeCUT9rWcV5/ajpLfe+hlmaC+qJLwUk6IXkq/CWF8YuWIrPPahmYphzMELIbJnC
         Q3l2ui/DK/yI2oWKFqDghR6UIq+2w4r2kQZfkyfbamVqJGuw84zeuvgEKkEuobpjAw
         ta4VmZoOykNli3yoakGd1X/cQQ4gq2Xm50zx+zLc=
Date:   Thu, 24 Aug 2023 16:21:46 -0700
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_mapping_file.patch removed from -mm tree
Message-Id: <20230824232146.EEB7DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove page_mapping_file()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_mapping_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove page_mapping_file()
Date: Wed, 2 Aug 2023 16:13:58 +0100

This function has no more users.

Link: https://lkml.kernel.org/r/20230802151406.3735276-31-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-page_mapping_file
+++ a/include/linux/pagemap.h
@@ -414,14 +414,6 @@ static inline struct address_space *page
 	return folio_file_mapping(page_folio(page));
 }
 
-/*
- * For file cache pages, return the address_space, otherwise return NULL
- */
-static inline struct address_space *page_mapping_file(struct page *page)
-{
-	return folio_flush_mapping(page_folio(page));
-}
-
 /**
  * folio_inode - Get the host inode for this folio.
  * @folio: The folio.
_

Patches currently in -mm which might be from willy@infradead.org are


