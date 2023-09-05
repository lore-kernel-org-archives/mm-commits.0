Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77DBCA100A
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 20:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbjIEUIk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 16:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbjIEUIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 16:08:39 -0400
X-Greylist: delayed 3696 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Sep 2023 13:08:36 PDT
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D89CC;
        Tue,  5 Sep 2023 13:08:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324E8C43395;
        Tue,  5 Sep 2023 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693937542;
        bh=Cyge68y4cOxdgZX5nOi6xxJiDLYqCX3/U9yRL+loHu4=;
        h=Date:To:From:Subject:From;
        b=crveIJDcgJdn0DLGGB27lvI8GuOW1yuLRi7ziEetgfx0wjJR/zl4/cmk1wSIHPtr1
         +zMfK353wbezWeJATf/kbXKRYuTOPxMcXbY3r3XAxse3Hwkn0+t6KH33zcwoaPvEKu
         7sERAk1EcrFJbno9aNqtJV/YHUEB4Wudyo31mWT4=
Date:   Tue, 05 Sep 2023 11:12:21 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, keescook@chromium.org, jeffxu@google.com,
        dverkamp@chromium.org, dtometzki@fedoraproject.org,
        cyphar@cyphar.com, brauner@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch removed from -mm tree
Message-Id: <20230905181222.324E8C43395@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: revert "memfd: improve userspace warnings for missing exec-related flags".
has been removed from the -mm tree.  Its filename was
     revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memfd: improve userspace warnings for missing exec-related flags".
Date: Sat Sep  2 03:59:31 PM PDT 2023

This warning is telling userspace developers to pass MFD_EXEC and
MFD_NOEXEC_SEAL to memfd_create().  Commit 434ed3350f57 ("memfd: improve
userspace warnings for missing exec-related flags") made the warning more
frequent and visible in the hope that this would accelerate the fixing of
errant userspace.

But the overall effect is to generate far too much dmesg noise.

Fixes: 434ed3350f57 ("memfd: improve userspace warnings for missing exec-related flags")
Reported-by: Damian Tometzki <dtometzki@fedoraproject.org>
Closes: https://lkml.kernel.org/r/ZPFzCSIgZ4QuHsSC@fedora.fritz.box
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags
+++ a/mm/memfd.c
@@ -316,7 +316,7 @@ SYSCALL_DEFINE2(memfd_create,
 		return -EINVAL;
 
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
-		pr_info_ratelimited(
+		pr_warn_once(
 			"%s[%d]: memfd_create() called without MFD_EXEC or MFD_NOEXEC_SEAL set\n",
 			current->comm, task_pid_nr(current));
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch

