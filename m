Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A4DEE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjHUUjZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbjHUUjK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEBF191
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD22564A31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A87C433C8;
        Mon, 21 Aug 2023 20:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650341;
        bh=98CcucQW4Jb42HUzWglx2lrqhpX+o6gzMB+3knsWmmg=;
        h=Date:To:From:Subject:From;
        b=ZdUzxx1fAA3wc79bwEP/tEtXNTXgA9DW8eiDz+7VjaStqoImQPjv2HuN7yG5HJqBQ
         vEco0tFsAa3IF0+PEt3gmHVV6aeB41v9/mtAlamZAItKHHzUc7upP606K2veMFeDJd
         KEKvTjTh6WsqSOm/yrlcwvUA2YKZglcHhaATcJ5g=
Date:   Mon, 21 Aug 2023 13:39:00 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        akpm@linux-foudation.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch removed from -mm tree
Message-Id: <20230821203901.30A87C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: use page_ext_data helper in page_table_check
has been removed from the -mm tree.  Its filename was
     mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: use page_ext_data helper in page_table_check
Date: Tue, 18 Jul 2023 22:58:11 +0800

Use page_ext_data helper in page_table_check to avoid access offset
directly.

Link: https://lkml.kernel.org/r/20230718145812.1991717-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_ext-use-page_ext_data-helper-in-page_table_check
+++ a/mm/page_table_check.c
@@ -51,7 +51,7 @@ struct page_ext_operations page_table_ch
 static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
 {
 	BUG_ON(!page_ext);
-	return (void *)(page_ext) + page_table_check_ops.offset;
+	return page_ext_data(page_ext, &page_table_check_ops);
 }
 
 /*
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


