Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F1CC433DB
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25C5A22A84
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgL0WBy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Dec 2020 17:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgL0WBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Dec 2020 17:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B981522A84;
        Sun, 27 Dec 2020 22:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609106473;
        bh=qhJ9yBlYS38O182J3b5BxQYiGfa4suPnO3t3Je+lFvM=;
        h=Date:From:To:Subject:From;
        b=lshoLHzfQEdQ/zPk3FzjpVs6AFytbNAuciAsMtxkyDeZD6oSkX7azGkeXQUnvXbVO
         LLzbWA8JscT4QO42Zfa5pcmrifUGmGAqP74RNKHjiKME7SQweV7OFcxckLWZ062YZb
         OOYHSXBrxzPoBigvbHJK+kwywtKWjaXQqMDep6Kw=
Date:   Sun, 27 Dec 2020 14:01:11 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zaslonko@linux.ibm.com,
        sfr@canb.auug.org.au, lkp@intel.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, rdunlap@infradead.org
Subject:  +
 zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch
 added to -mm tree
Message-ID: <20201227220111.FmFBa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: dfltcc: remove dfltcc_syms.o from Makefile
has been added to the -mm tree.  Its filename is
     zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc.patch
zlib-move-export_symbol-and-module_license-out-of-dfltcc_symsc-fix.patch
mm-zswap-clean-up-confusing-comment.patch
lib-linear_ranges-fix-repeated-words-one-typo.patch

