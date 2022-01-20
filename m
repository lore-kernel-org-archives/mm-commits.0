Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1282C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377892AbiATV2a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58960 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377891AbiATV2a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE9DAB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98010C340E0;
        Thu, 20 Jan 2022 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714107;
        bh=47xXf3/s1xbtzteOuSD+LyMGZ3xb5MmubuK3x5CTBTA=;
        h=Date:From:To:Subject:From;
        b=D5sl/ES/j/ErBgrNYMO+i7K1oq4vp897aoaXnruBE7wJk1Ic/JmtYzaWbUXxxeCir
         D9uY56PLffh7H0oPbGAV7vbtgC29nA35u+V2YRJWG1wnoMEI45gjpsxCOXspTE43NF
         IErB7AVIYu85938XUjP1mTiIsFa9ZlI5qly+MMyc=
Date:   Thu, 20 Jan 2022 13:28:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-move-damon_rand-definition-into-damonh.patch removed from -mm tree
Message-ID: <20220120212827.w0r08iMn3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: move damon_rand() definition into damon.h
has been removed from the -mm tree.  Its filename was
     mm-damon-move-damon_rand-definition-into-damonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xhao@linux.alibaba.com are


