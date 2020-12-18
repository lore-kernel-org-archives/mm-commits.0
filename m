Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9EEC3526F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6E423B97
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgLRWEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:04:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgLRWEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:04:12 -0500
Date:   Fri, 18 Dec 2020 14:03:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329036;
        bh=QMYVZBUjFli/H6X7hOz80AwmmUTQTOwCo6dvVlQUpWY=;
        h=From:To:Subject:In-Reply-To:From;
        b=1jkwA/khmn5vUwITa7pL5MPIFv3HjH//ZUgxEmiK217xdIao3+CwJ9Co2v7stOiZ7
         DBsA3FITCZonlHMSI4hrMNJAvAaQKMBTKveSk6mv88gCzcH2T8opOWyuLRfysr9Uff
         Xmbw6qYshXyKXoy2GRWIoatr7pZfVi0otyEiVO7A=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 46/78] kasan: define KASAN_GRANULE_SIZE for
 HW_TAGS
Message-ID: <20201218220355.eTvuK7ok6%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: define KASAN_GRANULE_SIZE for HW_TAGS

Hardware tag-based KASAN has granules of MTE_GRANULE_SIZE.  Define
KASAN_GRANULE_SIZE to MTE_GRANULE_SIZE for CONFIG_KASAN_HW_TAGS.

Link: https://lkml.kernel.org/r/3d15794b3d1b27447fd7fdf862c073192ba657bd.1606161801.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/kasan/kasan.h~kasan-define-kasan_granule_size-for-hw_tags
+++ a/mm/kasan/kasan.h
@@ -5,7 +5,13 @@
 #include <linux/kasan.h>
 #include <linux/stackdepot.h>
 
+#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_GRANULE_SIZE	(1UL << KASAN_SHADOW_SCALE_SHIFT)
+#else
+#include <asm/mte-kasan.h>
+#define KASAN_GRANULE_SIZE	MTE_GRANULE_SIZE
+#endif
+
 #define KASAN_GRANULE_MASK	(KASAN_GRANULE_SIZE - 1)
 
 #define KASAN_MEMORY_PER_SHADOW_PAGE	(KASAN_GRANULE_SIZE << PAGE_SHIFT)
_
