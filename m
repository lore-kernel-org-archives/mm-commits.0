Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0EFC001B1
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjFXAAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjFXAAY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2D8270A
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C7DA614A8
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227FC433C8;
        Sat, 24 Jun 2023 00:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564822;
        bh=OTvUdUlvDmNPTrBq5TtLAqxwnbURHAd/AHYvB+sQe24=;
        h=Date:To:From:Subject:From;
        b=vFB9umF8Cr96SSwJMGhVDHPRnYDQSCali/d+VZ6xu+yz5DCUo0fmbjdpo809SCngH
         6D7sz+MH35yGJz9WPBgWTfAAwCSsKpHaXVn/h53LaKFYOymqBJdvMo9skWpQ2pWZhX
         FYTmRqGy57KSqaQnyHUDs4WLrfRBoGwWFsLBGSk8=
Date:   Fri, 23 Jun 2023 17:00:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pagevec-rename-fbatch_count.patch removed from -mm tree
Message-Id: <20230624000022.8227FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pagevec: rename fbatch_count()
has been removed from the -mm tree.  Its filename was
     pagevec-rename-fbatch_count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: pagevec: rename fbatch_count()
Date: Wed, 21 Jun 2023 17:45:51 +0100

This should always have been called folio_batch_count().

Link: https://lkml.kernel.org/r/20230621164557.3510324-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagevec.h~pagevec-rename-fbatch_count
+++ a/include/linux/pagevec.h
@@ -105,7 +105,7 @@ static inline unsigned int folio_batch_c
 	return fbatch->nr;
 }
 
-static inline unsigned int fbatch_space(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
 {
 	return PAGEVEC_SIZE - fbatch->nr;
 }
@@ -124,7 +124,7 @@ static inline unsigned folio_batch_add(s
 		struct folio *folio)
 {
 	fbatch->folios[fbatch->nr++] = folio;
-	return fbatch_space(fbatch);
+	return folio_batch_space(fbatch);
 }
 
 static inline void __folio_batch_release(struct folio_batch *fbatch)
_

Patches currently in -mm which might be from willy@infradead.org are


