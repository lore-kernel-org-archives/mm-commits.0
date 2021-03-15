Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0308CC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D8664F3A
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhCOR4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232143AbhCORsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CADDC64F0D;
        Mon, 15 Mar 2021 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830468;
        bh=+5wm3Wb0UUAcmej+sxf7vZTD1Ah61+Z84WXLbZ4H4eI=;
        h=Date:From:To:Subject:From;
        b=PSrv3QML3tr3dn08FFqOc4ezKEiKxcVtDDa6oFdj9rgbQTFLd2mQmSXTJf/Q8NNwt
         ZcyfxUbL7jTIjmEFYfNIKhvOFICQ634V23R/LpBtWGrXbcOByKPbYVeT4bXN6reQug
         8vQXSdBBP25Gm63xjUKjFPe2uXjiR7HynMaYhjMY=
Date:   Mon, 15 Mar 2021 10:47:47 -0700
From:   akpm@linux-foundation.org
To:     arnd@kernel.org, daniel@iogearbox.net, hannes@cmpxchg.org,
        hca@linux.ibm.com, keescook@chromium.org, kpsingh@google.com,
        linux@roeck-us.net, lkml@metux.net, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org, qperret@google.com,
        terrelln@fb.com, valentin.schneider@arm.com
Subject:  [merged]
 init-kconfig-make-compile_test-depend-on-has_iomem.patch removed from -mm
 tree
Message-ID: <20210315174747.fGyt23ary%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM
has been removed from the -mm tree.  Its filename was
     init-kconfig-make-compile_test-depend-on-has_iomem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM

I read the commit log of the following two:

- bc083a64b6c0 ("init/Kconfig: make COMPILE_TEST depend on !UML")
- 334ef6ed06fa ("init/Kconfig: make COMPILE_TEST depend on !S390")

Both are talking about HAS_IOMEM dependency missing in many drivers.

So, 'depends on HAS_IOMEM' seems the direct, sensible solution to me.

This does not change the behavior of UML. UML still cannot enable
COMPILE_TEST because it does not provide HAS_IOMEM.

The current dependency for S390 is too strong. Under the condition of
CONFIG_PCI=y, S390 provides HAS_IOMEM, hence can enable COMPILE_TEST.

I also removed the meaningless 'default n'.

Link: https://lkml.kernel.org/r/20210224140809.1067582-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KP Singh <kpsingh@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/init/Kconfig~init-kconfig-make-compile_test-depend-on-has_iomem
+++ a/init/Kconfig
@@ -119,8 +119,7 @@ config INIT_ENV_ARG_LIMIT
 
 config COMPILE_TEST
 	bool "Compile also drivers which will not load"
-	depends on !UML && !S390
-	default n
+	depends on HAS_IOMEM
 	help
 	  Some drivers can be compiled on a different platform than they are
 	  intended to be run on. Despite they cannot be loaded there (or even
_

Patches currently in -mm which might be from masahiroy@kernel.org are

compat-remove-unneeded-declaration-from-compat_syscall_definex.patch

