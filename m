Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E2DEE49B3
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjHUUj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjHUUjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C8199
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35BEF64ADB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B40C433C8;
        Mon, 21 Aug 2023 20:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650342;
        bh=rIlljuR2+P9EWkHkfkc1Ymk0iLSeyDwtamOZB0wgPpc=;
        h=Date:To:From:Subject:From;
        b=HpGpVBhEdYJGjwQe8aHG9v2tLdUou1mVUzx4O+I+eU8KyLS9k+WCEUy5jlQjJNDV6
         G3IP6/2NAn4Cx4A7EbgAfMHSnWdL3r0QV/Ozt07YEd2ePEkuzRJ22eL91oUDwwpH5Q
         +tLwdOTr8a4usr+gnG58FnEQAsF9BfodUB1uTNTA=
Date:   Mon, 21 Aug 2023 13:39:02 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        akpm@linux-foudation.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-use-page_ext_data-helper-in-page_owner.patch removed from -mm tree
Message-Id: <20230821203902.89B40C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: use page_ext_data helper in page_owner
has been removed from the -mm tree.  Its filename was
     mm-page_ext-use-page_ext_data-helper-in-page_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: use page_ext_data helper in page_owner
Date: Tue, 18 Jul 2023 22:58:12 +0800

Use page_ext_data helper in page_owner to avoid access offset directly.

Link: https://lkml.kernel.org/r/20230718145812.1991717-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_ext-use-page_ext_data-helper-in-page_owner
+++ a/mm/page_owner.c
@@ -104,7 +104,7 @@ struct page_ext_operations page_owner_op
 
 static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
 {
-	return (void *)page_ext + page_owner_ops.offset;
+	return page_ext_data(page_ext, &page_owner_ops);
 }
 
 static noinline depot_stack_handle_t save_stack(gfp_t flags)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


