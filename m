Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE95C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244912AbiEKTAU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245347AbiEKTAM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8AA6D3A6
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99C6B6106E
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE502C340EE;
        Wed, 11 May 2022 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652295610;
        bh=pfMWy+kML0IeWChhiX49jVAhLQFzVZ1bAkIvgDHX6uQ=;
        h=Date:To:From:Subject:From;
        b=Wq8CceusCPF9T8yUdc/vzblt4ezf3c7UjLDrEYYj48kiDACvKj4HYyfJRomkmnJpt
         NftuRV12a5DEpASfOwMeJnVAjCJWykcpXJb2/1u4ZXMdBWSojb22Zvs3oOn6475vBv
         LHqLPIFaUatwcr50aQAMS/S/GIYL20Qi5bll3ny0=
Date:   Wed, 11 May 2022 12:00:09 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to mm-unstable branch
Message-Id: <20220511190009.EE502C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: Fix expanding null off the end of the data.
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: Fix expanding null off the end of the data.

When expanding a write of null to another null, the metadata for the end
of the node may be off by one.  Fix this issue by setting the write end
pivot (wr_mas->end_piv) in mas_wr_extend_null().  Also use the saved value
for the end pivot during node stores instead of looking up the same entry
again.

There is also unnecessary code in mas_wr_extend_null() that can be
dropped.

Link: https://lkml.kernel.org/r/20220511144304.1430851-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -3981,8 +3981,7 @@ static inline bool mas_wr_node_store(str
 
 		new_end++;
 	} else {
-		if (mas_safe_pivot(mas, wr_mas->pivots, wr_mas->offset_end,
-				   wr_mas->type) == mas->last)
+		if (wr_mas->end_piv == mas->last)
 			wr_mas->offset_end++;
 
 		new_end -= wr_mas->offset_end - offset - 1;
@@ -4146,10 +4145,7 @@ static inline void mas_wr_extend_null(st
 			mas->last = mas->max;
 		else
 			mas->last = wr_mas->pivots[wr_mas->offset_end];
-	} else if ((mas->last > wr_mas->end_piv) &&
-		   !wr_mas->slots[wr_mas->offset_end]) {
-		mas->last = wr_mas->end_piv;
-		wr_mas->offset_end++;
+		wr_mas->end_piv = mas->last;
 	}
 
 	if (!wr_mas->content) {
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch

