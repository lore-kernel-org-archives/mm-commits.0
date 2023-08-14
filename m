Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A557C05052
	for <mm-commits@archiver.kernel.org>; Mon, 14 Aug 2023 19:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjHNT1A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Aug 2023 15:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjHNT0w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2023 15:26:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514309C
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 12:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08B86449B
        for <mm-commits@vger.kernel.org>; Mon, 14 Aug 2023 19:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29550C433C7;
        Mon, 14 Aug 2023 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692041208;
        bh=G/cPZCKU4o2zfTxCo8N/Wd+UoK8IY1cci2WuPKLLys0=;
        h=Date:To:From:Subject:From;
        b=MmKOOABjZqUL77hlD1d8PMWyEl27N/qNC+3LsSTC0sc6ms48N8tawidzFelTWHlyD
         tZ43atplYzht0yU26QJcmKicubMmMhO7QlZZSZFynH2PafnaEWqZx2tZFXB8zuE14/
         gmlnvfZfpByVyP8nFH9CRNKr7jD2pLJYCb2WBKmU=
Date:   Mon, 14 Aug 2023 12:26:45 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, jeffxu@google.com, dverkamp@chromium.org,
        brauner@kernel.org, asmadeus@codewreck.org, cyphar@cyphar.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-error-out-test-process-when-child-test-fails.patch added to mm-unstable branch
Message-Id: <20230814192648.29550C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: memfd: error out test process when child test fails
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-error-out-test-process-when-child-test-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-error-out-test-process-when-child-test-fails.patch

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
From: Aleksa Sarai <cyphar@cyphar.com>
Subject: selftests: memfd: error out test process when child test fails
Date: Mon, 14 Aug 2023 18:40:57 +1000

Patch series "memfd: cleanups for vm.memfd_noexec", v2.

The most critical issue with vm.memfd_noexec=2 (the fact that passing
MFD_EXEC would bypass it entirely[1]) has been fixed in Andrew's
tree[2], but there are still some outstanding issues that need to be
addressed:

 * vm.memfd_noexec=2 shouldn't reject old-style memfd_create(2) syscalls
   because it will make it far to difficult to ever migrate. Instead it
   should imply MFD_EXEC.

 * The dmesg warnings are pr_warn_once(), which on most systems means
   that they will be used up by systemd or some other boot process and
   userspace developers will never see it.

   - For the !(flags & (MFD_EXEC | MFD_NOEXEC_SEAL)) case, outputting a
     rate-limited message to the kernel log is necessary to tell
     userspace that they should add the new flags.

     Arguably the most ideal way to deal with the spam concern[3,4]
     while still prompting userspace to switch to the new flags would be
     to only log the warning once per task or something similar.
     However, adding something to task_struct for tracking this would be
     needless bloat for a single pr_warn_ratelimited().

     So just switch to pr_info_ratelimited() to avoid spamming the log
     with something that isn't a real warning. There's lots of
     info-level stuff in dmesg, it seems really unlikely that this
     should be an actual problem. Most programs are already switching to
     the new flags anyway.

   - For the vm.memfd_noexec=2 case, we need to log a warning for every
     failure because otherwise userspace will have no idea why their
     previously working program started returning -EACCES (previously
     -EINVAL) from memfd_create(2). pr_warn_once() is simply wrong here.

 * The racheting mechanism for vm.memfd_noexec makes it incredibly
   unappealing for most users to enable the sysctl because enabling it
   on &init_pid_ns means you need a system reboot to unset it. Given the
   actual security threat being protected against, CAP_SYS_ADMIN users
   being restricted in this way makes little sense.

   The argument for this ratcheting by the original author was that it
   allows you to have a hierarchical setting that cannot be unset by
   child pidnses, but this is not accurate -- changing the parent
   pidns's vm.memfd_noexec setting to be more restrictive didn't affect
   children.

   Instead, switch the vm.memfd_noexec sysctl to be properly
   hierarchical and allow CAP_SYS_ADMIN users (in the pidns's owning
   userns) to lower the setting as long as it is not lower than the
   parent's effective setting. This change also makes it so that
   changing a parent pidns's vm.memfd_noexec will affect all
   descendants, providing a properly hierarchical setting. The
   performance impact of this is incredibly minimal since the maximum
   depth of pidns is 32 and it is only checked during memfd_create(2)
   and unshare(CLONE_NEWPID).

 * The memfd selftests would not exit with a non-zero error code when
   certain tests that ran in a forked process (specifically the ones
   related to MFD_EXEC and MFD_NOEXEC_SEAL) failed.

[1]: https://lore.kernel.org/all/ZJwcsU0vI-nzgOB_@codewreck.org/
[2]: https://lore.kernel.org/all/20230705063315.3680666-1-jeffxu@google.com/
[3]: https://lore.kernel.org/Y5yS8wCnuYGLHMj4@x1n/
[4]: https://lore.kernel.org/f185bb42-b29c-977e-312e-3349eea15383@linuxfoundation.org/


This patch (of 5):

Before this change, a test runner using this self test would see a return
code of 0 when the tests using a child process (namely the MFD_NOEXEC_SEAL
and MFD_EXEC tests) failed, masking test failures.

Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-0-7ff9e3e10ba6@cyphar.com
Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-1-7ff9e3e10ba6@cyphar.com
Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-error-out-test-process-when-child-test-fails
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -1207,7 +1207,24 @@ static pid_t spawn_newpid_thread(unsigne
 
 static void join_newpid_thread(pid_t pid)
 {
-	waitpid(pid, NULL, 0);
+	int wstatus;
+
+	if (waitpid(pid, &wstatus, 0) < 0) {
+		printf("newpid thread: waitpid() failed: %m\n");
+		abort();
+	}
+
+	if (WIFEXITED(wstatus) && WEXITSTATUS(wstatus) != 0) {
+		printf("newpid thread: exited with non-zero error code %d\n",
+		       WEXITSTATUS(wstatus));
+		abort();
+	}
+
+	if (WIFSIGNALED(wstatus)) {
+		printf("newpid thread: killed by signal %d\n",
+		       WTERMSIG(wstatus));
+		abort();
+	}
 }
 
 /*
_

Patches currently in -mm which might be from cyphar@cyphar.com are

selftests-memfd-error-out-test-process-when-child-test-fails.patch
memfd-do-not-eacces-old-memfd_create-users-with-vmmemfd_noexec=2.patch
memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch
memfd-replace-ratcheting-feature-from-vmmemfd_noexec-with-hierarchy.patch
selftests-improve-vmmemfd_noexec-sysctl-tests.patch

