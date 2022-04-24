Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831BDC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiDXUqV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiDXUqT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:46:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70D63526D
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCAB61325
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DC4C385A9;
        Sun, 24 Apr 2022 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650832996;
        bh=qq8vIB89Hx05Qg6kEEmFyv1sErMUUOUJklZjsFAPOTg=;
        h=Date:To:From:Subject:From;
        b=eINHF59BUlwl5l+GX4LrXnZCSW7S2keUCmcgJ6upOLZbjTWCpLKcMsdukJ6ae+cln
         y6F46C9FpAXT0pYDADz0H1aPeKCDV+ri0LM1NL11izothiCTVLVe3fWpILNJ2WcXXc
         3ikVV9qrC2iq/ztPRUOxFVkJ/rq9chd9m/Nxd+N4=
Date:   Sun, 24 Apr 2022 13:43:16 -0700
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au, kuba@kernel.org,
        geert@linux-m68k.org, davem@davemloft.net, arnd@arndb.de,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-unexport-csum_and_copy_fromto_user.patch added to -mm tree
Message-Id: <20220424204316.C3DC4C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: unexport csum_and_copy_{from,to}_user
has been added to the -mm tree.  Its filename is
     net-unexport-csum_and_copy_fromto_user.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/net-unexport-csum_and_copy_fromto_user.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/net-unexport-csum_and_copy_fromto_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: net: unexport csum_and_copy_{from,to}_user

csum_and_copy_from_user and csum_and_copy_to_user are exported by a few
architectures, but not actually used in modular code.  Drop the exports.

Link: https://lkml.kernel.org/r/20220421070440.1282704-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/csum_partial_copy.c   |    1 -
 arch/m68k/lib/checksum.c             |    2 --
 arch/powerpc/lib/checksum_wrappers.c |    2 --
 arch/x86/lib/csum-wrappers_64.c      |    2 --
 4 files changed, 7 deletions(-)

--- a/arch/alpha/lib/csum_partial_copy.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/alpha/lib/csum_partial_copy.c
@@ -353,7 +353,6 @@ csum_and_copy_from_user(const void __use
 		return 0;
 	return __csum_and_copy(src, dst, len);
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len)
--- a/arch/m68k/lib/checksum.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/m68k/lib/checksum.c
@@ -265,8 +265,6 @@ csum_and_copy_from_user(const void __use
 	return sum;
 }
 
-EXPORT_SYMBOL(csum_and_copy_from_user);
-
 
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
--- a/arch/powerpc/lib/checksum_wrappers.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/powerpc/lib/checksum_wrappers.c
@@ -24,7 +24,6 @@ __wsum csum_and_copy_from_user(const voi
 	user_read_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len)
 {
@@ -38,4 +37,3 @@ __wsum csum_and_copy_to_user(const void
 	user_write_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
--- a/arch/x86/lib/csum-wrappers_64.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/x86/lib/csum-wrappers_64.c
@@ -32,7 +32,6 @@ csum_and_copy_from_user(const void __use
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 /**
  * csum_and_copy_to_user - Copy and checksum to user space.
@@ -57,7 +56,6 @@ csum_and_copy_to_user(const void *src, v
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
 
 /**
  * csum_partial_copy_nocheck - Copy and checksum.
_

Patches currently in -mm which might be from hch@lst.de are

net-unexport-csum_and_copy_fromto_user.patch

