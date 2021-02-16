Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98616C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A4B64E7D
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhBPUUY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Feb 2021 15:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBPUUX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Feb 2021 15:20:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83CF764E63;
        Tue, 16 Feb 2021 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613506782;
        bh=a/YZ14cy7RCBi+ZE/GsoHjOQBBJTPA7m4YyMMEpVAZw=;
        h=Date:From:To:Subject:From;
        b=x5vqMXHmxPraos418KMdLTkJQneFR2C7/wO1UfFWyAyAn8dBYIH0GSNTV63FDu4aX
         M3fc9J8jIxGgAP8eyUlaN6O8OsAZTuCKxQMBG6/ddoxAX5qfOS6R0dBOagqhNcYwrd
         zsgJO8hYvszUusCF6fRA6/rl0GvsCWgDTgrHX3rE=
Date:   Tue, 16 Feb 2021 12:19:42 -0800
From:   akpm@linux-foundation.org
To:     dalias@libc.org, lkp@intel.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com, ysato@users.osdn.me
Subject:  [merged]
 scripts-recordmcountpl-support-big-endian-for-arch-sh.patch removed from
 -mm tree
Message-ID: <20210216201942.h6U1WJfPq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/recordmcount.pl: support big endian for ARCH sh
has been removed from the -mm tree.  Its filename was
     scripts-recordmcountpl-support-big-endian-for-arch-sh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


