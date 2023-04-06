Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D521C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbjDFCpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbjDFCoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04193C1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7C7964266
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC45C4339B;
        Thu,  6 Apr 2023 02:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749076;
        bh=q+/GTsjADZhWWA3Z9HYIOWKdwwP6CsNgEVK++LH08Fw=;
        h=Date:To:From:Subject:From;
        b=LhlyzfVTv5V2udhNjBZNGxBePRS51Wt6ZoxijNyZtgbDPuHT3+VmGgLXnGHKi0uxi
         vnd+BlESeseOrF19ABb782Py0TZKEqUDDfCtPGBsox/o5ZhEAC8JRKzBTLyYExyCdv
         D3joAiSIFtXSiA6x0P/TE5rIoKRUjXJmXtQlCQ9g=
Date:   Wed, 05 Apr 2023 19:44:35 -0700
To:     mm-commits@vger.kernel.org, alexander.h.duyck@linux.intel.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch removed from -mm tree
Message-Id: <20230406024436.4CC45C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_reporting: fix MAX_ORDER usage in page_reporting_register()
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-fix-max_order-usage-in-page_reporting_register.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_reporting: fix MAX_ORDER usage in page_reporting_register()
Date: Wed, 15 Mar 2023 14:31:30 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in page_reporting_register().

Link: https://lkml.kernel.org/r/20230315113133.11326-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-fix-max_order-usage-in-page_reporting_register
+++ a/mm/page_reporting.c
@@ -370,7 +370,7 @@ int page_reporting_register(struct page_
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_ORDER)
+		if (prdev->order > 0 && prdev->order < MAX_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


