Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E7CC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377814AbiATVYk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377820AbiATVYi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F69C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 623B260DF9
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD95C340E0;
        Thu, 20 Jan 2022 21:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713877;
        bh=sBiCsIjQM5W3pq32nFPLFnlx28c1Wmw+PGoH2zbNbnM=;
        h=Date:From:To:Subject:From;
        b=kD60ptSLIkjd4qa9dotSzmSdxiACi7W7oTKao9blGoELK/TKBOqoIeie/6x9rv7Pu
         NthRnwGKinox5Qh9e8D/D7UGCSmQWphGkccZ4edD2xKJmfpChmZUIbwNwIo4TinlEW
         H4HyBXGOOGZt3MoW+KClT+9ohzKSbTi3OcGUY0m8=
Date:   Thu, 20 Jan 2022 13:24:37 -0800
From:   akpm@linux-foundation.org
To:     chi.minghao@zte.com.cn, david@redhat.com,
        mm-commits@vger.kernel.org, pankaj.gupta@ionos.com,
        songmuchun@bytedance.com, zealci@zte.com.cm
Subject:  [merged] mm-remove-unneeded-variable.patch removed from
 -mm tree
Message-ID: <20220120212437.XjHvXVFcq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate.c: remove unneeded variable
has been removed from the -mm tree.  Its filename was
     mm-remove-unneeded-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: chiminghao <chi.minghao@zte.com.cn>
Subject: mm/truncate.c: remove unneeded variable

Return value directly instead of taking this in another redundant
variable.

Link: https://lkml.kernel.org/r/20211207083222.401594-1-chi.minghao@zte.com.cn
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cm>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/truncate.c~mm-remove-unneeded-variable
+++ a/mm/truncate.c
@@ -205,7 +205,6 @@ static void truncate_cleanup_page(struct
 static int
 invalidate_complete_page(struct address_space *mapping, struct page *page)
 {
-	int ret;
 
 	if (page->mapping != mapping)
 		return 0;
@@ -213,9 +212,7 @@ invalidate_complete_page(struct address_
 	if (page_has_private(page) && !try_to_release_page(page, 0))
 		return 0;
 
-	ret = remove_mapping(mapping, page);
-
-	return ret;
+	return remove_mapping(mapping, page);
 }
 
 int truncate_inode_page(struct address_space *mapping, struct page *page)
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

