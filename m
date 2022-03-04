Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EC7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 03:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiCDDwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236557AbiCDDwN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 22:52:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF007664F
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 19:51:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08A9B61A28
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 03:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9A6C340F0;
        Fri,  4 Mar 2022 03:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646365885;
        bh=zSuNpWoXpf5ldGwzSLJatTloCWjJ+0PXHvWH4LVKIls=;
        h=Date:To:From:Subject:From;
        b=D+HMPF4CGH5HxMhPSehqYlHRRm6+D4rZGZhiHx7zT0OxcOmayo1/+yX2R8KkZNbDZ
         LrUNt4KLLewxIAO61wWEW+y+rK0T/E7Ygksr3sSb+yaSM5YXFMT/bQ21gErbMKDFoE
         lilfLDdr057+NraOy70SA3hjJ1mBLQZxT2y3iVqg=
Date:   Thu, 03 Mar 2022 19:51:24 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, guoren@kernel.org,
        feng.tang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch added to -mm tree
Message-Id: <20220304035125.5A9A6C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

0Day robots reported there is compiling issue for 'csky' ARCH
when CONFIG_DEBUG_FORCE_DATA_SECTION_ALIGNED is enabled [1]:

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:2277: Error: pcrel offset for branch to .LS000B too far (0x3c)


Which was discussed in [2].  And as there is no solution for csky yet, add
some dependency for this config to limit it to several ARCHs which have no
compiling issue so far.

[1]. https://lore.kernel.org/lkml/202202271612.W32UJAj2-lkp@intel.com/
[2]. https://www.spinics.net/lists/linux-kbuild/msg30298.html

Link: https://lkml.kernel.org/r/20220304021100.GN4548@shbuild999.sh.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-add-arch-dependency-for-function_align-option
+++ a/lib/Kconfig.debug
@@ -439,7 +439,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
_

Patches currently in -mm which might be from feng.tang@intel.com are

lib-kconfigdebug-add-arch-dependency-for-function_align-option.patch

