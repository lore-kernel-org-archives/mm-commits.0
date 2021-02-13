Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B3BC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729C564E3C
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBMExX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhBMExW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB5864E38;
        Sat, 13 Feb 2021 04:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191962;
        bh=Db00HAQF1Jkl1fQ5S7H2xpREDJoUTBpler2IsLSq0gU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YXfQSaLllag66YJbmQ6IdH3Ic9K55g09OobQi+KP1YyzKaZK1T+Cgf8WHHJSfJitC
         F1vL63/myXKOzQCTGvFH2iPPeaSbS7u8DpnjSqjhg/hapgfrQZGZ0Fydnc8Juj60V3
         YokXvt4YaA/CVrFevDUHTV1dZPvKGMFnPtoUFuKU=
Date:   Fri, 12 Feb 2021 20:52:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org, linux-mm@kvack.org,
        lkp@intel.com, mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        torvalds@linux-foundation.org, ysato@users.osdn.me
Subject:  [patch 2/6] scripts/recordmcount.pl: support big endian
 for ARCH sh
Message-ID: <20210213045241.tECE_IEky%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
