Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C819C43331
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434C664F4E
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBZBW0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhBZBVY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D38E64F2C;
        Fri, 26 Feb 2021 01:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302443;
        bh=HUttX15HCu5+WiiJJVTV/D4RJ/cr96GIbdJE+30eOvI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NfEmJp6dtCf8fshVNpfbWEL3oGzGi0Y1VxmtKPx2ccVLJYAzrPNgBnYOt6nOBm/ZA
         GCl4Moaat/3feFDQeRzJ2/cN8bEWlshpE3y4rjs1FaWsyX6APkeYQfJi0Xgp5TxLmQ
         rzvE63WRSivoVoIrvvflov8WaujcGD1FPebjFPOM=
Date:   Thu, 25 Feb 2021 17:20:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        ink@jurassic.park.msu.ru, keescook@chromium.org,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, rth@twiddle.net,
        torvalds@linux-foundation.org
Subject:  [patch 082/118] alpha: remove CONFIG_EXPERIMENTAL from
 defconfigs
Message-ID: <20210226012042.0FIADKS4Q%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: remove CONFIG_EXPERIMENTAL from defconfigs

Since CONFIG_EXPERIMENTAL was removed in 2013, go ahead and drop it
from any defconfig files.

Link: https://lkml.kernel.org/r/20210115005956.29408-1-rdunlap@infradead.org
Fixes: 3d374d09f16f ("final removal of CONFIG_EXPERIMENTAL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/configs/defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/configs/defconfig~alpha-remove-config_experimental-from-defconfigs
+++ a/arch/alpha/configs/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
_
