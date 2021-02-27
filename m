Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D949EC433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB8FB64F14
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhB0Cdk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhB0CdD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A3264F2A;
        Sat, 27 Feb 2021 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393156;
        bh=zcIOik9l9KrEkHUUdEoaVgLNf98hHXnndiGqXs5JtJE=;
        h=Date:From:To:Subject:From;
        b=en9pOZkyCf0uw7C+1UvNWkBXgRab1sKQCr2aLBOKiUCei3o/UbC3X4CWmz5XhX1sV
         XNXU4RPm89074hks9XhE8bxgHZ3WzgoZefEGXM6URiPB1E4iQsXjI9FuSKJBc94eoX
         JPF3jgqxb7i9xhlA5cj1rlbYxMWNfyfmbNEm2jHM=
Date:   Fri, 26 Feb 2021 18:32:36 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johan@kernel.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, ndesaulniers@gooogle.com,
        ojeda@kernel.org
Subject:  [merged] init-clean-up-early_param_on_off-macro.patch
 removed from -mm tree
Message-ID: <20210227023236.jy4YVOAsR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: clean up early_param_on_off() macro
has been removed from the -mm tree.  Its filename was
     init-clean-up-early_param_on_off-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -338,14 +338,14 @@ struct obs_kernel_param {
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

init-kconfig-make-compile_test-depend-on-has_iomem.patch

