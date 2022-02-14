Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05958C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 21:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiBNVUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:20:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiBNVUm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 16:20:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C83A66EF
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 13:20:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F025611EF
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 21:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0D0C340E9;
        Mon, 14 Feb 2022 21:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644873632;
        bh=9z3yktAS1HyA9mQnuZU9USiZnwZ5PDScMCA27WDtmYI=;
        h=Date:To:From:Subject:From;
        b=DlMkwjqjFfA4BOIEcawmKcTRMMl1ffvvjDM9ZT9o22DbsfQn0L05ROZ/2Bi55M7Fa
         tFQWHTR5B8VIsfSiX9vtrNFDMC6jbffShqZ4V45Do/llxn83msKTCAb0a+yTEeT7gB
         FLpDDzZMmSZULVwhaW7jhpsjbNtQ9Gg+SWXxCn24=
Date:   Mon, 14 Feb 2022 13:20:31 -0800
To:     mm-commits@vger.kernel.org, schwab@linux-m68k.org,
        hirofumi@mail.parknet.co.jp, David.Laight@aculab.com,
        deller@gmx.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-use-pointer-to-simple-type-in-put_user.patch added to -mm tree
Message-Id: <20220214212031.DC0D0C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fat: use pointer to simple type in put_user()
has been added to the -mm tree.  Its filename is
     fat-use-pointer-to-simple-type-in-put_user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fat-use-pointer-to-simple-type-in-put_user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fat-use-pointer-to-simple-type-in-put_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-use-pointer-to-simple-type-in-put_user.patch

