Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A1EEB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjFXAEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjFXAEh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D117D2126
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B9761B46
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD21FC433C9;
        Sat, 24 Jun 2023 00:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687565074;
        bh=Jgpf2oxgQfR+DtgyvZqsWKwvyMJjox+AqrHUgbOOS0w=;
        h=Date:To:From:Subject:From;
        b=mvwvD3bK8Bc93wFE1syEWjsOz0kEbh347x80ybNhJB2LhEE8A/J/kJO+eIoOru3Ey
         E47jMiGRxpgH20vTmMFbEFh5yyoCDSgzN9FqZmXWofgQkrz9qrUD/M6ReA56gSeW/D
         B5/8t9bTczDIuFiBkUpJVbof0r/X+XLO1qBm5V4Q=
Date:   Fri, 23 Jun 2023 17:04:34 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-redundant-assignment-to-variable-bit_off.patch removed from -mm tree
Message-Id: <20230624000434.BD21FC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: remove redundant assignment to variable bit_off
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-assignment-to-variable-bit_off.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


