Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F591C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 20:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbiDHULR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 16:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239413AbiDHULP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 16:11:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C12354286;
        Fri,  8 Apr 2022 13:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F6661E43;
        Fri,  8 Apr 2022 20:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9E9C385A3;
        Fri,  8 Apr 2022 20:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649448548;
        bh=jK5P+S6TBH7YF6w0YeGEccKrveX9Q4CJhIMJxTVHP90=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=D/XdaMbmMx64cu2oQEP24nMEBtaFtmZ3s/GL8tOuuyCDohC13dt16JJDbli9OhYMD
         wOISBiKU/I7QQsy2/fKUKl8TThyurnLdeRtNjchDLEM6+hdl8lcHT4FWGH7qgzqFhi
         YJXVgeoYbZChXYf6JXdFtrreg788lYzTk8FsHxno=
Date:   Fri, 08 Apr 2022 13:09:07 -0700
To:     stable@vger.kernel.org, mhocko@suse.com, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220408130819.a89195e527ce58dfbe0700b9@linux-foundation.org>
Subject: [patch 6/9] mm/mempolicy: fix mpol_new leak in shared_policy_replace
Message-Id: <20220408200908.9C9E9C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: fix mpol_new leak in shared_policy_replace

If mpol_new is allocated but not used in restart loop, mpol_new will be
freed via mpol_put before returning to the caller.  But refcnt is not
initialized yet, so mpol_put could not do the right things and might leak
the unused mpol_new.  This would happen if mempolicy was updated on the
shared shmem file while the sp->lock has been dropped during the memory
allocation.

This issue could be triggered easily with the below code snippet if there
are many processes doing the below work at the same time:

  shmid = shmget((key_t)5566, 1024 * PAGE_SIZE, 0666|IPC_CREAT);
  shm = shmat(shmid, 0, 0);
  loop many times {
    mbind(shm, 1024 * PAGE_SIZE, MPOL_LOCAL, mask, maxnode, 0);
    mbind(shm + 128 * PAGE_SIZE, 128 * PAGE_SIZE, MPOL_DEFAULT, mask,
          maxnode, 0);
  }

Link: https://lkml.kernel.org/r/20220329111416.27954-1-linmiaohe@huawei.com
Fixes: 42288fe366c4 ("mm: mempolicy: Convert shared_policy mutex to spinlock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[3.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-fix-mpol_new-leak-in-shared_policy_replace
+++ a/mm/mempolicy.c
@@ -2733,6 +2733,7 @@ alloc_new:
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 
_
