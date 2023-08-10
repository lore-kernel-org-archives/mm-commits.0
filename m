Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C119EC04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjHJRBt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbjHJRBs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518DA26A9
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCB0B65150
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398C4C433C7;
        Thu, 10 Aug 2023 17:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691686907;
        bh=fNId8plqzsa/ae4U4IrkdlBZPs2cKZea7HECIUXIrnc=;
        h=Date:To:From:Subject:From;
        b=ntIWpEyYtPVGOEwUk/nhcZGjjnhK+ON6bu78p21oi74DF/ezCRvMhXImx4aAmbHO9
         sq5xuAiCpE1lkpbiF5qwRgiLHbfaF4Ds6FVm495X1pzUhA9IF/EdMueS69GiqUm8gi
         MAZLV+vtHA6+oYzlSVccLNDFqhkcuXv7YQLupKrY=
Date:   Thu, 10 Aug 2023 10:01:46 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com, lkp@intel.com,
        elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + list_debug-introduce-config_debug_list_minimal-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230810170147.398C4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: list_debug-introduce-config_debug_list_minimal-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list_debug-introduce-config_debug_list_minimal-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list_debug-introduce-config_debug_list_minimal-fix.patch

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
From: Marco Elver <elver@google.com>
Subject: list_debug-introduce-config_debug_list_minimal-fix
Date: Wed, 9 Aug 2023 13:15:37 +0200

silence a warning

Link: https://lkml.kernel.org/r/ZNN1WdZ5J/e5OPAt@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
  Closes: https://lore.kernel.org/oe-kbuild-all/202308091820.0dPY7D6f-lkp@intel.com/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler_types.h~list_debug-introduce-config_debug_list_minimal-fix
+++ a/include/linux/compiler_types.h
@@ -128,7 +128,7 @@ static inline void __chk_io_ptr(const vo
  *
  * clang: https://clang.llvm.org/docs/AttributeReference.html#preserve-most
  */
-#if __has_attribute(__preserve_most__)
+#if __has_attribute(__preserve_most__) && (defined(CONFIG_X86_64) || defined(CONFIG_ARM64))
 # define __preserve_most notrace __attribute__((__preserve_most__))
 #else
 # define __preserve_most
_

Patches currently in -mm which might be from elver@google.com are

compiler_types-introduce-the-clang-__preserve_most-function-attribute.patch
list_debug-introduce-inline-wrappers-for-debug-checks.patch
list_debug-introduce-config_debug_list_minimal.patch
list_debug-introduce-config_debug_list_minimal-fix.patch

