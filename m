Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864C3EB64DD
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjFXAAf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjFXAAT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94141270B
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3150A615F3
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814DEC433C8;
        Sat, 24 Jun 2023 00:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564817;
        bh=YJLrRd57AP90MqzCyzqRAxfCON9coO5BXzB5sq/NkdQ=;
        h=Date:To:From:Subject:From;
        b=BA1PeDarKT6m6lYBjcrYuTyDDO2SXMGKnHBBS5TsrfTMWAtGfZqjSAIVgjOds41U0
         DM8PjZBfH+wxnwJg0WZJ2Xl0OS3qCP8nS9NJ/ycFMAaF630Ehr3sgkuOCHcc5uuoY9
         o8pMuHZf9dzyrN9/a9ppdudtJLc+VGgpFBAKrzZE=
Date:   Fri, 23 Jun 2023 17:00:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-__folio_batch_release.patch removed from -mm tree
Message-Id: <20230624000017.814DEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add __folio_batch_release()
has been removed from the -mm tree.  Its filename was
     mm-add-__folio_batch_release.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add __folio_batch_release()
Date: Wed, 21 Jun 2023 17:45:46 +0100

This performs the same role as __pagevec_release(), ie skipping the check
for batch length of 0.

Link: https://lkml.kernel.org/r/20230621164557.3510324-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/pagevec.h~mm-add-__folio_batch_release
+++ a/include/linux/pagevec.h
@@ -127,9 +127,15 @@ static inline unsigned folio_batch_add(s
 	return fbatch_space(fbatch);
 }
 
+static inline void __folio_batch_release(struct folio_batch *fbatch)
+{
+	__pagevec_release((struct pagevec *)fbatch);
+}
+
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
-	pagevec_release((struct pagevec *)fbatch);
+	if (folio_batch_count(fbatch))
+		__folio_batch_release(fbatch);
 }
 
 void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
_

Patches currently in -mm which might be from willy@infradead.org are


