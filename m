Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AA9C47E48
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FFB61370
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhGOE3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC33761362;
        Thu, 15 Jul 2021 04:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323201;
        bh=suk6yR+TaSk/Rfa/37qk89OWG/hZc2Q8FnnnhUvgrd4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xp0G27ceZsFvFPMKYtSsiRGK8NT5l0a9cPIWxfmgcLg4duA2pJ4OdhXnqR1i/k/Md
         e2pkGG4rdS7EYFpBqXkak53ItUoZq+6Qn/FD6IIh19R+Nt6LVTUvOb4pu4bwpTA9Kn
         SzvWHMTiOsXnCnPf+nb9tkKAHvq3HIyQ1ki7s05U=
Date:   Wed, 14 Jul 2021 21:26:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        andy.shevchenko@gmail.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, pcc@google.com,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com
Subject:  [patch 03/13] kasan: fix build by including kernel.h
Message-ID: <20210715042640.2WLhaWjjL%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
