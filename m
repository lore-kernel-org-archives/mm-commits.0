Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AF0C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357506AbiCYBhX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357510AbiCYBf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E74137039
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F1160B3E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3717CC340EC;
        Fri, 25 Mar 2022 01:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172042;
        bh=3o6SsUZ4+TcENjWf2+mE0dhEneEG00LALfBJC5Ymtb4=;
        h=Date:To:From:Subject:From;
        b=YYRi6GOqdgn4QXBup2Sa6XlLMixwXTh13eZkaPfSH4gRrIOs87y/0ihoMSv3npXSr
         xI7mRObYZvG/YjR+8bIth/PrY+dgBMP3KNjfXAY+PBRvZvs2F8NU+n6ipOcRaNa2Xo
         UYf5q8ziOPfngaWeWsOSPyj9vWGwFKUNisIEOEdk=
Date:   Thu, 24 Mar 2022 18:34:01 -0700
To:     mm-commits@vger.kernel.org, schwab@linux-m68k.org,
        hirofumi@mail.parknet.co.jp, David.Laight@aculab.com,
        deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fat-use-pointer-to-simple-type-in-put_user.patch removed from -mm tree
Message-Id: <20220325013402.3717CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: use pointer to simple type in put_user()
has been removed from the -mm tree.  Its filename was
     fat-use-pointer-to-simple-type-in-put_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Helge Deller <deller@gmx.de>
Subject: fat: use pointer to simple type in put_user()

The put_user(val,ptr) macro wants a pointer to a simple type, but in
fat_ioctl_filldir() the d_name field references an "array of chars".  Be
more accurate and explicitly give the pointer to the first character of
the d_name[] array.

I noticed that issue while trying to optimize the parisc put_user() macro
and used an intermediate variable to store the pointer.  In that case I
got this error:

In file included from include/linux/uaccess.h:11,
                 from include/linux/compat.h:17,
                 from fs/fat/dir.c:18:
fs/fat/dir.c: In function `fat_ioctl_filldir':
fs/fat/dir.c:725:33: error: invalid initializer
  725 |                 if (put_user(0, d2->d_name)                     ||         \
      |                                 ^~
include/asm/uaccess.h:152:33: note: in definition of macro `__put_user'
  152 |         __typeof__(ptr) __ptr = ptr;                            \
      |                                 ^~~
fs/fat/dir.c:759:1: note: in expansion of macro `FAT_IOCTL_FILLDIR_FUNC'
  759 | FAT_IOCTL_FILLDIR_FUNC(fat_ioctl_filldir, __fat_dirent)

Andreas Schwab <schwab@linux-m68k.org> suggested to use
   __typeof__(&*(ptr)) __ptr = ptr;
instead. This works, but nevertheless it's probably reasonable to
fix the original caller too.

Link: https://lkml.kernel.org/r/Ygo+A9MREmC1H3kr@p100
Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: David Laight <David.Laight@aculab.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/dir.c~fat-use-pointer-to-simple-type-in-put_user
+++ a/fs/fat/dir.c
@@ -722,7 +722,7 @@ static int func(struct dir_context *ctx,
 		if (name_len >= sizeof(d1->d_name))			   \
 			name_len = sizeof(d1->d_name) - 1;		   \
 									   \
-		if (put_user(0, d2->d_name)			||	   \
+		if (put_user(0, &d2->d_name[0])			||	   \
 		    put_user(0, &d2->d_reclen)			||	   \
 		    copy_to_user(d1->d_name, name, name_len)	||	   \
 		    put_user(0, d1->d_name + name_len)		||	   \
_

Patches currently in -mm which might be from deller@gmx.de are


