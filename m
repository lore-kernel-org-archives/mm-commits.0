Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333A8C54E76
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 00:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjKQAQk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 19:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjKQAQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 19:16:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE18B8
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 16:16:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E91DC433C8;
        Fri, 17 Nov 2023 00:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700180196;
        bh=9IncZXE15dr5q+JYC9omh89enxqLnuVUK88na3uuVuc=;
        h=Date:To:From:Subject:From;
        b=ZM6EGN/DbKpDhfwNR5Owh/0F1jE7vYLbZ5ypLwJ3/FB5B1P1zjpJ4CMTQH2ZXWvML
         nymknl4q+3SO93P+CBB7P7bTU4PFi7M6LWc4IcGZkPFeiCCtXrZ20b1tW27718dYRY
         p65ney7tMSR3Yp4yCO9wYI3Zrt+yVn8pD4nJFGMo=
Date:   Thu, 16 Nov 2023 16:16:35 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        cixi.geng1@unisoc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] checkpatch-add-judgment-condition-for-kconfig-help-test.patch removed from -mm tree
Message-Id: <20231117001636.1E91DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add judgment condition for Kconfig help test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-judgment-condition-for-kconfig-help-test.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Cixi Geng <cixi.geng1@unisoc.com>
Subject: checkpatch: add judgment condition for Kconfig help test
Date: Thu, 16 Nov 2023 23:39:04 +0800

has_help only counts the situation in which the patch file adds a help
line.  If the config was renamed and the description was modified,
has_help is zero because a "help" line was not added.

here is one case:
    the modify file: drivers/iio/adc/Kconfig  line(1047)

    -config SC27XX_ADC
    +config SPRD_ADC
     	tristate "Spreadtrum SC27xx series PMICs ADC"
     	depends on MFD_SC27XX_PMIC || COMPILE_TEST
    +	depends on ARCH_SPRD
     	help
    -	  Say yes here to build support for the integrated ADC inside the
    -	  Spreadtrum SC27xx series PMICs.
    +	  Say yes here to build support for the integrated ADC inside of the
    +	  Spreadtrum SC27xx and UMPxx series PMICs.

     	  This driver can also be built as a module. If so, the module
     	  will be called sc27xx_adc.

the checkpatch result:
    WARNING: please write a help paragraph that fully describes the config symbol
    #23: FILE: drivers/iio/adc/Kconfig:1050:
    +config SPRD_ADC
    +	tristate "Spreadtrum's ADC PMICs driver"
     	depends on MFD_SC27XX_PMIC || COMPILE_TEST
    +	depends on ARCH_SPRD
     	help
    +	  Say yes here to build support for the integrated ADC inside of the
    +	  Say yes here to build support for the integrated ADC inside of the
    +	  Say yes here to build support for the integrated ADC inside of the
    +	  Spreadtrum SC27xx and UMPxx series PMICs.

     	  This driver can also be built as a module. If so, the module
     	  will be called sc27xx_adc.

    total: 0 errors, 1 warnings, 17 lines checked

Link: https://lkml.kernel.org/r/20231116153904.15589-1-cixi.geng@linux.dev
Fixes: b8709bce9089 ("checkpatch: improve Kconfig help test")
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com> (reviewer:CHECKPATCH)
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-judgment-condition-for-kconfig-help-test
+++ a/scripts/checkpatch.pl
@@ -3616,7 +3616,7 @@ sub process {
 					$needs_help = 1;
 					next;
 				}
-				if ($f =~ /^\+\s*help\s*$/) {
+				if ($f =~ /^\+\s*help\s*$/ || $f =~ /^\s*help\s*$/) {
 					$has_help = 1;
 					next;
 				}
_

Patches currently in -mm which might be from cixi.geng1@unisoc.com are


