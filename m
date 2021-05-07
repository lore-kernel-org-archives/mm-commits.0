Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5584DC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FBE613C8
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhEGBEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhEGBEW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 781C6613B5;
        Fri,  7 May 2021 01:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349403;
        bh=FKxeXA4LYsz+stlfkVBMO1xgwiKIXR/0apU5DzPteVM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=En5ymYPqUqWiGK7kaPm7tjNStwIVICJ2eGzG9o3PEQ2usoF9s6mxuhVa718qzgMzK
         TaaPNch8vMHG+SMWYztxO0cevS+tE7wneiuN5Z92AIaNaGk9qZu+NMfqa33QsuQp65
         8+0T02WMALzudsLZO8YdVs1TnTfulYnKXY7vRQV4=
Date:   Thu, 06 May 2021 18:03:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, dalias@libc.org,
        dennis@kernel.org, dsterba@suse.com, geert@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, jianpeng.ma@intel.com,
        joe@perches.com, jpoimboe@redhat.com, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com, sbrivio@redhat.com,
        torvalds@linux-foundation.org, wsa+renesas@sang-engineering.com,
        ysato@users.osdn.me, yury.norov@gmail.com
Subject:  [patch 25/91] MAINTAINERS: add entry for the bitmap API
Message-ID: <20210507010322.NQV7Z0ZfN%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>
Subject: MAINTAINERS: add entry for the bitmap API

Add myself as maintainer for bitmap API and Andy and Rasmus as reviewers.

Link: https://lkml.kernel.org/r/20210401003153.97325-13-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Sterba <dsterba@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefano Brivio <sbrivio@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-the-bitmap-api
+++ a/MAINTAINERS
@@ -3205,6 +3205,22 @@ F:	Documentation/filesystems/bfs.rst
 F:	fs/bfs/
 F:	include/uapi/linux/bfs_fs.h
 
+BITMAP API
+M:	Yury Norov <yury.norov@gmail.com>
+R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+R:	Rasmus Villemoes <linux@rasmusvillemoes.dk>
+S:	Maintained
+F:	include/asm-generic/bitops/find.h
+F:	include/linux/bitmap.h
+F:	lib/bitmap.c
+F:	lib/find_bit.c
+F:	lib/find_bit_benchmark.c
+F:	lib/test_bitmap.c
+F:	tools/include/asm-generic/bitops/find.h
+F:	tools/include/linux/bitmap.h
+F:	tools/lib/bitmap.c
+F:	tools/lib/find_bit.c
+
 BLINKM RGB LED DRIVER
 M:	Jan-Simon Moeller <jansimon.moeller@gmx.de>
 S:	Maintained
_
