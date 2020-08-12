Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5ACC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4182078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266337;
	bh=IvUB+LdBo3iV+aHDp2LYLpxNB0219fMJBNU9dO/UNi0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ELYLp6UX1D24p0BS9v90DLAf5fVd8mYPfqqOCcNMPI7Vpng04PphINgFHBDfj8xII
	 gCCvTaNURzvmlTZxwYywP6JV9A7Pixpu2zgkSHG0uocPItstSQ9qR9zjlFJ2oY1LKv
	 wsilxfVpXmrXqbISKTFEGUBoOgBkM/fMvjiG7IPc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHLVFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVFh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 907F020838;
        Wed, 12 Aug 2020 21:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266336;
        bh=IvUB+LdBo3iV+aHDp2LYLpxNB0219fMJBNU9dO/UNi0=;
        h=Date:From:To:Subject:From;
        b=GQ2CNyTFrPMXGLa3qJYP5sfJJHkCxu2IhklML5MhDPUyqKENPPPAMBhXmCjrFZxJU
         JUq/rLy9WQbgDsm01asLHcZYijcRVFbKxtUVTlwquCo51eemasbuRU9USbavdFJUyj
         WUbHrOKoCMedrE7qQyGSUKjcIvAY2amp23FEFk9c=
Date:   Wed, 12 Aug 2020 14:05:36 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, lixuefeng@loongson.cn,
        mm-commits@vger.kernel.org, yangtiezhu@loongson.cn
Subject:  [merged]
 lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch
 removed from -mm tree
Message-ID: <20200812210536.0EghXg_Tg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT
has been removed from the -mm tree.  Its filename was
     lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: lib/Kconfig.debug: fix typo in the help text of CONFIG_PANIC_TIMEOUT

There exists duplicated "the" in the help text of CONFIG_PANIC_TIMEOUT,
Remove it.

Link: http://lkml.kernel.org/r/1591103358-32087-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-fix-typo-in-the-help-text-of-config_panic_timeout
+++ a/lib/Kconfig.debug
@@ -917,7 +917,7 @@ config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
 	help
-	  Set the timeout value (in seconds) until a reboot occurs when the
+	  Set the timeout value (in seconds) until a reboot occurs when
 	  the kernel panics. If n = 0, then we wait forever. A timeout
 	  value n > 0 will wait n seconds before rebooting, while a timeout
 	  value n < 0 will reboot immediately.
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


