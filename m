Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617E4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiANWFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiANWFN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6300FB825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDB2C36AE5;
        Fri, 14 Jan 2022 22:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197911;
        bh=/twb55yQS27uFy5si8zT+X4JSRlJUwALW3K1cG2Y3Jo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pEtNffu4lJWbtlZK1niuqiYA4dclWY47QVesHdOW+2PTUxm4nhqOjzQ83Ruh9tA/V
         zDHDciHRQymnMTf6+PdhpmzxvT0kErbotnK+D1Px8IBC+Uy0QCZnGYMckE0aZiNnwg
         PiDMBVBQvd5OVWjL0jMYaLRzQi6Zup7r27NLStDI=
Date:   Fri, 14 Jan 2022 14:05:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chi.minghao@zte.com.cn,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        pankaj.gupta@ionos.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, zealci@zte.com.cm
Subject:  [patch 042/146] mm/truncate.c: remove unneeded variable
Message-ID: <20220114220510.-gWU9LZq3%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
