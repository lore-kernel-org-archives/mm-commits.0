Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78272C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5072861101
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 03:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347339AbhIHDCG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347428AbhIHDBz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95E26115A;
        Wed,  8 Sep 2021 03:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631070048;
        bh=wft8+l0eKu/8vUflU53CGL1GXpCtIaCBCI06WtNLJRY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CVCb28M2YHYRrPu8FTdAO+lgci6M2MGGQFva6cafGMpTAUrjQNAWj6JliHK9w9D6O
         7Q30yTxbVk6c/IqUIixbiUkIVqteF8zgGLlasJ1sTkD6GrP9UD5rtnui7X8Nrlbuhr
         lRlErbIjorBzotP+UPiboXl4S+5aMWLLZB6ucHsA=
Date:   Tue, 07 Sep 2021 20:00:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, babu.moger@oracle.com,
        dzickus@redhat.com, linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        npiggin@gmail.com, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 143/147] Kconfig.debug: drop selecting
 non-existing HARDLOCKUP_DETECTOR_ARCH
Message-ID: <20210908030047.04y0bRC2_%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH

Commit 05a4a9527931 ("kernel/watchdog: split up config options") adds a
new config HARDLOCKUP_DETECTOR, which selects the non-existing config
HARDLOCKUP_DETECTOR_ARCH.

Hence, ./scripts/checkkconfigsymbols.py warns:

HARDLOCKUP_DETECTOR_ARCH Referencing files: lib/Kconfig.debug

Simply drop selecting the non-existing HARDLOCKUP_DETECTOR_ARCH.

Link: https://lkml.kernel.org/r/20210806115618.22088-1-lukas.bulwahn@gmail.com
Fixes: 05a4a9527931 ("kernel/watchdog: split up config options")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/Kconfig.debug~kconfigdebug-drop-selecting-non-existing-hardlockup_detector_arch
+++ a/lib/Kconfig.debug
@@ -1062,7 +1062,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
_
