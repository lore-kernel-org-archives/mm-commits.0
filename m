Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF28C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E918220867
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgL2XFX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgL2XFX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:05:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F92A20867;
        Tue, 29 Dec 2020 23:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283082;
        bh=7N4E1bFPuYkkACwNHnxkMerlZppYlpE4KjKnRa/gL7Q=;
        h=Date:From:To:Subject:From;
        b=tRadKwFyJfFjSrZrAn91LaZHSSeSjCgo4d/6Ng9LifotUBrvXOzyLd96MEHm7nbwF
         H5kwCEHVH1N1LcIQb6aPH9V6FPxldBy3Kn/1RBuNF/ypllzbw50XP1WiwRECrnIybq
         IwDLQAUQEDLmpf/Khr+LhXJ93JXP0DowtSGjVYi4=
Date:   Tue, 29 Dec 2020 15:04:41 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zaslonko@linux.ibm.com,
        sfr@canb.auug.org.au, lkp@intel.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, rdunlap@infradead.org
Subject:  [folded-merged]
 zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch
 removed from -mm tree
Message-ID: <20201229230441.a-Ucn%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: dfltcc: remove dfltcc_syms.o from Makefile
has been removed from the -mm tree.  Its filename was
     zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch

This patch was dropped because it was folded into zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/zlib: dfltcc: remove dfltcc_syms.o from Makefile

Oops, missed removing this deleted file from the Makefile.

make[3]: *** No rule to make target 'lib/zlib_dfltcc/dfltcc_syms.o', needed by 'lib/zlib_dfltcc/built-in.a'.

Link: https://lkml.kernel.org/r/20201227171837.15492-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Zaslonko Mikhail <zaslonko@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/zlib_dfltcc/Makefile~zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix
+++ a/lib/zlib_dfltcc/Makefile
@@ -8,4 +8,4 @@
 
 obj-$(CONFIG_ZLIB_DFLTCC) += zlib_dfltcc.o
 
-zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o dfltcc_syms.o
+zlib_dfltcc-objs := dfltcc.o dfltcc_deflate.o dfltcc_inflate.o
_

Patches currently in -mm which might be from rdunlap@infradead.org are

local64h-make-asm-local64h-mandatory.patch
zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
lib-linear_ranges-fix-repeated-words-one-typo.patch

