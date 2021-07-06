Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9976EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6A361C98
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 20:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhGFUuE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 16:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhGFUuD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 16:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EBB61C9D;
        Tue,  6 Jul 2021 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625604443;
        bh=hctRHTen9NHetN1O74fe2QcnUI1Ql2u7VUT6RC2ak7w=;
        h=Date:From:To:Subject:From;
        b=hSjQNPA3nmpvVVJAg4LLkVufnBzZr76vf2+h+A4BdJE6ScidiTt6qFe8E3LgikgJ3
         E5bgrE/WpykggeDVzs5Bh07eUloPoiww0pofsgHD4vAQ2Ad0n+cUBUy52ECuJGMjMj
         V6xlQaxnASo75hRKLZ2nIzvMU0bRXJYBz0KDHcOE=
Date:   Tue, 06 Jul 2021 13:47:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, pcc@google.com, glider@google.com,
        dvyukov@google.com, catalin.marinas@arm.com,
        andy.shevchenko@gmail.com, andreyknvl@gmail.com, elver@google.com
Subject:  + kasan-fix-build-by-including-kernelh.patch added to -mm
 tree
Message-ID: <20210706204723.O1wZ2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix build by including kernel.h
has been added to the -mm tree.  Its filename is
     kasan-fix-build-by-including-kernelh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-build-by-including-kernelh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-build-by-including-kernelh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: fix build by including kernel.h

The <linux/kasan.h> header relies on _RET_IP_ being defined, and had been
receiving that definition via inclusion of bug.h which includes kernel.h. 
However, since f39650de687e ("kernel.h: split out panic and oops helpers")
that is no longer the case and get the following build error when building
CONFIG_KASAN_HW_TAGS on arm64:

  In file included from arch/arm64/mm/kasan_init.c:10:
  ./include/linux/kasan.h: In function 'kasan_slab_free':
  ./include/linux/kasan.h:230:39: error: '_RET_IP_' undeclared (first use in this function)
    230 |   return __kasan_slab_free(s, object, _RET_IP_, init);

Fix it by including kernel.h from kasan.h.

Link: https://lkml.kernel.org/r/20210705072716.2125074-1-elver@google.com
Fixes: f39650de687e ("kernel.h: split out panic and oops helpers")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kasan.h~kasan-fix-build-by-including-kernelh
+++ a/include/linux/kasan.h
@@ -3,6 +3,7 @@
 #define _LINUX_KASAN_H
 
 #include <linux/bug.h>
+#include <linux/kernel.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
 
_

Patches currently in -mm which might be from elver@google.com are

mm-move-helper-to-check-slub_debug_enabled.patch
kasan-fix-build-by-including-kernelh.patch

