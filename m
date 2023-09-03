Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DC5C83F33
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 01:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbjICBta (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 21:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbjICBta (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 21:49:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED7131
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 18:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51AB8B80AB9
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 01:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8B1C433C8;
        Sun,  3 Sep 2023 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693705765;
        bh=GPxiliXvys/oKHH7LM3dfpS7emItwoNZxBo8il0edmo=;
        h=Date:To:From:Subject:From;
        b=d9gOoimHcgjVZd0UPQfwxZdcbxw0Jk/uXSRgFpO9UG2J/waJASnTFlUK3TvMmVfvP
         vYt1f9kogBeELNujc0unzu2dvpOrVYLjoTqYRBai9pdCmS0tIGU1PC1hpo/K9TZ4x1
         ApAn9h+bAj97o1jFdjQTdDIycBCydO45AyXYrMcI=
Date:   Sat, 02 Sep 2023 18:49:23 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        yuanhengzhang1214@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-correct-range-len-in-ocfs2_trim_fs.patch added to mm-nonmm-unstable branch
Message-Id: <20230903014924.DB8B1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: correct range->len in ocfs2_trim_fs()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-correct-range-len-in-ocfs2_trim_fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-correct-range-len-in-ocfs2_trim_fs.patch

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
From: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Subject: ocfs2: correct range->len in ocfs2_trim_fs()
Date: Mon, 28 Aug 2023 13:17:41 +0800

global bitmap is a cluster allocator,so after we traverse the global
bitmap and finished the fstrim,the trimmed range should be 'trimmed *
clustersize'.otherwise,the trimmed range printed by 'fstrim -v' is not as
expected.

Link: https://lkml.kernel.org/r/20230828051741.204577-1-yuanhengzhang1214@gmail.com
Signed-off-by: Yuanheng Zhang <yuanhengzhang1214@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-correct-range-len-in-ocfs2_trim_fs
+++ a/fs/ocfs2/alloc.c
@@ -7642,7 +7642,7 @@ out_mutex:
 		goto next_group;
 	}
 out:
-	range->len = trimmed * sb->s_blocksize;
+	range->len = trimmed * osb->s_clustersize;
 	return ret;
 }
 
_

Patches currently in -mm which might be from yuanhengzhang1214@gmail.com are

ocfs2-correct-range-len-in-ocfs2_trim_fs.patch

