Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01F8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbiE0QhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350079AbiE0QfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7F452E5F
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41065B82299
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007EEC385A9;
        Fri, 27 May 2022 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669296;
        bh=Co1DC5RCS7Tixv7Bc9QSgIlU745J/uAzb4UiAXIl3x0=;
        h=Date:To:From:Subject:From;
        b=t/HYkYA2oK702ddQHl4tpmoGwtbJZW9uTbSn5PfKNELC41ECKGSO5kw22IU36fjYW
         HDx+Z2w/y5Di79VAf1ZS1dfXFkaw1Pgw3osn3WE7fcbsMgedmNJlw7Io7olZg2J5HO
         Z4skHEA/FlmVd0eHc1bFuRvRxyaLESUd+RQPrHt4=
Date:   Fri, 27 May 2022 09:34:55 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch removed from -mm tree
Message-Id: <20220527163456.007EEC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: throw warning on failure of trylock_page in z3fold_alloc
has been removed from the -mm tree.  Its filename was
     mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: throw warning on failure of trylock_page in z3fold_alloc
Date: Fri, 29 Apr 2022 14:40:43 +0800

If trylock_page fails, the page won't be non-lru movable page.  When this
page is freed via free_z3fold_page, it will trigger bug on PageMovable
check in __ClearPageMovable.  Throw warning on failure of trylock_page to
guard against such rare case just as what zsmalloc does.

Link: https://lkml.kernel.org/r/20220429064051.61552-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -1122,10 +1122,9 @@ retry:
 		__SetPageMovable(page, pool->inode->i_mapping);
 		unlock_page(page);
 	} else {
-		if (trylock_page(page)) {
-			__SetPageMovable(page, pool->inode->i_mapping);
-			unlock_page(page);
-		}
+		WARN_ON(!trylock_page(page));
+		__SetPageMovable(page, pool->inode->i_mapping);
+		unlock_page(page);
 	}
 	z3fold_page_lock(zhdr);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


