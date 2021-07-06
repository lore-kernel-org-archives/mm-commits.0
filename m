Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DDAC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D073560FE3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGFTRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTRw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:17:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A277760C3D;
        Tue,  6 Jul 2021 19:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598912;
        bh=3yK1/rNmmKRthICpRxh6yjYCUjDvnTmijf7eEaACe5w=;
        h=Date:From:To:Subject:From;
        b=SCGdwHGA8l/RupNA/1g8FzgkVCfM694clo7RqitksgpsxQoPPLCI1Zhf/F41GMlWi
         pkSQB+X4z0RdI/Wwa+nJR8Zw9dmlo/Gt1Hvhc7ZgmTHq1fE4aCmsXKYsly2Axk4w1Y
         43Kwwl96a1WfWR9ZPwsj4D5H4uPwT4XDnNkD23Tk=
Date:   Tue, 06 Jul 2021 12:15:12 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, andreyknvl@gmail.com,
        catalin.marinas@arm.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  [merged] mm-drop-section_shift-in-code-comments.patch
 removed from -mm tree
Message-ID: <20210706191512.zre7v7vXe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop SECTION_SHIFT in code comments
has been removed from the -mm tree.  Its filename was
     mm-drop-section_shift-in-code-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from aisheng.dong@nxp.com are


