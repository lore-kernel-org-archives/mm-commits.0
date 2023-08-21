Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66D6EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjHUUmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjHUUmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A02129
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0B6649CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FC6C433C7;
        Mon, 21 Aug 2023 20:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650463;
        bh=duSSaeuXneRix9Xw0BiCjDEZ1sAhCl8BIwqDsNgw1Mw=;
        h=Date:To:From:Subject:From;
        b=fszl9I0xe7ldHYgz6CcD5hKGrrdsM7/M+bWlZv46SwHkDK7zWKCJLaOdmlyPxmL5r
         cf6BbuQZZXQp1VkNM/lqhZsukXirncR2MDziz+EC86TJnOefZAqB0LAcGN1lDXFvt3
         CWW/JfYdpzkD8a98OVrAV7K4kBuYEWssurV3/zsA=
Date:   Mon, 21 Aug 2023 13:41:02 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch removed from -mm tree
Message-Id: <20230821204102.F0FC6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: remove obsolete comment for struct z3fold_pool
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/z3fold: remove obsolete comment for struct z3fold_pool
Date: Mon, 14 Aug 2023 22:11:42 +0000

Since commit e774a7bc7f0a ("mm: zswap: remove page reclaim logic from
z3fold"), zpool and zpool_ops have been removed, so also remove the
corresponding comments.

Link: https://lkml.kernel.org/r/20230814221142.486548-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-obsolete-comment-for-struct-z3fold_pool
+++ a/mm/z3fold.c
@@ -133,8 +133,6 @@ struct z3fold_header {
  * @stale:	list of pages marked for freeing
  * @pages_nr:	number of z3fold pages in the pool.
  * @c_handle:	cache for z3fold_buddy_slots allocation
- * @zpool:	zpool driver
- * @zpool_ops:	zpool operations structure with an evict callback
  * @compact_wq:	workqueue for page layout background optimization
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


