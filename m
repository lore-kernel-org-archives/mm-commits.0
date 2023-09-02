Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B98AC001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 23:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjIBXFj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 19:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjIBXFh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 19:05:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE7CFE
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 16:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CBD8CE08BE
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 23:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B663C433C8;
        Sat,  2 Sep 2023 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693695930;
        bh=Lp4/XjsPiEnt98+3Gbm4T8TzceNVExA6hQYePF2wCKo=;
        h=Date:To:From:Subject:From;
        b=p0tCr6z3rFiKjx90gSSutddFshSAOg70Yyrx7C7eSF8daHszC2/22l6zsC+6ZCjqy
         MhX3m4jzGFy4Wt8Qg2VOK4W5pbYpWIV427YsM45KXZZrYNLMQhGseagk3/86JdL6vl
         +ckWdpX9FOiehueB045Xu+NfpXwhtWgLATwCEMGY=
Date:   Sat, 02 Sep 2023 16:05:29 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, jeffxu@google.com, dverkamp@chromium.org,
        dtometzki@fedoraproject.org, cyphar@cyphar.com, brauner@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch added to mm-unstable branch
Message-Id: <20230902230530.6B663C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "memfd: improve userspace warnings for missing exec-related flags".
has been added to the -mm mm-unstable branch.  Its filename is
     revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "memfd: improve userspace warnings for missing exec-related flags".
Date: Sat Sep  2 03:59:31 PM PDT 2023

This warning is telling userspace developers to pass MFD_EXEC and
MFD_NOEXEC_SEAL to memfd_create().  Commit 434ed3350f57 ("memfd: improve
userspace warnings for missing exec-related flags") made the warning more
frequent and visible in the hope that this would accelerate the fixing of
errant userspace.

But the overall effect is to generate far too much dmesg noise.

Fixes: 434ed3350f57 memfd: improve userspace warnings for missing exec-related flags
Reported-by: Damian Tometzki <dtometzki@fedoraproject.org>
Closes: https://lkml.kernel.org/r/ZPFzCSIgZ4QuHsSC@fedora.fritz.box
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
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
revert-memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch

