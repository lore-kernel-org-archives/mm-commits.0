Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E995C43334
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 20:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiF0UCR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 16:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238576AbiF0UCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 16:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD631C91C
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 13:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384D7616CC
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 20:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF1C34115;
        Mon, 27 Jun 2022 20:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656360135;
        bh=9A8TQnGXYbw8UrBekmao9kGhzCsS2ARfMAeeZZfWjpY=;
        h=Date:To:From:Subject:From;
        b=ROTQTt5t+glmyXtNTGfHEPeQ6UnnDWOBPQLb7u9+979rTpthw75sqhANRgy0Zut+x
         jDcooBQegxgzRhPHyNt1WhyWj+jbQ5q8LtwCfS0kAKYgkQjo64uuUpaBt9T0F3CSN0
         U8FUqOF+GNjzPMHLrQDaZ3UPly+UQ3c60anNrkCA=
Date:   Mon, 27 Jun 2022 13:02:14 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-make-lz4_decompress_safe_forceextdict-static.patch added to mm-nonmm-unstable branch
Message-Id: <20220627200215.8BEF1C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: make LZ4_decompress_safe_forceExtDict() static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-make-lz4_decompress_safe_forceextdict-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-make-lz4_decompress_safe_forceextdict-static.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib: make LZ4_decompress_safe_forceExtDict() static
Date: Mon, 27 Jun 2022 11:02:45 +0800

LZ4_decompress_safe_forceExtDict() is only used in
lib/lz4/lz4_decompress.c, make it static to fix the build warning about
"no previous prototype" [1].

[1] https://lore.kernel.org/lkml/202206260948.akgsho1q-lkp@intel.com/

Link: https://lkml.kernel.org/r/1656298965-8698-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/lz4/lz4_decompress.c~lib-make-lz4_decompress_safe_forceextdict-static
+++ a/lib/lz4/lz4_decompress.c
@@ -507,9 +507,9 @@ static int LZ4_decompress_safe_withSmall
 				      (BYTE *)dest - prefixSize, NULL, 0);
 }
 
-int LZ4_decompress_safe_forceExtDict(const char *source, char *dest,
-				     int compressedSize, int maxOutputSize,
-				     const void *dictStart, size_t dictSize)
+static int LZ4_decompress_safe_forceExtDict(const char *source, char *dest,
+					    int compressedSize, int maxOutputSize,
+					    const void *dictStart, size_t dictSize)
 {
 	return LZ4_decompress_generic(source, dest,
 				      compressedSize, maxOutputSize,
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

lib-make-lz4_decompress_safe_forceextdict-static.patch

