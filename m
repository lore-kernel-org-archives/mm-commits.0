Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B225EE020C
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 20:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjIMUOO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 16:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjIMUNy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 16:13:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09701BE6
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 13:13:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414DFC433C7;
        Wed, 13 Sep 2023 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694636023;
        bh=GtUWXuTtFH7RNLQ+8fbiMPB0frJdIhC5UGKnKtaGVZo=;
        h=Date:To:From:Subject:From;
        b=CH4k2ZqL26b43u2XBRDdWWm4eP+oECphPDrqfoR/L+jLEudYhVI069ICkLo6X4eoy
         6zTKLLlGymLdHTfUJrViiBdFY4SFpAmR61uWavaxymC/uO47FQdXIQDtDy+uyEFylp
         y4z6g/4hY5mt54DsD2QS5UQKaL5vIcfSnNoNhXbA=
Date:   Wed, 13 Sep 2023 13:13:42 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        keescook@chromium.org, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jlayton@kernel.org, jack@suse.cz, ghe@suse.com, gechangwei@live.cn,
        dchinner@redhat.com, brauner@kernel.org, azeemshaikh38@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch added to mm-nonmm-unstable branch
Message-Id: <20230913201343.414DFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: ocfs2: replace strlcpy with sysfs_emit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch

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

fs-ocfs2-replace-strlcpy-with-sysfs_emit.patch

