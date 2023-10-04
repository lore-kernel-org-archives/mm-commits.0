Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78119E936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbjJDUZO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbjJDUY3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF6810E9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4350CC433CA;
        Wed,  4 Oct 2023 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451035;
        bh=93ARpE/t3dji45c4Eh44q9g4LrmDxPZdrmNWff/wMjs=;
        h=Date:To:From:Subject:From;
        b=2wSapzdDekEwkB5hw7jTorCpIV8oqm13dDd8B1uyG1qcCH5YDSqw1GwXnLJg25r6d
         7Ac7gyBc0HoyJcaLTPe3ixdlqKUOhE97yO6h7QoL6nD3UQjPrBjKPRs5c7u4bSBvxl
         2tzJl6FlB32bXz8Wx4uWxdOJzldal/NoFBWiy0oI=
Date:   Wed, 04 Oct 2023 13:23:53 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        keescook@chromium.org, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jlayton@kernel.org, jack@suse.cz, ghe@suse.com, gechangwei@live.cn,
        dchinner@redhat.com, brauner@kernel.org, azeemshaikh38@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch removed from -mm tree
Message-Id: <20231004202355.4350CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: ocfs2: replace strlcpy with sysfs_emit
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Azeem Shaikh <azeemshaikh38@gmail.com>
Subject: fs: ocfs2: replace strlcpy with sysfs_emit
Date: Thu, 31 Aug 2023 19:38:27 +0000

strlcpy() reads the entire source buffer first.  This read may exceed the
destination size limit.  This is both inefficient and can lead to linear
read overflows if a source string is not NUL-terminated [1].  In an effort
to remove strlcpy() completely [2], replace strlcpy() here with
sysfs_emit().

Direct replacement is safe here since its ok for `kernel_param_ops.get()`
to return -errno [3].

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89
[3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52

Link: https://lkml.kernel.org/r/20230831193827.1528867-1-azeemshaikh38@gmail.com
Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/dlmfs/dlmfs.c~fs-ocfs2-replace-strlcpy-with-sysfs_emit
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -80,8 +80,7 @@ static int param_set_dlmfs_capabilities(
 static int param_get_dlmfs_capabilities(char *buffer,
 					const struct kernel_param *kp)
 {
-	return strlcpy(buffer, DLMFS_CAPABILITIES,
-		       strlen(DLMFS_CAPABILITIES) + 1);
+	return sysfs_emit(buffer, DLMFS_CAPABILITIES);
 }
 module_param_call(capabilities, param_set_dlmfs_capabilities,
 		  param_get_dlmfs_capabilities, NULL, 0444);
_

Patches currently in -mm which might be from azeemshaikh38@gmail.com are


