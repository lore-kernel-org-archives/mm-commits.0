Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B0CEB64DA
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jul 2023 15:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjGEPiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjGEPiy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 11:38:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B77B10F7
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 08:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26DF26154F
        for <mm-commits@vger.kernel.org>; Wed,  5 Jul 2023 15:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799D2C433C8;
        Wed,  5 Jul 2023 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688571529;
        bh=KcNa+Yl6kS3GYIsA+2Lu8eS7uxh62qBYIH/gacEmZDM=;
        h=Date:To:From:Subject:From;
        b=nxU+f5pNIBEkcLMR5WUP+SlsqOOMOr9Gq+vOWbyNGcdbO0rGRLcKASxIO7IxNrh1Z
         K7oJ7qRMqPyJYJ9YU7NfaYG1g5C4kNJV6Y7cq+lfvR/1qoeLoRUkSlH2zv1mPtKZHT
         TutL71Qqi9/iNkjTK2yld8L3mdlnerpNdE5Cl1yg=
Date:   Wed, 05 Jul 2023 08:38:48 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        mike.kravetz@oracle.com, lkp@intel.com, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        asmadeus@codewreck.org, jeffxu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch added to mm-unstable branch
Message-Id: <20230705153849.799D2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

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
From: Jeff Xu <jeffxu@google.com>
Subject: mm/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
Date: Wed, 5 Jul 2023 06:33:14 +0000

Patch series "mm/memfd: fix sysctl MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED", v2.

When sysctl vm.memfd_noexec is 2 (MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED),
memfd_create(.., MFD_EXEC) should fail.

This complies with how MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED is defined -
"memfd_create() without MFD_NOEXEC_SEAL will be rejected"

Thanks to Dominique Martinet <asmadeus@codewreck.org> who reported the bug.
see [1] for context.

[1] https://lore.kernel.org/linux-mm/CABi2SkXUX_QqTQ10Yx9bBUGpN1wByOi_=gZU6WEy5a8MaQY3Jw@mail.gmail.com/T/


This patch (of 2):

When vm.memfd_noexec is 2 (MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED),
memfd_create(.., MFD_EXEC) should fail.

This complies with how MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED is
defined - "memfd_create() without MFD_NOEXEC_SEAL will be rejected"

Link: https://lkml.kernel.org/r/20230705063315.3680666-1-jeffxu@google.com
Link: https://lkml.kernel.org/r/20230705063315.3680666-2-jeffxu@google.com
Fixes: 105ff5339f49 ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
Reported-by: Dominique Martinet <asmadeus@codewreck.org>
Closes: https://lore.kernel.org/linux-mm/CABi2SkXUX_QqTQ10Yx9bBUGpN1wByOi_=gZU6WEy5a8MaQY3Jw@mail.gmail.com/T/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306301351.kkbSegQW-lkp@intel.com/
Signed-off-by: Jeff Xu <jeffxu@google.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   57 +++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

--- a/mm/memfd.c~mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced
+++ a/mm/memfd.c
@@ -268,6 +268,36 @@ long memfd_fcntl(struct file *file, unsi
 
 #define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
 
+static int check_sysctl_memfd_noexec(unsigned int *flags)
+{
+#ifdef CONFIG_SYSCTL
+	char comm[TASK_COMM_LEN];
+	int sysctl = MEMFD_NOEXEC_SCOPE_EXEC;
+	struct pid_namespace *ns;
+
+	ns = task_active_pid_ns(current);
+	if (ns)
+		sysctl = ns->memfd_noexec_scope;
+
+	if (!(*flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
+		if (sysctl == MEMFD_NOEXEC_SCOPE_NOEXEC_SEAL)
+			*flags |= MFD_NOEXEC_SEAL;
+		else
+			*flags |= MFD_EXEC;
+	}
+
+	if (*flags & MFD_EXEC && sysctl >= MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED) {
+		pr_warn_once(
+			"memfd_create(): MFD_NOEXEC_SEAL is enforced, pid=%d '%s'\n",
+			task_pid_nr(current), get_task_comm(comm, current));
+
+		return -EACCES;
+	}
+#endif
+
+	return 0;
+}
+
 SYSCALL_DEFINE2(memfd_create,
 		const char __user *, uname,
 		unsigned int, flags)
@@ -294,35 +324,14 @@ SYSCALL_DEFINE2(memfd_create,
 		return -EINVAL;
 
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
-#ifdef CONFIG_SYSCTL
-		int sysctl = MEMFD_NOEXEC_SCOPE_EXEC;
-		struct pid_namespace *ns;
-
-		ns = task_active_pid_ns(current);
-		if (ns)
-			sysctl = ns->memfd_noexec_scope;
-
-		switch (sysctl) {
-		case MEMFD_NOEXEC_SCOPE_EXEC:
-			flags |= MFD_EXEC;
-			break;
-		case MEMFD_NOEXEC_SCOPE_NOEXEC_SEAL:
-			flags |= MFD_NOEXEC_SEAL;
-			break;
-		default:
-			pr_warn_once(
-				"memfd_create(): MFD_NOEXEC_SEAL is enforced, pid=%d '%s'\n",
-				task_pid_nr(current), get_task_comm(comm, current));
-			return -EINVAL;
-		}
-#else
-		flags |= MFD_EXEC;
-#endif
 		pr_warn_once(
 			"memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=%d '%s'\n",
 			task_pid_nr(current), get_task_comm(comm, current));
 	}
 
+	if (check_sysctl_memfd_noexec(&flags) < 0)
+		return -EACCES;
+
 	/* length includes terminating zero */
 	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
 	if (len <= 0)
_

Patches currently in -mm which might be from jeffxu@google.com are

mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch
selftests-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

