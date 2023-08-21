Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F9AEE49B1
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjHUUmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbjHUUlK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D1E40
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1E0461840
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5261DC433C7;
        Mon, 21 Aug 2023 20:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650446;
        bh=xIxJU/+dttuINZ819WS2SjUkZ6CxHHN98dTuPw/JNsQ=;
        h=Date:To:From:Subject:From;
        b=OgsGvQgc9ly4iWdKRI5QXibCjiBMhjKxsQNwV82VyUMWaDvDTP8CY7/Ps1ZjVGtUY
         0UeCrn5rIongKDCv6VzSr3kwE3Q0KrWKn+HDoTGLTTsDh5yplvtNsu9iwnwxq7Rlqx
         MXoiUUyCAWT1o+PC5vPvDJsE/YPt1Ojtn7B+p48Q=
Date:   Mon, 21 Aug 2023 13:40:45 -0700
To:     mm-commits@vger.kernel.org, alexjlzheng@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-remove-redundant-checks-for-root-memcg.patch removed from -mm tree
Message-Id: <20230821204046.5261DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: remove redundant checks for root memcg
has been removed from the -mm tree.  Its filename was
     writeback-remove-redundant-checks-for-root-memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: writeback: remove redundant checks for root memcg
Date: Tue, 8 Aug 2023 16:44:32 +0800

The check for root memcg will be done in wb_get_lookup(), so remove the
redundant one to simplify the code.

Link: https://lkml.kernel.org/r/20230808084431.1632934-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/backing-dev.c~writeback-remove-redundant-checks-for-root-memcg
+++ a/mm/backing-dev.c
@@ -732,9 +732,6 @@ struct bdi_writeback *wb_get_create(stru
 
 	might_alloc(gfp);
 
-	if (!memcg_css->parent)
-		return &bdi->wb;
-
 	do {
 		wb = wb_get_lookup(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are


