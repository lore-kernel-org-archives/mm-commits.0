Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F25C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECBA61250
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237796AbhIXWo6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237268AbhIXWo5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D525E610C7;
        Fri, 24 Sep 2021 22:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523404;
        bh=nScy0Wx1xgJfJ0hGOIXW7AMGpzIu1SOmolvT6N7GLtY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y/7E93H6/liobOGfgmFh5EhDlY61hgDSpYnP9VGeHQZBDmf4s1kkWcdoB/9BKdDZT
         py7tD1ZaDBTOc+jxuVBUaMGZkpScOxG8Dm4m2nTplwdUnUTfQ+GglAHHuIDhAkkRUS
         lZt+rGPL3PtISiAZR0z5oCMhCv04R+9wshZ+D0QU=
Date:   Fri, 24 Sep 2021 15:43:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nogikh@google.com,
        ryabinin.a.a@gmail.com, tarasmadan@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 02/16] kasan: fix Kconfig check of
 CC_HAS_WORKING_NOSANITIZE_ADDRESS
Message-ID: <20210924224323.hVb3058Us%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS

In the main KASAN config option CC_HAS_WORKING_NOSANITIZE_ADDRESS is
checked for instrumentation-based modes.  However, if
HAVE_ARCH_KASAN_HW_TAGS is true all modes may still be selected.

To fix, also make the software modes depend on
CC_HAS_WORKING_NOSANITIZE_ADDRESS.

Link: https://lkml.kernel.org/r/20210910084240.1215803-1-elver@google.com
Fixes: 6a63a63ff1ac ("kasan: introduce CONFIG_KASAN_HW_TAGS")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.kasan~kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address
+++ a/lib/Kconfig.kasan
@@ -66,6 +66,7 @@ choice
 config KASAN_GENERIC
 	bool "Generic mode"
 	depends on HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
@@ -86,6 +87,7 @@ config KASAN_GENERIC
 config KASAN_SW_TAGS
 	bool "Software tag-based mode"
 	depends on HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
_
