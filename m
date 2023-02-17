Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C9C636CC
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 02:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBQCRj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 21:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBQCRj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 21:17:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E24FC92
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 18:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E203E61203
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 02:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463C6C433D2;
        Fri, 17 Feb 2023 02:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676600257;
        bh=ibY1g7978rDDMxYD2U1Ps6uedNuB3SHSj5xpQ9of4dw=;
        h=Date:To:From:Subject:From;
        b=P90MMNbYp/zjX07UnyCt2ZcHao4hMN88X5mRoxbuUIftaUTpGg991ppmafmSQQkIv
         meyeBoJ10WTJDaElRzESsxPS2MIbxmXu5K5ESF9vtYrtbnKnlHjbtHAFI8q83yU/Fy
         i+VEC8+kstcIXxPOjsuImFNS+t/+PKq65p9D/Og8=
Date:   Thu, 16 Feb 2023 18:17:36 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch removed from -mm tree
Message-Id: <20230217021737.463C6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch

This patch was dropped because it was folded into lib-stackdepot-mm-rename-stack_depot_want_early_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
Date: Fri Feb 10 03:13:49 PM PST 2023

update mm/kmemleak.c

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmemleak.c~lib-stackdepot-mm-rename-stack_depot_want_early_init-fix
+++ a/mm/kmemleak.c
@@ -2071,7 +2071,7 @@ static int __init kmemleak_boot_config(c
 		kmemleak_disable();
 	else if (strcmp(str, "on") == 0) {
 		kmemleak_skip_disable = 1;
-		stack_depot_want_early_init();
+		stack_depot_request_early_init();
 	}
 	else
 		return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-mm-rename-stack_depot_want_early_init.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch
mm-change-to-return-bool-for-isolate_movable_page-fix.patch
include-linux-migrateh-remove-unneeded-externs.patch

