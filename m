Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC23C63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjALAPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbjALAPh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3B615F1F
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFB7FB81D81
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983D2C433F0;
        Thu, 12 Jan 2023 00:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482533;
        bh=IwdVLPxpsf/lQWZM5NF4pmE4/7EXbESBjYsDWO7XYSs=;
        h=Date:To:From:Subject:From;
        b=prqZZKLLgc1h7KXsVw/TNufr8XX2Tymlf1UdRAuhFNoj/ZEGWpZtwcXQ/3GqrIbzh
         CNluhOBZ4LdXLOemwMgkmaya78EmpFEhoCN135OpbhsFjQU51uDjXt3NZAP2938x/i
         hCsooWb+wBiCiSOUb21Ugs+8+9JlnjNm5IS7D9f4=
Date:   Wed, 11 Jan 2023 16:15:32 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, eliasfleckenstein@web.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kconfig-fix-typo-usafe-unsafe.patch removed from -mm tree
Message-Id: <20230112001533.983D2C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init/Kconfig: fix typo (usafe -> unsafe)
has been removed from the -mm tree.  Its filename was
     kconfig-fix-typo-usafe-unsafe.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lizzy Fleckenstein <eliasfleckenstein@web.de>
Subject: init/Kconfig: fix typo (usafe -> unsafe)
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


