Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C9EC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354747AbiCYBeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357562AbiCYBdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7A2BF036
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB1F2B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628BFC340ED;
        Fri, 25 Mar 2022 01:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171906;
        bh=AtEhgRMOYa4BBAV3Qwoa/n2uC+kY41YibY9TTfakIjM=;
        h=Date:To:From:Subject:From;
        b=SHiP4CCIqdUjxjk02SAUDz9trvm0o5HOaFGuy0hcEJsFQc3MhC0+zNHrsfztoupm7
         CaqVZrHrjJQn1DEdUdIkBsaQqV5I6aQTIDMbK65JCFKxVv0Fy+KC+3T6ZNgLUfMlLt
         d1j7a2GrIY3UAnT6xsxHGcbCH0hAIEhHdZtJCQVI=
Date:   Thu, 24 Mar 2022 18:31:45 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch removed from -mm tree
Message-Id: <20220325013146.628BFC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: remove unnecessary PageTransTail check
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: remove unnecessary PageTransTail check

When we reach here, we're guaranteed to have non-compound page as thp is
already splited.  Remove this unnecessary PageTransTail check.

Link: https://lkml.kernel.org/r/20220218090118.1105-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failurec-remove-unnecessary-pagetranstail-check
+++ a/mm/memory-failure.c
@@ -1844,7 +1844,7 @@ try_again:
 	 * page_lock. We need wait writeback completion for this page or it
 	 * may trigger vfs BUG while evict inode.
 	 */
-	if (!PageTransTail(p) && !PageLRU(p) && !PageWriteback(p))
+	if (!PageLRU(p) && !PageWriteback(p))
 		goto identify_page_state;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

