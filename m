Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB0C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbiGDBJx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiGDBJn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BF2617D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14892B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2611C341C6;
        Mon,  4 Jul 2022 01:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896979;
        bh=WjKdYH78D4BZZgzsDvYNWLeX5xaCpl1O/+T4J5tznxY=;
        h=Date:To:From:Subject:From;
        b=GsLoVgCLX0qgHieWwUDwVcUqcgtPx+8lbuccx3OsoZ/jD3gRaq3BOceb9Bbz9QH1P
         iij/str3vwuQaRx5osLAQgI7fnMILU/Gn9iZ2G2g2/QqhxOJaUGI3PVW0SVih5HbTT
         l0LcboC6jhSf6enKmoCiB981BPIPdOfyZeyaNTUA=
Date:   Sun, 03 Jul 2022 18:09:39 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        tianyu.li@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-fix-get_nodes-out-of-bound-access.patch removed from -mm tree
Message-Id: <20220704010939.C2611C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix get_nodes out of bound access
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-get_nodes-out-of-bound-access.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tianyu Li <tianyu.li@arm.com>
Subject: mm/mempolicy: fix get_nodes out of bound access
Date: Wed, 1 Jun 2022 17:32:11 +0800

When user specified more nodes than supported, get_nodes will access nmask
array out of bounds.

Link: https://lkml.kernel.org/r/20220601093211.2970565-1-tianyu.li@arm.com
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Signed-off-by: Tianyu Li <tianyu.li@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-get_nodes-out-of-bound-access
+++ a/mm/mempolicy.c
@@ -1388,7 +1388,7 @@ static int get_nodes(nodemask_t *nodes,
 		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
 		unsigned long t;
 
-		if (get_bitmap(&t, &nmask[maxnode / BITS_PER_LONG], bits))
+		if (get_bitmap(&t, &nmask[(maxnode - 1) / BITS_PER_LONG], bits))
 			return -EFAULT;
 
 		if (maxnode - bits >= MAX_NUMNODES) {
_

Patches currently in -mm which might be from tianyu.li@arm.com are


