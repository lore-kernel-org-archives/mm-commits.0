Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356D6FA3741
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJaW3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiJaW3U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:29:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2CE26F8
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5F62CE1898
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D647BC433B5;
        Mon, 31 Oct 2022 22:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667255343;
        bh=SUSIJrTsVPVGm1OUFffZZzzdzizYp0IDcIzL8bJm+5E=;
        h=Date:To:From:Subject:From;
        b=vb9tJPyutHDIx8Fdicr6hLdMu4Cwqcf2+LIkCEjRgjnepK0BCOtE+tF2ZAvBSkbWM
         CKPJYTB9fo05akx7x8Vu7VdFFKCloCxjK5ijFV2r9Yk3X6qHRrQEt1j3OlG2DbH2Cp
         XoRc2DqN1vaV0650b+XM9KhK7SQZ+iTheLdA71vw=
Date:   Mon, 31 Oct 2022 15:29:02 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch added to mm-unstable branch
Message-Id: <20221031222902.D647BC433B5@smtp.kernel.org>
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
Date: Mon, 31 Oct 2022 14:41:08 +0900

If we found zspage configuration that gives us perfect 100% used
percentage (zero wasted space) then there is no point it trying any other
configuration

Link: https://lkml.kernel.org/r/20221031054108.541190-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-break-out-of-loop-when-found-perfect-zspage-order
+++ a/mm/zsmalloc.c
@@ -859,6 +859,9 @@ static int get_pages_per_zspage(u32 clas
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
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

