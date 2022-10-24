Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2A6C67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiJXWUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiJXWUR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B74419C20
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEC0E61589
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7CBC433D6;
        Mon, 24 Oct 2022 20:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643743;
        bh=0+ujYuZy9FUyLDFu0seuKAMiCcA26WEPIG+l+9VQgT4=;
        h=Date:To:From:Subject:From;
        b=xTS3hAnKwK8NbuBDAd790Q1f/2l6kVwac1VHxzQQ6z412bOuWlGaAg9ojwfzbTrYW
         JAB7ogZaV2+S86EU9vrAMAGdotawPqh8KxKElNnpxodh94DuUJUldTR0HoDIJKvRf3
         5IyYy143cilZCYcV0RBl3fPyouboPoZiKBtE/wA8=
Date:   Mon, 24 Oct 2022 13:35:42 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch added to mm-unstable branch
Message-Id: <20221024203543.3C7CBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: break out of loop when found perfect zspage order
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

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
Subject: zsmalloc: break out of loop when found perfect zspage order
Date: Tue, 25 Oct 2022 01:12:12 +0900

If we found zspage configuration that gives us perfect 100% used
percentage (zero wasted space) then there is no point it trying any other
configuration

Link: https://lkml.kernel.org/r/20221024161213.3221725-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-break-out-of-loop-when-found-perfect-zspage-order
+++ a/mm/zsmalloc.c
@@ -790,6 +790,9 @@ static int get_pages_per_zspage(struct z
 			max_usedpc = usedpc;
 			max_usedpc_order = i;
 		}
+
+		if (usedpc == 100)
+			break;
 	}
 
 	return max_usedpc_order;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch
zram-add-pool_page_order-device-attribute.patch
documentation-document-zram-pool_page_order-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch
zsmalloc-make-sure-we-select-best-zspage-size.patch

