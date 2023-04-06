Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78432C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjDFBHQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbjDFBHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:07:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD567687;
        Wed,  5 Apr 2023 18:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A85D6429A;
        Thu,  6 Apr 2023 01:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A01C433EF;
        Thu,  6 Apr 2023 01:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743218;
        bh=yUd5TYNM1NcN+hpWWCGXcbwFZZ4+bjsb1t//cGzfCYs=;
        h=Date:To:From:Subject:From;
        b=YHQT5xT1JQseONHPhy1QfOmLBWeIkfEZJqvd1Wc3hJ/9k692+ZgIxFeSRC5JgAKFe
         2je1gClfEe5CC1+tpm7jLfFBCsvtT0SQHqxRLP1tIYAaSWteCcDAqceETTMd+uICYN
         LOuxbDtefbTWSH9IDWyt9M1GDvUAIHm8zdve+54I=
Date:   Wed, 05 Apr 2023 18:06:57 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zsmalloc-document-freeable-stats.patch removed from -mm tree
Message-Id: <20230406010657.F1A01C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: document freeable stats
has been removed from the -mm tree.  Its filename was
     zsmalloc-document-freeable-stats.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: document freeable stats
Date: Sat, 25 Mar 2023 11:46:31 +0900

When freeable class stat was added to classes file (back in 2016) we
forgot to update zsmalloc documentation.  Fix that.

Link: https://lkml.kernel.org/r/20230325024631.2817153-3-senozhatsky@chromium.org
Fixes: 1120ed548394 ("mm/zsmalloc: add `freeable' column to pool stat")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/zsmalloc.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/zsmalloc.rst~zsmalloc-document-freeable-stats
+++ a/Documentation/mm/zsmalloc.rst
@@ -83,6 +83,8 @@ pages_used
 	the number of pages allocated for the class
 pages_per_zspage
 	the number of 0-order pages to make a zspage
+freeable
+	the approximate number of pages class compaction can free
 
 Each zspage maintains inuse counter which keeps track of the number of
 objects stored in the zspage.  The inuse counter determines the zspage's
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


