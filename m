Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA02C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbjHKXAL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjHKW7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6493A8F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D8965772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53AAC433C8;
        Fri, 11 Aug 2023 22:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794764;
        bh=Ta+OLts7fYjBNH+Kgx40+dmTRbIGNsgGnAjTH0QCieA=;
        h=Date:To:From:Subject:From;
        b=F1jQmdvzttdRFap5jk5qo5rK3aTmWB3HjJVuZ0hg1wMtwMKpugdwUJozM1RIbboyH
         LMexTh444kGYRrGl4T/5896GPcoMkUdY9a581Ap3axW4/KtOaivpKPufXEKPDFGob2
         kCNpKSewxAWaUfugsXi+E8Xec/8KaNZBHkgYXlYQ=
Date:   Fri, 11 Aug 2023 15:59:24 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        mike.kravetz@oracle.com, lkp@intel.com, keescook@chromium.org,
        jorgelo@chromium.org, jannh@google.com, hughd@google.com,
        dverkamp@chromium.org, dmitry.torokhov@gmail.com,
        asmadeus@codewreck.org, jeffxu@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch removed from -mm tree
Message-Id: <20230811225924.A53AAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memfd: sysctl: fix MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
has been removed from the -mm tree.  Its filename was
     mm-memfd-sysctl-fix-memfd_noexec_scope_noexec_enforced.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


