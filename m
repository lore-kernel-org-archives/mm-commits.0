Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8307CC54EBE
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 00:56:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjAJA4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 19:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjAJA4c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 19:56:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8AB3BE8F
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 16:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6482FB810C5
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 00:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BEEC433EF;
        Tue, 10 Jan 2023 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312188;
        bh=wm0iPTE1/64QD5NIqFjOOM7CjdAYYs7dWwIqayTR6d8=;
        h=Date:To:From:Subject:From;
        b=I5LTAg0+HknBlb/a0uCz5pEOBqIla+1khaWZWKMBOsOUUpqVX/V5FjqM/jyvNxCsv
         slyNlx6zFb7MpyRUU8mfCKRHwmxNvJI9O1VXWATVnJwdy1rFXcIg/pvmGApb2kuHYR
         B/bdEPCC4kpCYu6Sumep5fxI8kvFHllkFMz9qCqQ=
Date:   Mon, 09 Jan 2023 16:56:27 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-set-default-zspage-chain-size-to-8.patch added to mm-unstable branch
Message-Id: <20230110005628.01BEEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: set default zspage chain size to 8
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-set-default-zspage-chain-size-to-8.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-set-default-zspage-chain-size-to-8.patch

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
Subject: zsmalloc: set default zspage chain size to 8
Date: Mon, 9 Jan 2023 12:38:38 +0900

This changes key characteristics (pages per-zspage and objects per-zspage)
of a number of size classes which in results in different pool
configuration.  With zspage chain size of 8 we have more size clases
clusters (123) and higher huge size class watermark (3632 bytes).

Please read zsmalloc documentation for more details.

Link: https://lkml.kernel.org/r/20230109033838.2779902-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~zsmalloc-set-default-zspage-chain-size-to-8
+++ a/mm/Kconfig
@@ -193,7 +193,7 @@ config ZSMALLOC_STAT
 
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
-	default 4
+	default 8
 	range 1 16
 	depends on ZSMALLOC
 	help
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

