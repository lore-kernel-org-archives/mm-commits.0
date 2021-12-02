Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F13C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 23:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356488AbhLBXQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 18:16:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356451AbhLBXQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 18:16:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 647D662885
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 23:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FACC00446;
        Thu,  2 Dec 2021 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638486757;
        bh=A3qDS9tE3HRFdqdKEw/vch/vmI8Wgc8RfxZ2xy/7f00=;
        h=Date:From:To:Subject:From;
        b=GnRr87Kv1Ek0kqkc3x+jb/kz44rvgt8ddH+9DFqq9qjbz57EcMYS/doWnsyhtEPd0
         fx5JKwE8HZyQbqzIVKovJxnjCahFyDyufUlnCLu2BVzwyWueRYOBc78q35CZJ/uPrm
         coikhA4MZ5T9DQmCA33kOW+1kr/gUcO884/LZluQ=
Date:   Thu, 02 Dec 2021 15:12:37 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  + mm-damon-move-damon_rand-definition-into-damonh.patch
 added to -mm tree
Message-ID: <20211202231237.li2ujU1Jt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: move damon_rand() definition into damon.h
has been added to the -mm tree.  Its filename is
     mm-damon-move-damon_rand-definition-into-damonh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-move-damon_rand-definition-into-damonh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-move-damon_rand-definition-into-damonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
mm-damon-schemes-add-the-validity-judgment-of-thresholds.patch
mm-damon-move-damon_rand-definition-into-damonh.patch

