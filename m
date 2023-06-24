Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B93EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjFXAAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFXAAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B5A2711
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E38061584
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EB4C433C8;
        Sat, 24 Jun 2023 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564818;
        bh=XJiIbSncK+OEqygfBvIxAldDnrOi037n1EuEJFsSFF0=;
        h=Date:To:From:Subject:From;
        b=mTrwqWZVtYS22wPvLQn5tzXV98qYh72V1PUw1jqsoBb+sy08L4hYy8Mq245a6h67I
         Kg4NB3rbrA0Juyxm5genSH4kZl9mEEAf+sD4IsXCXLaP66WJaDeIOkJWnRl2ShjINv
         T+MO7/iVqlggxlFfc8bGvzt2ml09088wVlK7pAE0=
Date:   Fri, 23 Jun 2023 17:00:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scatterlist-add-sg_set_folio.patch removed from -mm tree
Message-Id: <20230624000018.92EB4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scatterlist: add sg_set_folio()
has been removed from the -mm tree.  Its filename was
     scatterlist-add-sg_set_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: scatterlist: add sg_set_folio()
Date: Wed, 21 Jun 2023 17:45:47 +0100

This wrapper for sg_set_page() lets drivers add folios to a scatterlist
more easily.  We could, perhaps, do better by using a different page in
the folio if offset is larger than UINT_MAX, but let's hope we get a
better data structure than this before we need to care about such large
folios.

Link: https://lkml.kernel.org/r/20230621164557.3510324-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/include/linux/scatterlist.h~scatterlist-add-sg_set_folio
+++ a/include/linux/scatterlist.h
@@ -141,6 +141,30 @@ static inline void sg_set_page(struct sc
 	sg->length = len;
 }
 
+/**
+ * sg_set_folio - Set sg entry to point at given folio
+ * @sg:		 SG entry
+ * @folio:	 The folio
+ * @len:	 Length of data
+ * @offset:	 Offset into folio
+ *
+ * Description:
+ *   Use this function to set an sg entry pointing at a folio, never assign
+ *   the folio directly. We encode sg table information in the lower bits
+ *   of the folio pointer. See sg_page() for looking up the page belonging
+ *   to an sg entry.
+ *
+ **/
+static inline void sg_set_folio(struct scatterlist *sg, struct folio *folio,
+			       size_t len, size_t offset)
+{
+	WARN_ON_ONCE(len > UINT_MAX);
+	WARN_ON_ONCE(offset > UINT_MAX);
+	sg_assign_page(sg, &folio->page);
+	sg->offset = offset;
+	sg->length = len;
+}
+
 static inline struct page *sg_page(struct scatterlist *sg)
 {
 #ifdef CONFIG_DEBUG_SG
_

Patches currently in -mm which might be from willy@infradead.org are


