Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0A6C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiGRAch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiGRAcb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8FB13D2C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84E75B80DAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C378C3411E;
        Mon, 18 Jul 2022 00:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104348;
        bh=ZnsFq8mBEqIobS3UDBB/u+4VvfQn1bU3/HxtnlPip+0=;
        h=Date:To:From:Subject:From;
        b=u9tpCRIw/srja/w7q/lXFA0NFJqARVTTIc84oa2ioK8loqOtqbU0eD+8YGcs5Md5H
         90CBve4xDBYG3yD2lKVfc2U4NJe0BUuEUNTeNvIa48Jx/ZJ/iwdmvSXZwx76pEyuli
         xZcmL+OKoNKECbJdmJ5md4+Cwhb/vJ7Oizl6u5j0=
Date:   Sun, 17 Jul 2022 17:32:27 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-make-lz4_decompress_safe_forceextdict-static.patch removed from -mm tree
Message-Id: <20220718003228.3C378C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: make LZ4_decompress_safe_forceExtDict() static
has been removed from the -mm tree.  Its filename was
     lib-make-lz4_decompress_safe_forceextdict-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


