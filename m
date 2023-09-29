Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84DEE728CC
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 17:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjI2RjO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 13:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjI2RjN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 13:39:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764A19F
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 10:39:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61981C433C8;
        Fri, 29 Sep 2023 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696009151;
        bh=cKxsvcD7/yc0f+KAuLklwKcvnjBiAGW/D+AutfDHOgw=;
        h=Date:To:From:Subject:From;
        b=uxZi546QA/qKCVKI876WlZIXzmz7WjcaCCG17LunUgx4ZYEqq8KBH3/GXOxkmaUH0
         C/wut/pJKCch0YLz24LbvOVMPIY29uVAGA5oc1omyMXD518QPm89zOQ2l4ejFK4wst
         xbLT4pS3FT8URFY5irGWIcuDRo94EyoSyWIgL6W8=
Date:   Fri, 29 Sep 2023 10:39:10 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@Oracle.com, keescook@chromium.org, sebott@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20230929173911.61981C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix vm_brk_flags() to not bail out while holding lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock
+++ a/mm/mmap.c
@@ -3157,13 +3157,13 @@ int vm_brk_flags(unsigned long addr, uns
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

mm-fix-vm_brk_flags-to-not-bail-out-while-holding-lock.patch

