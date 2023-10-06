Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6408CE9412F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjJFVqo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbjJFVqo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:46:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7398EC6
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:46:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B92C433C7;
        Fri,  6 Oct 2023 21:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628802;
        bh=zl7rePgmCqcNMTrD7d44DIDJxdv8+YvzgCeIcf0Ari0=;
        h=Date:To:From:Subject:From;
        b=Dmr8nUg2uh3ZZzOaDcHPfRtlPq74lxjMWgrfo8Z8pdYsycMcjQKhlKDeid3u8t/VO
         0f60bCah2ZpK935CvgjyswC53ZABPLiXddJRnEk8zMNwwZn459DJ6xA/ho5+SwozXe
         0XVFTIyviAVbuXPdUXDGqgzHg/0FnfVRg54BFcfU=
Date:   Fri, 06 Oct 2023 14:46:37 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, keescook@chromium.org, sebott@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch removed from -mm tree
Message-Id: <20231006214640.E0B92C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix vm_brk_flags() to not bail out while holding lock
has been removed from the -mm tree.  Its filename was
     mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Ott <sebott@redhat.com>
Subject: mm: fix vm_brk_flags() to not bail out while holding lock
Date: Fri, 29 Sep 2023 10:19:41 -0700

Calling vm_brk_flags() with flags set other than VM_EXEC will exit the
function without releasing the mmap_write_lock.

Just do the sanity check before the lock is acquired.  This doesn't fix an
actual issue since no caller sets a flag other than VM_EXEC.

Link: https://lkml.kernel.org/r/20230929171937.work.697-kees@kernel.org
Fixes: 2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock
+++ a/mm/mmap.c
@@ -3143,13 +3143,13 @@ int vm_brk_flags(unsigned long addr, uns
 	if (!len)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
 	/* Until we need other flags, refuse anything except VM_EXEC. */
 	if ((flags & (~VM_EXEC)) != 0)
 		return -EINVAL;
 
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
 	ret = check_brk_limits(addr, len);
 	if (ret)
 		goto limits_failed;
_

Patches currently in -mm which might be from sebott@redhat.com are


