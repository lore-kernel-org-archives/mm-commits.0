Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE43EB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 16:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjGFQlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjGFQlx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 12:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520B6C1
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 09:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAC1860BFF
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 16:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3598CC433C8;
        Thu,  6 Jul 2023 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688661711;
        bh=5/Va4VucWaKX5ub0zrojP3Hk/ELDaDXgYkcGTNJX1+k=;
        h=Date:To:From:Subject:From;
        b=fIxcFsKdww04pUzepkfvv1K4p2gsvkT4iT7c0WN9asar9dcOkexMaFMHmt7VtkGLO
         H0BZUJoUHCZfsBmN75fXB1b035AlBvY1yNxH0UmwL8+In0jzUbIs0SUt1qQoOaUxEC
         hxWtbsvS0rt/wuKKnWJSMHF7D9qEMcA/PXhRaEOE=
Date:   Thu, 06 Jul 2023 09:41:50 -0700
To:     mm-commits@vger.kernel.org, eric.devolder@oracle.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230706164151.3598CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch

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
From: "Arnd Bergmann" <arnd@arndb.de>
Subject: kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
Date: Thu, 06 Jul 2023 14:18:36 +0200

Today's linux-next now runs into a warning on arm64 and
presumably others, with the same problem as on arm earlier:

WARNING: unmet direct dependencies detected for KEXEC
  Depends on [n]: ARCH_SUPPORTS_KEXEC [=n]
  Selected by [y]:
  - CRASH_DUMP [=y] && ARCH_SUPPORTS_CRASH_DUMP [=y]

I think the easiest way to make this reliable would be
this fixup.

Link: https://lkml.kernel.org/r/c057ba7a-3cc2-44ac-a961-fa062b909876@app.fastmail.com
Signed-off-by: "Arnd Bergmann" <arnd@arndb.de>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/Kconfig.kexec~kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix
+++ a/kernel/Kconfig.kexec
@@ -91,6 +91,7 @@ config KEXEC_JUMP
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	depends on ARCH_SUPPORTS_CRASH_DUMP
+	depends on ARCH_SUPPORTS_KEXEC
 	select CRASH_CORE
 	select KEXEC
 	help
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-consolidate-kexec-and-crash-options-into-kernel-kconfigkexec-fix.patch

