Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71548EB64D7
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jun 2023 18:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjFWSh6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 14:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjFWShp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 14:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193A62961
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 11:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A8961AF2
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 18:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E3C433C0;
        Fri, 23 Jun 2023 18:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687545432;
        bh=lCbM0OBfkjL7/noOeRLZHJ+98RqtSw9TARx/P5sLhwc=;
        h=Date:To:From:Subject:From;
        b=zHwrcSoO82x9OLZLHDk4LvKcNGJEKbet5+vjYxCOl66fHhLPkcZCdZReiGJWTXeDk
         IBa+amsaD2DompqkCiMYHgU9dbYb/0yU7LsF689rf5ahmTlj0VpSvJtNuHwqn6wtC4
         VV7HiiFPlPJCdY59Q6OcFEl9vVgJZSz3lGFi/710=
Date:   Fri, 23 Jun 2023 11:37:11 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-redundant-assignment-to-variable-bit_off.patch added to mm-nonmm-unstable branch
Message-Id: <20230623183712.AC5E3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to variable bit_off
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-redundant-assignment-to-variable-bit_off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-redundant-assignment-to-variable-bit_off.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: ocfs2: remove redundant assignment to variable bit_off
Date: Thu, 22 Jun 2023 11:27:36 +0100

Variable bit_off is being assigned a value that is never read, it is being
re-assigned a new value in the following while loop.  Remove the
assignment.  Cleans up clang scan build warning:

fs/ocfs2/localalloc.c:976:18: warning: Although the value stored to
'bit_off' is used in the enclosing expression, the value is never
actually read from 'bit_off' [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20230622102736.2831126-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-remove-redundant-assignment-to-variable-bit_off
+++ a/fs/ocfs2/localalloc.c
@@ -973,7 +973,7 @@ static int ocfs2_sync_local_to_main(stru
 	la_start_blk = ocfs2_clusters_to_blocks(osb->sb,
 						le32_to_cpu(la->la_bm_off));
 	bitmap = la->la_bitmap;
-	start = count = bit_off = 0;
+	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
 	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

ocfs2-remove-redundant-assignment-to-variable-bit_off.patch

