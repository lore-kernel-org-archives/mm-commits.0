Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A81C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiE0Qez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237497AbiE0Qey (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:34:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141152B0A
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4621E61DE2
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF7DC385A9;
        Fri, 27 May 2022 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669292;
        bh=E10l0NW7AJEYZdxbll2OUQQ+tI13hCc1dzq8rAjz9V8=;
        h=Date:To:From:Subject:From;
        b=alYaord7hLmR+6rb7c4yApGSj+5GIBAYcZIgsIi6lcJ9AoqC+/DZS7nSgMC19oHe8
         OY4UEmDrPpGSkFZgOIs3zDrxOywtc9WFxNQUSF+tUPVA6XcFjOLdjmN2+TNIu6uKJY
         SxOJ/07zNKOEVtOwynunaUBnXtWo624xwtPXdpV0=
Date:   Fri, 27 May 2022 09:34:52 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-fix-sheduling-while-atomic.patch removed from -mm tree
Message-Id: <20220527163452.9BF7DC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: fix sheduling while atomic
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-sheduling-while-atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix sheduling while atomic
Date: Fri, 29 Apr 2022 14:40:43 +0800

Patch series "A few fixup patches for z3fold".

This series contains a few fixup patches to fix sheduling while atomic,
fix possible null pointer dereferencing, fix various race conditions and
so on. More details can be found in the respective changelogs.


This patch (of 9):

z3fold's page_lock is always held when calling alloc_slots.  So gfp should
be GFP_ATOMIC to avoid "scheduling while atomic" bug.

Link: https://lkml.kernel.org/r/20220429064051.61552-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220429064051.61552-2-linmiaohe@huawei.com
Fixes: fc5488651c7d ("z3fold: simplify freeing slots")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-sheduling-while-atomic
+++ a/mm/z3fold.c
@@ -941,8 +941,7 @@ lookup:
 	}
 
 	if (zhdr && !zhdr->slots)
-		zhdr->slots = alloc_slots(pool,
-					can_sleep ? GFP_NOIO : GFP_ATOMIC);
+		zhdr->slots = alloc_slots(pool, GFP_ATOMIC);
 	return zhdr;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


