Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B50C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiANWJ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53AC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18377B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7485C36AED;
        Fri, 14 Jan 2022 22:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198193;
        bh=aNp5XdsonTy6nase51ja7DvCUQtbDcFpa9p+eXvLDog=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=frB06DtmviCcWb5o11I6baKFYWJUfhp4qmYXIX4PxtMlXFFB42ugTVCYpoS4/Xr93
         iLWAcF3DJJN+D5MLARkMozoGRuOFYn2d/Gt/NLkoEmUWhnhoe0gqLIT8ZCWATVjpTo
         U405MW4HNHqbFAVfYL9MUOXMIhnMuZYEEEQifXoQ=
Date:   Fri, 14 Jan 2022 14:09:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org, xhao@linux.alibaba.com
Subject:  [patch 127/146] mm/damon: move damon_rand() definition
 into damon.h
Message-ID: <20220114220953.RcbO-TzCE%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: move damon_rand() definition into damon.h

damon_rand() is called in three files:damon/core.c, damon/ paddr.c,
damon/vaddr.c, i think there is no need to redefine this twice, So move it
to damon.h will be a good choice.

Link: https://lkml.kernel.org/r/20211202075859.51341-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h   |    4 ++++
 mm/damon/core.c         |    4 ----
 mm/damon/prmtv-common.h |    4 ----
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-move-damon_rand-definition-into-damonh
+++ a/include/linux/damon.h
@@ -11,12 +11,16 @@
 #include <linux/mutex.h>
 #include <linux/time64.h>
 #include <linux/types.h>
+#include <linux/random.h>
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION	PAGE_SIZE
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
+/* Get a random number in [l, r) */
+#define damon_rand(l, r) (l + prandom_u32_max(r - l))
+
 /**
  * struct damon_addr_range - Represents an address region of [@start, @end).
  * @start:	Start address of the region (inclusive).
--- a/mm/damon/core.c~mm-damon-move-damon_rand-definition-into-damonh
+++ a/mm/damon/core.c
@@ -11,7 +11,6 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mm.h>
-#include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -23,9 +22,6 @@
 #define DAMON_MIN_REGION 1
 #endif
 
-/* Get a random number in [l, r) */
-#define damon_rand(l, r) (l + prandom_u32_max(r - l))
-
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 
--- a/mm/damon/prmtv-common.h~mm-damon-move-damon_rand-definition-into-damonh
+++ a/mm/damon/prmtv-common.h
@@ -6,10 +6,6 @@
  */
 
 #include <linux/damon.h>
-#include <linux/random.h>
-
-/* Get a random number in [l, r) */
-#define damon_rand(l, r) (l + prandom_u32_max(r - l))
 
 struct page *damon_get_page(unsigned long pfn);
 
_
