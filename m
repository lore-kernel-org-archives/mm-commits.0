Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624AFC3DA6B
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiH1VDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiH1VDh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0409831233
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32E5DB80B6E
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA26CC433D7;
        Sun, 28 Aug 2022 21:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720608;
        bh=HKSKyUjxFe/x7Yg5XXYSPkkJFXM2k2vMaMsTJQozhk8=;
        h=Date:To:From:Subject:From;
        b=fpYA1FkS/HuRdftfbblKh20OADmb5WGxogsxV7q1Q/oynkA3A8y92yub52CbwXtyv
         399Cn5yoYi9/7QdN8EdBmyUr1LkzNc5Mvuf+BXoahNphMHytrsgYqB7aq8KMl0jxOe
         4Hnl8Wk53Spdmv9oYmK+taSNCXS9w5rel7uAJEl4=
Date:   Sun, 28 Aug 2022 14:03:28 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch removed from -mm tree
Message-Id: <20220828210328.CA26CC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zsmalloc: do not attempt to free IS_ERR handle
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-do-not-attempt-to-free-is_err-handle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm/zsmalloc: do not attempt to free IS_ERR handle
Date: Tue, 16 Aug 2022 14:09:06 +0900

zsmalloc() now returns ERR_PTR values as handles, which zram accidentally
can pass to zs_free().  Another bad scenario is when zcomp_compress()
fails - handle has default -ENOMEM value, and zs_free() will try to free
that "pointer value".

Add the missing check and make sure that zs_free() bails out when
ERR_PTR() is passed to it.

Link: https://lkml.kernel.org/r/20220816050906.2583956-1-senozhatsky@chromium.org
Fixes: c7e6f17b52e9 ("zsmalloc: zs_malloc: return ERR_PTR on failure")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-do-not-attempt-to-free-is_err-handle
+++ a/mm/zsmalloc.c
@@ -1487,7 +1487,7 @@ void zs_free(struct zs_pool *pool, unsig
 	struct size_class *class;
 	enum fullness_group fullness;
 
-	if (unlikely(!handle))
+	if (IS_ERR_OR_NULL((void *)handle))
 		return;
 
 	/*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch

