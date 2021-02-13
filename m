Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E92C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8909264E9A
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBMEle (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBMEl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:41:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A3F564E64;
        Sat, 13 Feb 2021 04:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191247;
        bh=zie2jKuCt8WB9OSqarTXfZxgTHHKzqRJbgAG31pU1zI=;
        h=Date:From:To:Subject:From;
        b=SJBCqMzxtXvebmx4eF5xTBOdhgeOeKDOJnw/QCMMH4uKqSug+TjKe0zqtFA/aPbSl
         c0BdqP7gA8tbQjgO4/C7gcGL/zUyFwF4h1Ep3Duo1e6/xb2YfjA12lSW4i+JScMp2c
         FqmQos1yozv30+IJwsc66Q6q7rO5/jBLDpkgzsHM=
Date:   Fri, 12 Feb 2021 20:40:47 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        song.bao.hua@hisilicon.com, sjenning@redhat.com, ddstreet@ieee.org,
        dan.carpenter@oracle.com, tiantao6@hisilicon.com
Subject:  [folded-merged]
 mm-zswap-add-the-flag-can_sleep_mapped-fix-2.patch removed from -mm tree
Message-ID: <20210213044047.FdYsS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix potential memory leak
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-the-flag-can_sleep_mapped-fix-2.patch

This patch was dropped because it was folded into mm-zswap-add-the-flag-can_sleep_mapped.patch

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm/zswap: fix potential memory leak

If entry is NULL, the requested memory tmp should be freed, otherwise it
may cause a memory leak.

Link: https://lkml.kernel.org/r/1611538365-51811-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-add-the-flag-can_sleep_mapped-fix-2
+++ a/mm/zswap.c
@@ -962,6 +962,7 @@ static int zswap_writeback_entry(struct
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		zpool_unmap_handle(pool, handle);
+		kfree(tmp);
 		return 0;
 	}
 	spin_unlock(&tree->lock);
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch
mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch
mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

