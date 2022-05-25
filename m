Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4C3C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 20:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiEYUHT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 16:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344970AbiEYUHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 16:07:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912BD6A426
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 13:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FC3B81EA1
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 20:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B36C385B8;
        Wed, 25 May 2022 20:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653509216;
        bh=ztjgle/K2/xhmqi/bvfch9LMKnwhiff0BhsWg4UUmZ8=;
        h=Date:To:From:Subject:From;
        b=bWTZB3ugNZ54IhmjsW7IArYwLga4YR7eahuxFk06fM9H60Jzj20MKZzSN3bItmTzE
         R98JhvXJzs94egAZzBK/L1t7ihtw9Llo/EYWCzra48VJ+iRbzuskzP1zBDKXc7AMTX
         5jqZfsAV2MNzBZGzewfUScNn2iFR2c2qS0g7UPHU=
Date:   Wed, 25 May 2022 13:06:55 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch removed from -mm tree
Message-Id: <20220525200656.96B36C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
has been removed from the -mm tree.  Its filename was
     ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Junxiao Bi <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
Date: Wed, 18 May 2022 16:52:23 -0700

The following function is the only place that checks USER_LOCK_ATTACHED. 
This flag is set when lock request is granted through user_ast() and only
the following function will clear it.

Checking of this flag here is to make sure ocfs2_dlm_unlock is not issued
if this lock is never granted.  For example, lock file is created and then
get removed, open file never happens.

Clearing the flag here is not necessary because this is the only function
that checks it, if another flow is executing user_dlm_destroy_lock(), it
will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
check USER_LOCK_ATTACHED.  Drop the clear, so we don't need take care of
it for the following error handling patch.

int user_dlm_destroy_lock(struct user_lock_res *lockres)
{
    ...

    status = 0;
    if (!(lockres->l_flags & USER_LOCK_ATTACHED)) {
        spin_unlock(&lockres->l_lock);
        goto bail;
    }

    lockres->l_flags &= ~USER_LOCK_ATTACHED;
    lockres->l_flags |= USER_LOCK_BUSY;
    spin_unlock(&lockres->l_lock);

	status = ocfs2_dlm_unlock(conn, &lockres->l_lksb, DLM_LKF_VALBLK);
    if (status) {
        user_log_dlm_error("ocfs2_dlm_unlock", status, lockres);
        goto bail;
    }
	...
}

V1 discussion with Joseph:
https://lore.kernel.org/all/7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com/T/

Link: https://lkml.kernel.org/r/20220518235224.87100-1-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/userdlm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlmfs/userdlm.c~ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock
+++ a/fs/ocfs2/dlmfs/userdlm.c
@@ -619,7 +619,6 @@ int user_dlm_destroy_lock(struct user_lo
 		goto bail;
 	}
 
-	lockres->l_flags &= ~USER_LOCK_ATTACHED;
 	lockres->l_flags |= USER_LOCK_BUSY;
 	spin_unlock(&lockres->l_lock);
 
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch

