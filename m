Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B33C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357411AbiCYBeY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357589AbiCYBd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D64BF511
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FB1661941
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C9EC340EC;
        Fri, 25 Mar 2022 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171914;
        bh=ooLs1wKD/DLc7udG8MHqgj6d+BTbcaw/xdwtmDgtmj4=;
        h=Date:To:From:Subject:From;
        b=XPSsIfIVlZHnQ7GIf6UGnBV2vbdEs3NvO8YVn+AuJRQmGszcjLMf25qQ3x9pH4ZeF
         zijhNGmKgY+3IyljZA34MqN4Hl0BLVEG7aQP6idFa4YPmSAWpgeuKZcjYOa0piD1wK
         2i+oqSDcig7VCzMSe7aCye/XH53UlS/wzKuSBnIU=
Date:   Thu, 24 Mar 2022 18:31:54 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        herbert.van.den.bergh@oracle.com, chris.mason@oracle.com,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch removed from -mm tree
Message-Id: <20220325013154.B3C9EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: fix potential imbalanced rlimit ucounts adjustment
has been removed from the -mm tree.  Its filename was
     mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mlock: fix potential imbalanced rlimit ucounts adjustment

user_shm_lock forgets to set allowed to 0 when get_ucounts fails. So
the later user_shm_unlock might do the extra dec_rlimit_ucounts. Fix
this by resetting allowed to 0.

Link: https://lkml.kernel.org/r/20220310132417.41189-1-linmiaohe@huawei.com
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mlock.c~mm-mlock-fix-potential-imbalanced-rlimit-ucounts-adjustment
+++ a/mm/mlock.c
@@ -839,6 +839,7 @@ int user_shm_lock(size_t size, struct uc
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

