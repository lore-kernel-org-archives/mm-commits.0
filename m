Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57A5C38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjARBK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjARBJu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:09:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5A827482
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 17:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 77D48CE1AC7
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 01:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F146C433EF;
        Wed, 18 Jan 2023 01:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003859;
        bh=c2GjI1ylma6zpdNekApci2rqIdVXAdpWQ3MBDFW4f10=;
        h=Date:To:From:Subject:From;
        b=GfUnFNDwFmZ1Ov9690Ew2LsO270PzE7SGQqeiLTcdGN+ji7553w6rIv6vEvwVpTNA
         +nFNFsWZKnQ4iGIUwr6sIDVkMtfGdcytjlhsxb+Yke34QjwPplka3l5GQ6nERUmwkp
         uB6KmNj0SuRN2+5nMYLrzq+VgLXtmEtXCz5Bvo4Q=
Date:   Tue, 17 Jan 2023 17:04:18 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-set-default-zspage-chain-size-to-8.patch added to mm-unstable branch
Message-Id: <20230118010419.7F146C433EF@smtp.kernel.org>
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
Date: Wed, 18 Jan 2023 09:52:10 +0900

This changes key characteristics (pages per-zspage and objects per-zspage)
of a number of size classes which in results in different pool
configuration.  With zspage chain size of 8 we have more size clases
clusters (123) and higher huge size class watermark (3632 bytes).

Please read zsmalloc documentation for more details.

Link: https://lkml.kernel.org/r/20230118005210.2814763-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/Kconfig~zsmalloc-set-default-zspage-chain-size-to-8
+++ a/mm/Kconfig
@@ -193,7 +193,7 @@ config ZSMALLOC_STAT
 
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
-	default 4
+	default 8
 	range 4 16
 	depends on ZSMALLOC
 	help
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-correctly-handle-all-next_arg-cases.patch
zsmalloc-rework-zspage-chain-size-selection.patch
zsmalloc-skip-chain-size-calculation-for-pow_of_2-classes.patch
zsmalloc-make-zspage-chain-size-configurable.patch
zsmalloc-set-default-zspage-chain-size-to-8.patch

