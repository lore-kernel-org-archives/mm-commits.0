Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC428C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D08764E4A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBKX7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhBKX7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 18:59:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB1DB64DDB;
        Thu, 11 Feb 2021 23:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613087947;
        bh=7f3PmEgbdVtZkmB+J71/HA2VHBhQ8NEJLabm3RS9CwA=;
        h=Date:From:To:Subject:From;
        b=IEBN5Z8kZQo2CuawdT3+AyRjWnlyjnn7QabSVyEYVNEWJkM18xRBG39LfLD2lb9aR
         S3OmXS+bVBZ5sKuFdnJ6RTm8KF904W57TPk4YE3F6tdMj99VdhSRW32LPg0cC0zpBa
         skZigt2TXk9qwYO3Sa6GiRZ4BaYgRqsKrri9fkag=
Date:   Thu, 11 Feb 2021 15:59:07 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, lkp@intel.com,
        dalias@libc.org, rong.a.chen@intel.com
Subject:  +
 scripts-recordmcountpl-support-big-endian-for-arch-sh.patch added to -mm tree
Message-ID: <20210211235907.5zAnT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/recordmcount.pl: support big endian for ARCH sh
has been added to the -mm tree.  Its filename is
     scripts-recordmcountpl-support-big-endian-for-arch-sh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-recordmcountpl-support-big-endian-for-arch-sh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-recordmcountpl-support-big-endian-for-arch-sh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rong Chen <rong.a.chen@intel.com>
Subject: scripts/recordmcount.pl: support big endian for ARCH sh

The kernel test robot reported the following issue:
    CC [M]  drivers/soc/litex/litex_soc_ctrl.o
  sh4-linux-objcopy: Unable to change endianness of input file(s)
  sh4-linux-ld: cannot find drivers/soc/litex/.tmp_gl_litex_soc_ctrl.o: No such file or directory
  sh4-linux-objcopy: 'drivers/soc/litex/.tmp_mx_litex_soc_ctrl.o': No such file

The problem is that the format of input file is elf32-shbig-linux,
but sh4-linux-objcopy wants to output a file which format is elf32-sh-linux:

  $ sh4-linux-objdump -d drivers/soc/litex/litex_soc_ctrl.o | grep format
  drivers/soc/litex/litex_soc_ctrl.o:     file format elf32-shbig-linux

Link: https://lkml.kernel.org/r/20210210150435.2171567-1-rong.a.chen@intel.com
Link: https://lore.kernel.org/linux-mm/202101261118.GbbYSlHu-lkp@intel.com
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/recordmcount.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/recordmcount.pl~scripts-recordmcountpl-support-big-endian-for-arch-sh
+++ a/scripts/recordmcount.pl
@@ -265,7 +265,11 @@ if ($arch eq "x86_64") {
 
     # force flags for this arch
     $ld .= " -m shlelf_linux";
-    $objcopy .= " -O elf32-sh-linux";
+    if ($endian eq "big") {
+        $objcopy .= " -O elf32-shbig-linux";
+    } else {
+        $objcopy .= " -O elf32-sh-linux";
+    }
 
 } elsif ($arch eq "powerpc") {
     my $ldemulation;
_

Patches currently in -mm which might be from rong.a.chen@intel.com are

scripts-recordmcountpl-support-big-endian-for-arch-sh.patch

