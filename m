Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618DFC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 18:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241144AbiESS4d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 14:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiESS4c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 14:56:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0AC62126
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 11:56:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21107B827EB
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 18:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF06BC385AA;
        Thu, 19 May 2022 18:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652986588;
        bh=q58ebU4DqQJqrIfKSe6LdHqQemMFaajbYh7hT/Jp7/A=;
        h=Date:To:From:Subject:From;
        b=eZpKfXOg2ed1DniiDrBjrfM0MiqgZhwV5HLNUFkU3W9S5rASHhKheyTfo8Fo02JJu
         A8Rt47rsRNCHmhLimJcQhR65UnWOCBfKLFsK/yY6mJKGcn2gryb30zRzeyPE02a43t
         ByT9Kuu+2KloLufUG1ohcnYwYyIXz7GwQMf1A9hg=
Date:   Thu, 19 May 2022 11:56:27 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch added to mm-nonmm-unstable branch
Message-Id: <20220519185628.BF06BC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlmfs: don't clear USER_LOCK_ATTACHED when destroying lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch

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

ocfs2-dlmfs-not-clear-user_lock_attached-when-destroy-lock.patch
ocfs2-dlmfs-fix-error-handling-of-user_dlm_destroy_lock.patch

