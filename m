Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7152AC5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjAIWsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjAIWr5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:47:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BDE1C138
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:47:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DAB46147B
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737DAC433EF;
        Mon,  9 Jan 2023 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673304475;
        bh=7FrJOPu0b//vybCzL8FlHCYU2vTCZrZj6UwKmRWi1Ks=;
        h=Date:To:From:Subject:From;
        b=NVg9RZsZa9mQsdKM1GATyelRjvZg6ngDCQV03BOFrB7OSNfOqIkgJ2pkCCPVaL3kj
         cZ4SLjiQd/M1S6EHWzYMKcJgbWDattDCRsCRxGnPZtjHr8UroYpFtA5QjAsBssNM4a
         VUVbyKqB+nEaM4CEMw7K2xfzRIHMWcROKuyShfVo=
Date:   Mon, 09 Jan 2023 14:47:54 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, eliasfleckenstein@web.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfig-fix-typo-usafe-unsafe.patch added to mm-hotfixes-unstable branch
Message-Id: <20230109224755.737DAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig: fix typo (usafe -> unsafe)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kconfig-fix-typo-usafe-unsafe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfig-fix-typo-usafe-unsafe.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lizzy Fleckenstein <eliasfleckenstein@web.de>
Subject: kconfig: fix typo (usafe -> unsafe)
Date: Mon, 9 Jan 2023 21:18:37 +0100

Fix the help text for the PRINTK_SAFE_LOG_BUF_SHIFT setting.

Link: https://lkml.kernel.org/r/20230109201837.23873-1-eliasfleckenstein@web.de
Signed-off-by: Lizzy Fleckenstein <eliasfleckenstein@web.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~kconfig-fix-typo-usafe-unsafe
+++ a/init/Kconfig
@@ -776,7 +776,7 @@ config PRINTK_SAFE_LOG_BUF_SHIFT
 	depends on PRINTK
 	help
 	  Select the size of an alternate printk per-CPU buffer where messages
-	  printed from usafe contexts are temporary stored. One example would
+	  printed from unsafe contexts are temporary stored. One example would
 	  be NMI messages, another one - printk recursion. The messages are
 	  copied to the main log buffer in a safe context to avoid a deadlock.
 	  The value defines the size as a power of 2.
_

Patches currently in -mm which might be from eliasfleckenstein@web.de are

kconfig-fix-typo-usafe-unsafe.patch

