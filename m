Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3160EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 02:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiCZCHW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 22:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCZCHW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 22:07:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D66D1D315
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 19:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFC23CE2BEF
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 02:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2004C004DD;
        Sat, 26 Mar 2022 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648260342;
        bh=hDBaAnu/CxrnL+KGftHwnhHz8qrvHz6GKIZcHn6vf7Q=;
        h=Date:To:From:Subject:From;
        b=Xl14dWmZkAn/u1cq/CSXK7Zrw+u9RopPZalT8Jw9XJXyoi2k0kjP8MByPwtXKrDc2
         5/FYkNJTvyt1GR1+7nE5Opa2qeilLtQN5qeUV4bBf9yCYvm1kCv0dUVBLCDOHwjFTg
         rGbZEQ/OwuAOujFDN7h4FbX+Cw6ep/yBl/N9LkX0=
Date:   Fri, 25 Mar 2022 19:05:42 -0700
To:     mm-commits@vger.kernel.org, legion@kernel.org, hughd@google.com,
        ebiederm@xmission.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-fix-two-bugs-in-user_shm_lock.patch added to -mm tree
Message-Id: <20220326020542.D2004C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock: fix two bugs in user_shm_lock()
has been added to the -mm tree.  Its filename is
     mm-mlock-fix-two-bugs-in-user_shm_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-fix-two-bugs-in-user_shm_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-fix-two-bugs-in-user_shm_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mlock: fix two bugs in user_shm_lock()

user_shm_lock forgets to set allowed to 0 when get_ucounts fails.  So the
later user_shm_unlock might do the extra dec_rlimit_ucounts.  Also in the
RLIM_INFINITY case, user_shm_lock will success regardless of the value of
memlock where memblock == LONG_MAX && !capable(CAP_IPC_LOCK) should fail. 
Fix all of these by changing the code to leave lock_limit at ULONG_MAX aka
RLIM_INFINITY, leave "allowed" initialized to 0 and remove the special
case of RLIM_INFINITY as nothing can be greater than ULONG_MAX.

Credit goes to Eric W.  Biederman for proposing simplifying the code and
thus catching the later bug.

Link: https://lkml.kernel.org/r/20220322080918.59861-1-linmiaohe@huawei.com
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/mlock.c~mm-mlock-fix-two-bugs-in-user_shm_lock
+++ a/mm/mlock.c
@@ -721,13 +721,12 @@ int user_shm_lock(size_t size, struct uc
 
 	locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	lock_limit = rlimit(RLIMIT_MEMLOCK);
-	if (lock_limit == RLIM_INFINITY)
-		allowed = 1;
-	lock_limit >>= PAGE_SHIFT;
+	if (lock_limit != RLIM_INFINITY)
+		lock_limit >>= PAGE_SHIFT;
 	spin_lock(&shmlock_user_lock);
 	memlock = inc_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 
-	if (!allowed && (memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((memlock == LONG_MAX || memlock > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
 		goto out;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-compaction-use-helper-isolation_suitable.patch

