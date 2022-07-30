Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C83C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiG3BNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiG3BNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744B4101E3
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEBCD61C3A
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D1C433B5;
        Sat, 30 Jul 2022 01:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143592;
        bh=+kcJE95LpCkKU/Fj71vzEx5DWTD5Y7nKbU1spFN40K0=;
        h=Date:To:From:Subject:From;
        b=oMH8xmoJpCdMIGB/fKS2EFj5c/usuu/oEC4zGSkzsaBFlhctO+CSKi3X74l8GkE+H
         KNzghalO6J3JzET3rkqeFOP76ycBwUABUFZIhsW52S3hFpfa56u+OjCN08jx/0S8ZA
         L/oBduqa9uVs3k8Pnf8+n9g7ukLMJmROLRSS30T0=
Date:   Fri, 29 Jul 2022 18:13:11 -0700
To:     mm-commits@vger.kernel.org, dave.rodgman@arm.com, corbet@lwn.net,
        yijiangshan@kylinos.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch removed from -mm tree
Message-Id: <20220730011312.3F9D1C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/lzo/lzo1x_compress.c: replace ternary operator with min() and min_t()
has been removed from the -mm tree.  Its filename was
     lib-lzo-lzo1x_compressc-replace-ternary-operator-with-min-and-min_t.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Dave Rodgman <dave.rodgman@arm.com>
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


