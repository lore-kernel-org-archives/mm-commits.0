Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0C6C197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 21:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjKPVxo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 16:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjKPVxn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 16:53:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74188EA
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 13:53:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB805C433C7;
        Thu, 16 Nov 2023 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700171620;
        bh=gZIS2++Mihq2OKD0uX5ucZQJWO3oat6NHYxSWSvs7kY=;
        h=Date:To:From:Subject:From;
        b=ELjqBoluThzKXHY4cKnntzlQ3zltT1io0FeQRPbce2lHiyIbytCCnWeWtw/tGjw6h
         M9f5XuuYltrI9rKxJenh3yPfvNIH2KGqOryGwGtt3tgvtTdGftfzA2We0ZLnZ68TCe
         /0Yhu+wtmsRnmnYuctdWse5tKvjPYYjVUZEm/+Ds=
Date:   Thu, 16 Nov 2023 13:53:38 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        lukas.bulwahn@gmail.com, joe@perches.com, dwaipayanray1@gmail.com,
        cixi.geng1@unisoc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-judgment-condition-for-kconfig-help-test.patch added to mm-nonmm-unstable branch
Message-Id: <20231116215339.EB805C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add judgment condition for Kconfig help test
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-judgment-condition-for-kconfig-help-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-judgment-condition-for-kconfig-help-test.patch

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

checkpatch-add-judgment-condition-for-kconfig-help-test.patch

