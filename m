Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21A4C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6E661D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2Coz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhF2Coy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E4661D0C;
        Tue, 29 Jun 2021 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934548;
        bh=5xzt0sUK/BT1kWrsut9cB0A0tqHwmCYKoY/PFN1JRp0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Te8KpwdYXUixR2cZHqOBUS67u0J3Dh3gLlL0g6DNdisq50/+vZHCZjeq7nQ3eZBlt
         lEvy31knzbWVwmFIAxzExC1LJ+4tEZFDBT9yBZ2ltIUd3BRBquqOlKhdEWJCX/ckKF
         M+8qIcost4XEbu8lWbq6Ub67OvjD5gZfcRlTNLgQ=
Date:   Mon, 28 Jun 2021 19:42:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aisheng.dong@nxp.com, akpm@linux-foundation.org,
        andreyknvl@gmail.com, catalin.marinas@arm.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        yuzhao@google.com
Subject:  [patch 176/192] mm: drop SECTION_SHIFT in code comments
Message-ID: <20210629024227.hLvezFtPt%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>
Subject: mm: drop SECTION_SHIFT in code comments

Actually SECTIONS_SHIFT is used in the kernel code, so the code comments
is strictly incorrect.  And since commit bbeae5b05ef6 ("mm: move page
flags layout to separate header"), SECTIONS_SHIFT definition has been
moved to include/linux/page-flags-layout.h, since code itself looks quite
straighforward, instead of moving the code comment into the new place as
well, we just simply remove it.

This also fixed a checkpatch complain derived from the original code:
WARNING: please, no space before tabs
+ * SECTIONS_SHIFT    ^I^I#bits space required to store a section #$

Link: https://lkml.kernel.org/r/20210531091908.1738465-2-aisheng.dong@nxp.com
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Suggested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/mmzone.h~mm-drop-section_shift-in-code-comments
+++ a/include/linux/mmzone.h
@@ -1200,8 +1200,6 @@ static inline struct zoneref *first_zone
 #ifdef CONFIG_SPARSEMEM
 
 /*
- * SECTION_SHIFT    		#bits space required to store a section #
- *
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
_
