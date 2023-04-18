Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4238DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 00:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDRAnJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 20:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRAnI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 20:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABF440C8
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 17:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1FD626E8
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 00:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47421C433EF;
        Tue, 18 Apr 2023 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681778586;
        bh=V1I9tcAnIhNbXuDKyixrIpRCYLyzhwUvZ0daEDFXdKs=;
        h=Date:To:From:Subject:From;
        b=pFqu4vn8PD52+DuT2YGlDLuXOo2h4pY8L4wjLW8ygghAHOPxUcRrljnIxvc41MaE9
         VXM7V56uQf8uCCoMgplC7D56HlyCzVmtZB3JNqK5yXGmPNlix3Iqb2X+TZhKxcFlxf
         VWd5+9tub/+cpdnVlL6aOBqotpzrBSBgihnvVjTk=
Date:   Mon, 17 Apr 2023 17:43:05 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch added to mm-unstable branch
Message-Id: <20230418004306.47421C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: reset compaction source zspage pointer after putback_zspage()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch

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
Subject: zsmalloc: reset compaction source zspage pointer after putback_zspage()
Date: Mon, 17 Apr 2023 22:08:50 +0900

The current implementation of the compaction loop fails to set the source
zspage pointer to NULL in all cases, leading to a potential issue where
__zs_compact() could use a stale zspage pointer.  This pointer could even
point to a previously freed zspage, causing unexpected behavior in the
putback_zspage() and migrate_write_unlock() functions after returning from
the compaction loop.

Address the issue by ensuring that the source zspage pointer is always set
to NULL when it should be.

Link: https://lkml.kernel.org/r/20230417130850.1784777-1-senozhatsky@chromium.org
Fixes: 5a845e9f2d66 ("zsmalloc: rework compaction algorithm")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Yu Zhao <yuzhao@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage
+++ a/mm/zsmalloc.c
@@ -2239,8 +2239,8 @@ static unsigned long __zs_compact(struct
 		if (fg == ZS_INUSE_RATIO_0) {
 			free_zspage(pool, class, src_zspage);
 			pages_freed += class->pages_per_zspage;
-			src_zspage = NULL;
 		}
+		src_zspage = NULL;
 
 		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
 		    || spin_is_contended(&pool->lock)) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch

