Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EEEEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjHUUoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjHUUnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F91992
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB3A464B31
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D51C433C7;
        Mon, 21 Aug 2023 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650513;
        bh=TNPoeGM2NMpt/meABfvIoYOLQ2egrieC7F32B89cZ+k=;
        h=Date:To:From:Subject:From;
        b=jgogs7UVu85AwCTWebh7rgAirGa37UZFK1v8GRUn+ylTka3hRPSCC9Q/8i4SwyAgF
         Cb0K5gYIYNgvu6hmrie8PiSiRRE9y+9EXndAwRgwD+owd18+12MDr4jTJmLG304Eu+
         BUa4dTFG5RCERJtB4UsnUsI6cL/MaVHnGsPzqnJ0=
Date:   Mon, 21 Aug 2023 13:41:52 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        keescook@chromium.org, jeffxu@google.com, dverkamp@chromium.org,
        brauner@kernel.org, asmadeus@codewreck.org, cyphar@cyphar.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-error-out-test-process-when-child-test-fails.patch removed from -mm tree
Message-Id: <20230821204153.27D51C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: memfd: error out test process when child test fails
has been removed from the -mm tree.  Its filename was
     selftests-memfd-error-out-test-process-when-child-test-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


