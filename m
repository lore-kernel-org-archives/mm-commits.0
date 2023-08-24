Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278C5C727A0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbjHXXWy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjHXXWS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7EFA8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B00E6393B
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B5C433C7;
        Thu, 24 Aug 2023 23:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919336;
        bh=+6v3KETmxvuSQiwVnJxN0oNTF85XOCtLSkGzFvP9g7A=;
        h=Date:To:From:Subject:From;
        b=BYQSx37bqtDjmGJUOeHJTQV723exJKs60E2OEcQLnnbyPn27oD0ZtiU7+CVxdIU4l
         RrmCbVB7e/x6tfPAmaW3DSKSW1h+8VQuOUIfxjVAbATNvLXTDcD0lifSVUwGAiRaUo
         QeY48oeG0n3LrFofxJ8onpKkfYOndHGOlK4C3tYg=
Date:   Thu, 24 Aug 2023 16:22:15 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-clean_record_shared_mapping_range-kernel-doc.patch removed from -mm tree
Message-Id: <20230824232215.E04B5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix clean_record_shared_mapping_range kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-fix-clean_record_shared_mapping_range-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix clean_record_shared_mapping_range kernel-doc
Date: Fri, 18 Aug 2023 21:06:29 +0100

Turn the a), b) into an unordered ReST list and remove the unnecessary
'Note:' prefix.

Link: https://lkml.kernel.org/r/20230818200630.2719595-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/mapping_dirty_helpers.c~mm-fix-clean_record_shared_mapping_range-kernel-doc
+++ a/mm/mapping_dirty_helpers.c
@@ -288,13 +288,14 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_rang
  * @end: Pointer to the number of the last set bit in @bitmap.
  * none set. The value is modified as new bits are set by the function.
  *
- * Note: When this function returns there is no guarantee that a CPU has
+ * When this function returns there is no guarantee that a CPU has
  * not already dirtied new ptes. However it will not clean any ptes not
  * reported in the bitmap. The guarantees are as follows:
- * a) All ptes dirty when the function starts executing will end up recorded
- *    in the bitmap.
- * b) All ptes dirtied after that will either remain dirty, be recorded in the
- *    bitmap or both.
+ *
+ * * All ptes dirty when the function starts executing will end up recorded
+ *   in the bitmap.
+ * * All ptes dirtied after that will either remain dirty, be recorded in the
+ *   bitmap or both.
  *
  * If a caller needs to make sure all dirty ptes are picked up and none
  * additional are added, it first needs to write-protect the address-space
_

Patches currently in -mm which might be from willy@infradead.org are


