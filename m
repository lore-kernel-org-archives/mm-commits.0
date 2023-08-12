Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A159DC001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjHLWGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjHLWFv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D94C1732
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351CA60BFC
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DBC433C7;
        Sat, 12 Aug 2023 22:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877953;
        bh=J7fL44d+e4gjOFZDx/7QWePLGx6FIP9eAeTHpRFZqa8=;
        h=Date:To:From:Subject:From;
        b=lTnAip4nFb291YBvKX7s11wMF5kUsfXrrimUi47RbKGahOD/ry6qR9SQkZ8vzDdz+
         eLCnTj9pb+X91rtFu2hxJXWy6s+ah+EvHGQ7WsG419ul0ZuUSk8OIcvXUgf6vElZeW
         LhQRlRorXPyBNsqeEpKpSj+j8DkSmENuEovTPEkw=
Date:   Sat, 12 Aug 2023 15:05:53 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-regular-seq_show_option-for-osb_cluster_stack.patch removed from -mm tree
Message-Id: <20230812220553.894DBC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: use regular seq_show_option for osb_cluster_stack
has been removed from the -mm tree.  Its filename was
     ocfs2-use-regular-seq_show_option-for-osb_cluster_stack.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ocfs2: use regular seq_show_option for osb_cluster_stack
Date: Wed, 26 Jul 2023 14:59:22 -0700

While cleaning up seq_show_option_n()'s use of strncpy, it was noticed
that the osb_cluster_stack member is always NUL-terminated, so there is no
need to use the special seq_show_option_n() routine.  Replace it with the
standard seq_show_option() routine.

Link: https://lkml.kernel.org/r/20230726215919.never.127-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-use-regular-seq_show_option-for-osb_cluster_stack
+++ a/fs/ocfs2/super.c
@@ -1517,8 +1517,7 @@ static int ocfs2_show_options(struct seq
 		seq_printf(s, ",localflocks,");
 
 	if (osb->osb_cluster_stack[0])
-		seq_show_option_n(s, "cluster_stack", osb->osb_cluster_stack,
-				  OCFS2_STACK_LABEL_LEN);
+		seq_show_option(s, "cluster_stack", osb->osb_cluster_stack);
 	if (opts & OCFS2_MOUNT_USRQUOTA)
 		seq_printf(s, ",usrquota");
 	if (opts & OCFS2_MOUNT_GRPQUOTA)
_

Patches currently in -mm which might be from keescook@chromium.org are


