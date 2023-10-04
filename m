Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF36AE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244087AbjJDUS5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244080AbjJDUSv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FA0E5
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D1BC433C8;
        Wed,  4 Oct 2023 20:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450725;
        bh=vYpIReTd16yUdM/sR1KVfr2vhn+l/c9xJU4GiEntgJk=;
        h=Date:To:From:Subject:From;
        b=m0llZyAQYFgRhkpY0t+mPRVBvdvbDmleR2nYFjBDFPdbHK3ZWQEVD2zAwrrPJoTYf
         U2+M3QShHrzf7H3wY0Cyzs8FO+kqU74WYOtjYBkeldJdoj7AoXgsF01b6FDQV14xsM
         a0bTHptwKSdNhJQQ/FMPGooBPklIlyUXY6wD9gK4=
Date:   Wed, 04 Oct 2023 13:18:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, jeffxu@google.com, dverkamp@chromium.org,
        dtometzki@fedoraproject.org, brauner@kernel.org, cyphar@cyphar.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memfd-drop-warning-for-missing-exec-related-flags.patch removed from -mm tree
Message-Id: <20231004201845.43D1BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memfd: drop warning for missing exec-related flags
has been removed from the -mm tree.  Its filename was
     memfd-drop-warning-for-missing-exec-related-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aleksa Sarai <cyphar@cyphar.com>
Subject: memfd: drop warning for missing exec-related flags
Date: Tue, 12 Sep 2023 01:17:20 +1000

Commit 434ed3350f57 ("memfd: improve userspace warnings for missing
exec-related flags") attempted to make these warnings more useful (so
they would work as an incentive to get users to switch to specifying
these flags -- as intended by the original MFD_NOEXEC_SEAL patchset).
Unfortunately, it turns out that even INFO-level logging is too extreme
to enable by default and alternative solutions to the spam issue (such
as doing more extreme rate-limiting per-task) are either too ugly or
overkill for something as simple as emitting a log as a developer aid.

Given that the flags are new and there is no harm to not specifying them
(after all, we maintain backwards compatibility) we can just drop the
warnings for now until some time in the future when most programs have
migrated and distributions start using vm.memfd_noexec=1 (where failing
to pass the flag would result in unexpected errors for programs that use
executable memfds).

Link: https://lkml.kernel.org/r/20230912-memfd-reduce-spam-v2-1-7d92a4964b6a@cyphar.com
Fixes: 434ed3350f57 ("memfd: improve userspace warnings for missing exec-related flags")
Fixes: 2562d67b1bdf ("revert "memfd: improve userspace warnings for missing exec-related flags".")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Reported-by: Damian Tometzki <dtometzki@fedoraproject.org>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/memfd.c~memfd-drop-warning-for-missing-exec-related-flags
+++ a/mm/memfd.c
@@ -315,12 +315,6 @@ SYSCALL_DEFINE2(memfd_create,
 	if ((flags & MFD_EXEC) && (flags & MFD_NOEXEC_SEAL))
 		return -EINVAL;
 
-	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
-		pr_warn_once(
-			"%s[%d]: memfd_create() called without MFD_EXEC or MFD_NOEXEC_SEAL set\n",
-			current->comm, task_pid_nr(current));
-	}
-
 	error = check_sysctl_memfd_noexec(&flags);
 	if (error < 0)
 		return error;
_

Patches currently in -mm which might be from cyphar@cyphar.com are


