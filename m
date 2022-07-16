Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA68C43334
	for <mm-commits@archiver.kernel.org>; Sat, 16 Jul 2022 23:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiGPXBo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 19:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiGPXBo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 19:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B669F1B79E
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 16:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 746A3B80D1E
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 23:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E235C34114;
        Sat, 16 Jul 2022 23:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658012500;
        bh=dV3SnFXTjLzyooGpCu/fYRUQBNF6yPD2Vml+yNoyF08=;
        h=Date:To:From:Subject:From;
        b=GvANCb2ocCH/nmGel+GHV6IN+GH2FizsNu87lOdWcaOS8p5RbQm8RgD7lUq15NBNG
         x8YovTAzciOqOIAXk1BJ1ZQqxIsAT4bDMe1ISO20KSG9p3Red1pu6UAviMM3thKVhe
         w+YtN9Y+CewklXp4Jm1nyJrJJJVbc3MAZVJZUjRg=
Date:   Sat, 16 Jul 2022 16:01:39 -0700
To:     mm-commits@vger.kernel.org, dave.rodgman@arm.com, corbet@lwn.net,
        yijiangshan@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch added to mm-nonmm-unstable branch
Message-Id: <20220716230140.0E235C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lzo/lzo1x_compress.c: replace ternary operator with min() and min_t()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch

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
From: Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: lib/lzo/lzo1x_compress.c: replace ternary operator with min() and min_t()
Date: Thu, 14 Jul 2022 09:54:41 +0800

Fix the following coccicheck warning:

lib/lzo/lzo1x_compress.c:54: WARNING opportunity for min().
lib/lzo/lzo1x_compress.c:329: WARNING opportunity for min().

min() and min_t() macro is defined in include/linux/minmax.h.  It avoids
multiple evaluations of the arguments when non-constant and performs
strict type-checking.

Link: https://lkml.kernel.org/r/20220714015441.1313036-1-13667453960@163.com
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: Dave Rodgman <dave.rodgman@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lzo/lzo1x_compress.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/lib/lzo/lzo1x_compress.c~lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t
+++ a/lib/lzo/lzo1x_compress.c
@@ -50,9 +50,7 @@ next:
 
 		if (dv == 0 && bitstream_version) {
 			const unsigned char *ir = ip + 4;
-			const unsigned char *limit = ip_end
-				< (ip + MAX_ZERO_RUN_LENGTH + 1)
-				? ip_end : ip + MAX_ZERO_RUN_LENGTH + 1;
+			const unsigned char *limit = min(ip_end, ip + MAX_ZERO_RUN_LENGTH + 1);
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && \
 	defined(LZO_FAST_64BIT_MEMORY_ACCESS)
 			u64 dv64;
@@ -326,7 +324,7 @@ static int lzogeneric1x_1_compress(const
 	data_start = op;
 
 	while (l > 20) {
-		size_t ll = l <= (m4_max_offset + 1) ? l : (m4_max_offset + 1);
+		size_t ll = min_t(size_t, l, m4_max_offset + 1);
 		uintptr_t ll_end = (uintptr_t) ip + ll;
 		if ((ll_end + ((t + ll) >> 5)) <= ll_end)
 			break;
_

Patches currently in -mm which might be from yijiangshan@kylinos.cn are

fs-ocfs2-fix-spelling-typo-in-comment.patch
lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch

