Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECC6C6FD20
	for <mm-commits@archiver.kernel.org>; Sat, 25 Mar 2023 19:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjCYTxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Mar 2023 15:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCYTxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Mar 2023 15:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C965561AB
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 12:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EEA60C99
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 19:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F8DC4339B;
        Sat, 25 Mar 2023 19:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679774002;
        bh=4Pk3QL8nKffBUN4NhkQ7Hgp6I0ImosibxxQbjkrUCRw=;
        h=Date:To:From:Subject:From;
        b=wZ5XlvkjeSeffNy0TRXrJrlKEFZGu8t6SOeeMyrjqEvYQYZw5UF3+nmOmfc4J4/NC
         dn4/lKdxqEyGw0JVTx+V4eArh6FlCAylHPm0CrP5DaiDqkvV89vxJTcqkXn8lcsQ8A
         2+nwmQqCrbxVWj46QF8Vu0FO35iPQnue/VbHSrP4=
Date:   Sat, 25 Mar 2023 12:53:22 -0700
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-document-freeable-stats.patch added to mm-unstable branch
Message-Id: <20230325195322.B4F8DC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: document freeable stats
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-document-freeable-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-document-freeable-stats.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: document freeable stats
Date: Sat, 25 Mar 2023 11:46:31 +0900

When freeable class stat was added to classes file (back in 2016) we
forgot to update zsmalloc documentation.  Fix that.

Link: https://lkml.kernel.org/r/20230325024631.2817153-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
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

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-show-per-fullness-group-class-stats.patch
zsmalloc-document-new-fullness-grouping.patch
zsmalloc-document-freeable-stats.patch

