Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86112C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4773260235
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBAXpe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhBAXpc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:45:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E73D764EC6;
        Mon,  1 Feb 2021 23:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612223092;
        bh=+LOoqVdm9q5EJXhcDjnGTicGK2cG/WMx4DU18xsTskI=;
        h=Date:From:To:Subject:From;
        b=Cf7lb3Bnesv+jTxDVWqbFwRgxeCd0eagA6tnHvjE6PNdGT83+5AC+oXyliVbYxrPa
         KzIgUUQsk2ABXtzIx2kZDpez9kpiC3HBS139kaAMRqGHKMBRC8DxSbTA1Qnj38LUMk
         kGOoEh1gaZuAn/wn3jpTxg73LwDcv2iR/NzhEbu8=
Date:   Mon, 01 Feb 2021 15:44:51 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johan@kernel.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, ndesaulniers@gooogle.com,
        ojeda@kernel.org
Subject:  + init-clean-up-early_param_on_off-macro.patch added to
 -mm tree
Message-ID: <20210201234451.p3neEkCzM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: clean up early_param_on_off() macro
has been added to the -mm tree.  Its filename is
     init-clean-up-early_param_on_off-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-clean-up-early_param_on_off-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-clean-up-early_param_on_off-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init: clean up early_param_on_off() macro

Use early_param() to define early_param_on_off().

Link: https://lkml.kernel.org/r/20210201041532.4025025-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nick Desaulniers <ndesaulniers@gooogle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/init.h~init-clean-up-early_param_on_off-macro
+++ a/include/linux/init.h
@@ -277,14 +277,14 @@ struct obs_kernel_param {
 		var = 1;						\
 		return 0;						\
 	}								\
-	__setup_param(str_on, parse_##var##_on, parse_##var##_on, 1);	\
+	early_param(str_on, parse_##var##_on);				\
 									\
 	static int __init parse_##var##_off(char *arg)			\
 	{								\
 		var = 0;						\
 		return 0;						\
 	}								\
-	__setup_param(str_off, parse_##var##_off, parse_##var##_off, 1)
+	early_param(str_off, parse_##var##_off)
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
_

Patches currently in -mm which might be from masahiroy@kernel.org are

init-versionc-remove-version_linux_version_code-symbol.patch
init-clean-up-early_param_on_off-macro.patch

