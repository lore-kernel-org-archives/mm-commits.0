Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32ABDC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjDRXmW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDRXlR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C68CC66A
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A007630E9
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2410C433EF;
        Tue, 18 Apr 2023 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861226;
        bh=UUqXtffVNupm/zEw/7r7jF7GDfVJqwdAixLy5CnFKBk=;
        h=Date:To:From:Subject:From;
        b=kCc8yRk7b9+kUnlpThcM6LtpRqWcCQhPj84ZD/n339hnImBa0xeS123NQYm9xp+jr
         ippNtQ1PbGA0xPICyIFkgFAWieJR+rp0LGzvaUh+eIyGtwrNBdFoshMHXFXdXA+bHI
         lgn9aPmS70a6Se/rbjF7iAWT0u7Tc9F4JA2ezQZs=
Date:   Tue, 18 Apr 2023 16:40:26 -0700
To:     mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, pvorel@suse.cz, masahiroy@kernel.org,
        kevin.brodsky@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] uapi-linux-consth-prefer-iso-friendly-__typeof__.patch removed from -mm tree
Message-Id: <20230418234026.B2410C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
has been removed from the -mm tree.  Its filename was
     uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
Date: Tue, 11 Apr 2023 10:27:47 +0100

typeof is (still) a GNU extension, which means that it cannot be used when
building ISO C (e.g.  -std=c99).  It should therefore be avoided in uapi
headers in favour of the ISO-friendly __typeof__.

Unfortunately this issue could not be detected by
CONFIG_UAPI_HEADER_TEST=y as the __ALIGN_KERNEL() macro is not expanded in
any uapi header.

This matters from a userspace perspective, not a kernel one. uapi
headers and their contents are expected to be usable in a variety of
situations, and in particular when building ISO C applications (with
-std=c99 or similar).

This particular problem can be reproduced by trying to use the
__ALIGN_KERNEL macro directly in application code, say:

#include <linux/const.h>

int align(int x, int a)
{
	return __KERNEL_ALIGN(x, a);
}
	
and trying to build that with -std=c99.	

Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@arm.com
Fixes: a79ff731a1b2 ("netfilter: xtables: make XT_ALIGN() usable in exported headers by exporting __ALIGN_KERNEL()")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reported-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
Tested-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/const.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/const.h~uapi-linux-consth-prefer-iso-friendly-__typeof__
+++ a/include/uapi/linux/const.h
@@ -28,7 +28,7 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
 #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


