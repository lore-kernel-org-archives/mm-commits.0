Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED5DC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCE5C61872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhKKCs0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhKKCsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:48:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7421260F46;
        Thu, 11 Nov 2021 02:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598735;
        bh=uBNzARUl6LoOOdFwZFUKT2XWXPfKA4dEG9Gw1KN6Mco=;
        h=Date:From:To:Subject:From;
        b=LJdyu3hcOpeTh2RmiSlwRJES727HokPZX8rI0esyGCdEdjaMs3FQuWLR4iETs4WSy
         O/EvGaQr7YjMpNMQXYs+6KWFET9FgvyMxHifGt7VBRGmTxEGFr+BuibTjJvlsrGcSw
         7oF+9X9d+kv7+Zwf6XKqOxnS12HkksbrKaSRwsjo=
Date:   Wed, 10 Nov 2021 18:45:35 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        songkai01@inspur.com
Subject:  [merged]
 mm-vmscanc-fix-wunused-but-set-variable-warning.patch removed from -mm tree
Message-ID: <20211111024535.K0XdBrjC0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix -Wunused-but-set-variable warning
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fix-wunused-but-set-variable-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from songkai01@inspur.com are


