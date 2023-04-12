Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220BCC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 00:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjDLAYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 20:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjDLAYU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 20:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2971A7
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 17:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B32D60FDE
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 00:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED32CC433EF;
        Wed, 12 Apr 2023 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681259057;
        bh=Eh8gqjQ2xiWpBsOu/Js+sPfuU94mTITPiZ7z8qMGW7k=;
        h=Date:To:From:Subject:From;
        b=YmySWEghIILVL1XtTnC/6vTcz98w+GWqNoa8dEuI8eU9U//iIIzGZ+R+XBI921UK0
         JMgxibvIlSdxF3BeuVTJfuZRONQXHZvdlV6rDQ93uvjzbblz6QE8gjHTFBCKuet55/
         LE4IqE7GFefEy4uhphr72+56D00AWX3JwZJtBb9Y=
Date:   Tue, 11 Apr 2023 17:24:16 -0700
To:     mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, pvorel@suse.cz, masahiroy@kernel.org,
        kevin.brodsky@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added to mm-nonmm-unstable branch
Message-Id: <20230412002416.ED32CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
Date: Tue, 11 Apr 2023 10:27:47 +0100

typeof is (still) a GNU extension, which means that it cannot be used when
building ISO C (e.g.  -std=c99).  It should therefore be avoided in uapi
headers in favour of the ISO-friendly __typeof__.

Unfortunately this issue could not be detected by
CONFIG_UAPI_HEADER_TEST=y as the __ALIGN_KERNEL() macro is not expanded in
any uapi header.

Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@arm.com
Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure they are self-contained")
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reported-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
Tested-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Cc: Masahiro Yamada <masahiroy@kernel.org>
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

uapi-linux-consth-prefer-iso-friendly-__typeof__.patch

