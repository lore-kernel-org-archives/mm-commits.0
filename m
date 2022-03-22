Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE01C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiCVVqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236369AbiCVVq2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D985F8D0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC869B81DBA
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65988C340EC;
        Tue, 22 Mar 2022 21:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985497;
        bh=xpb+C+JgfC5R4O8FqnsK5U6W1BFO1h90Du/JBYTules=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=RiFbCSUvOoTtpC/WBF8XprLOMs01Q5mjp8Rlx7EuMaXF2/rTq+WJaAHAT4pxbHSJA
         fqinLT2WCaMWNkx2E26MQFTE3qNaDVPtl7ykLhmwQPGrXbayUcS15yqA82TIhMba2j
         b9WWFRaYNnfMutq/K0F0dYXU9Rv9PJPQ9BKdJQwM=
Date:   Tue, 22 Mar 2022 14:44:56 -0700
To:     hughd@google.com, herbert.van.den.bergh@oracle.com,
        chris.mason@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 127/227] mm/mlock: fix potential imbalanced rlimit ucounts adjustment
Message-Id: <20220322214457.65988C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
