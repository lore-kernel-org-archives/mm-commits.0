Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31817C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A21961244
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhKEUpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhKEUpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6C361058;
        Fri,  5 Nov 2021 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144942;
        bh=jwJ8qn72re8tjT6QT5XHOWry11YP2w2kKC9FzKZOqp8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HqPYaWdyDG+C+B/8RyTo3Bs2P8mRqFZojHN6sgpfhFS/b07D6MnoZzD574hC1igty
         BTb5aCfvM0y0dhs9A/B0NxNgJhj+n7UZZmyGCN195ISmnbP6/EbpsQquFZ2YdsBYud
         gbvm6oVIsHcga5Vta2Xx+1dSLpggZ28OMd1PXL6w=
Date:   Fri, 05 Nov 2021 13:42:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songkai01@inspur.com, torvalds@linux-foundation.org
Subject:  [patch 148/262] mm/vmscan.c: fix
 -Wunused-but-set-variable warning
Message-ID: <20211105204222.LKDG_epUU%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kai Song <songkai01@inspur.com>
Subject: mm/vmscan.c: fix -Wunused-but-set-variable warning

We fix the following warning when building kernel with W=1:
mm/vmscan.c:1362:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]

Link: https://lkml.kernel.org/r/20210924181218.21165-1-songkai01@inspur.com
Signed-off-by: Kai Song <songkai01@inspur.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-wunused-but-set-variable-warning
+++ a/mm/vmscan.c
@@ -1337,7 +1337,6 @@ static unsigned int demote_page_list(str
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
-	int err;
 
 	if (list_empty(demote_pages))
 		return 0;
@@ -1346,7 +1345,7 @@ static unsigned int demote_page_list(str
 		return 0;
 
 	/* Demotion ignores all cpuset and mempolicy settings */
-	err = migrate_pages(demote_pages, alloc_demote_page, NULL,
+	migrate_pages(demote_pages, alloc_demote_page, NULL,
 			    target_nid, MIGRATE_ASYNC, MR_DEMOTION,
 			    &nr_succeeded);
 
_
