Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F93FEE49B0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjHUUjd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjHUUjV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B99126
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B9264AFF
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E59C433C8;
        Mon, 21 Aug 2023 20:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650357;
        bh=+ZOLNtRaLvIJ9LlyfxqDxCt8kLYmIOhRqUqzO3Hqae8=;
        h=Date:To:From:Subject:From;
        b=mf6a+alT8CZu5kWP2ZdoFdEZmCkrgio4auJtlJOQI06wFBhN63xRqsbVgSOsc94Kc
         pfe1AmbcsIxIFQgfeWjWVCD5YBC6pagXicPlVvR6BD2ojb04XU+rCf6ekIXqRYi6GB
         oexQMSbLvl7QH6/gKkV+vPokUt14WQBlpyjDnxl0=
Date:   Mon, 21 Aug 2023 13:39:17 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch removed from -mm tree
Message-Id: <20230821203917.B1E59C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: move page_ext_operations definition under CONFIG_PAGE_EXTENSION
has been removed from the -mm tree.  Its filename was
     mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: move page_ext_operations definition under CONFIG_PAGE_EXTENSION
Date: Mon, 17 Jul 2023 19:32:27 +0800

page_ext_operations should only be defined when CONFIG_PAGE_EXTENSION is
enabled.

Besides, this may detect missing reliance on CONFIG_PAGE_EXTENSION from
future Page Extension clients at compile time.

Link: https://lkml.kernel.org/r/20230717113227.1897173-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/page_ext.h~mm-page_ext-move-page_ext_operations-definition-under-config_page_extension
+++ a/include/linux/page_ext.h
@@ -8,6 +8,7 @@
 
 struct pglist_data;
 
+#ifdef CONFIG_PAGE_EXTENSION
 /**
  * struct page_ext_operations - per page_ext client operations
  * @offset: Offset to the client's data within page_ext. Offset is returned to
@@ -29,8 +30,6 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
-#ifdef CONFIG_PAGE_EXTENSION
-
 /*
  * The page_ext_flags users must set need_shared_flags to true.
  */
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


