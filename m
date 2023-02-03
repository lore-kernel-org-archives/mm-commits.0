Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CF8C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjBCGhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjBCGgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD928CAA1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A56C4B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424A1C4339B;
        Fri,  3 Feb 2023 06:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406164;
        bh=Ok0eG1xBjp/dRnurLijSg4m20MMqTeSZCkP0G01OlWo=;
        h=Date:To:From:Subject:From;
        b=P9vTzrvNikCehc+QLHQMSzaga5VnmqXmTRBf1Bk+CaWFZcUG6lpz7DJfwh2L6wgpc
         qL6W/kQcIL0/skRHcHwfisO9I4k41yC4Vo3pZSoa7e9t4rCiealzuTMv6crk5H9fra
         SdtpO2PifqDVPV8fbew9h09fJJ1P5Go9Bb9H8VKQ=
Date:   Thu, 02 Feb 2023 22:36:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, vernon2gm@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-fix-comment-of-unmapped_area_topdown.patch removed from -mm tree
Message-Id: <20230203063604.424A1C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: fix comment of unmapped_area{_topdown}
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-comment-of-unmapped_area_topdown.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vernon Yang <vernon2gm@gmail.com>
Subject: mm/mmap: fix comment of unmapped_area{_topdown}
Date: Wed, 11 Jan 2023 21:20:36 +0800

The low_limit of unmapped area information is inclusive, and the
hight_limit is not, so make symbol to be [ instead of (.

And replace hight_limit to high_limit.

Link: https://lkml.kernel.org/r/20230111132036.801404-1-vernon2gm@gmail.com
Fixes: 3499a13168da ("mm/mmap: use maple tree for unmapped_area{_topdown}")
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-mmap-fix-comment-of-unmapped_area_topdown
+++ a/mm/mmap.c
@@ -1558,8 +1558,8 @@ static inline int accountable_mapping(st
  * the correct alignment and offset, all from @info. Note: current->mm is used
  * for the search.
  *
- * @info: The unmapped area information including the range (low_limit -
- * hight_limit), the alignment offset and mask.
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
@@ -1585,11 +1585,11 @@ static unsigned long unmapped_area(struc
 
 /**
  * unmapped_area_topdown() - Find an area between the low_limit and the
- * high_limit with * the correct alignment and offset at the highest available
+ * high_limit with the correct alignment and offset at the highest available
  * address, all from @info. Note: current->mm is used for the search.
  *
- * @info: The unmapped area information including the range (low_limit -
- * hight_limit), the alignment offset and mask.
+ * @info: The unmapped area information including the range [low_limit -
+ * high_limit), the alignment offset and mask.
  *
  * Return: A memory address or -ENOMEM.
  */
_

Patches currently in -mm which might be from vernon2gm@gmail.com are


