Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657D5C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377751AbiATV01 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiATV00 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 475DE60C32
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A10BC340E0;
        Thu, 20 Jan 2022 21:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713985;
        bh=peAbX9nPjVVrJQIUzh9C90HqaBwqHCabBi2iX3uPf3A=;
        h=Date:From:To:Subject:From;
        b=11kl1pt1Oze7armqOtEyxtnlfi05yLvf+HwLOaoy3kUzM/XKdt2FAECUI7mW41M6R
         cEMcjqq+CmLAJpZbaWcA7uhOvdOfeDxN27CGBMNELB38l47wtFkQcIKujqcZ+aSR5O
         EUkfAvpjgw3uoXSNiB2rNaoDVSXpIFGlHkSY9s0s=
Date:   Thu, 20 Jan 2022 13:26:24 -0800
From:   akpm@linux-foundation.org
To:     arthur.marsh@internode.on.net, mm-commits@vger.kernel.org,
        sxwjean@gmail.com
Subject:  [merged]
 mm-page_alloc-fix-building-error-on-werror=array-compare.patch removed from
 -mm tree
Message-ID: <20220120212624.SoaGjak9g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix building error on -Werror=array-compare
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-building-error-on-werror=array-compare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiongwei Song <sxwjean@gmail.com>
Subject: mm: page_alloc: fix building error on -Werror=array-compare

Arthur Marsh reported we would hit the error below when building kernel
with gcc-12:

CC      mm/page_alloc.o
mm/page_alloc.c: In function `mem_init_print_info':
mm/page_alloc.c:8173:27: error: comparison between two arrays [-Werror=array-compare]
 8173 |                 if (start <= pos && pos < end && size > adj) \
      |

In C++20, the comparision between arrays should be warned.

Link: https://lkml.kernel.org/r/20211125130928.32465-1-sxwjean@me.com
Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-building-error-on-werror=array-compare
+++ a/mm/page_alloc.c
@@ -8228,7 +8228,7 @@ void __init mem_init_print_info(void)
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
 	do { \
-		if (start <= pos && pos < end && size > adj) \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
 			size -= adj; \
 	} while (0)
 
_

Patches currently in -mm which might be from sxwjean@gmail.com are


