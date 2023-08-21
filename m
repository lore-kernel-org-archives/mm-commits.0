Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1A6EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjHUUIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjHUUIN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E25AE4;
        Mon, 21 Aug 2023 13:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D671649EA;
        Mon, 21 Aug 2023 20:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84613C433C7;
        Mon, 21 Aug 2023 20:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648491;
        bh=JfhRtM3NvgWkry7yYyk/fTiQkApKnU6+O5SkHTvwRok=;
        h=Date:To:From:Subject:From;
        b=xw6crMawLIiefDS6L70RFzh/iIwvNTc5jMpxXXMtYUgsuDj7Jk2I/2gnkYSUc9LlQ
         d5GcRgoXkFI25+DFemf1mGIelB85wGx27amRSKna4f7xorG0Rm+cq30X4FWgw2Y7jY
         1PDzUwwQQHjyQ2RW+rRxvh6d9prXrtCheHoppkF4=
Date:   Mon, 21 Aug 2023 13:08:11 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        willy@infradead.org, trix@redhat.com, stable@vger.kernel.org,
        rongtao@cestc.cn, ndesaulniers@google.com, nathan@kernel.org,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] radix-tree-remove-unused-variable.patch removed from -mm tree
Message-Id: <20230821200811.84613C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree: remove unused variable
has been removed from the -mm tree.  Its filename was
     radix-tree-remove-unused-variable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: radix tree: remove unused variable
Date: Fri, 11 Aug 2023 15:10:13 +0200

Recent versions of clang warn about an unused variable, though older
versions saw the 'slot++' as a use and did not warn:

radix-tree.c:1136:50: error: parameter 'slot' set but not used [-Werror,-Wunused-but-set-parameter]

It's clearly not needed any more, so just remove it.

Link: https://lkml.kernel.org/r/20230811131023.2226509-1-arnd@kernel.org
Fixes: 3a08cd52c37c7 ("radix tree: Remove multiorder support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Rong Tao <rongtao@cestc.cn>
Cc: Tom Rix <trix@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/radix-tree.c~radix-tree-remove-unused-variable
+++ a/lib/radix-tree.c
@@ -1136,7 +1136,6 @@ static void set_iter_tags(struct radix_t
 void __rcu **radix_tree_iter_resume(void __rcu **slot,
 					struct radix_tree_iter *iter)
 {
-	slot++;
 	iter->index = __radix_tree_iter_add(iter, 1);
 	iter->next_index = iter->index;
 	iter->tags = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

iomem-remove-__weak-ioremap_cache-helper.patch

