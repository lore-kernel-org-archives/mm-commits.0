Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7BFC01
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820706; cv=none; b=HD2b68HA5kyG/p0qKf9TnxvUW+Ot9DxJ2kncEGmIfdOp7/KhQnH+amOUaod7hwBFFI4HO46X/xuGVaw8YmMyofTYmWGB/uoX6qhDDa/P9QlxfrLvuRzumreND49fSitEJJxSbNuuNileGLlyWRG8DECQQcC1YlrBzfe8DjLHkR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820706; c=relaxed/simple;
	bh=hTCV1znfVgMrZ6+Jf7hTcUA9zMOnL4ScGuHrXfWAeMw=;
	h=Date:To:From:Subject:Message-Id; b=FOHEb/LtKfX6BvSUpXcq543I/LNtzm2Y0oNMOSg0HIB80do6ZhuxhTeCfGX8bNHnoJAef+yj9siAVo8z8eeA6RckcyFJGEePWUghjQg0Fz0sLrB+jB6lP1VPCzU4YgLtpkfC+T8TyicIykFSqKTkCLTlaRC9sxuBqXzrPDJ4pS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kt5o0zDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kt5o0zDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F265C2BD11;
	Sat,  8 Jun 2024 04:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717820706;
	bh=hTCV1znfVgMrZ6+Jf7hTcUA9zMOnL4ScGuHrXfWAeMw=;
	h=Date:To:From:Subject:From;
	b=Kt5o0zDMuGBzVanISP1ZEPywamdNtkm4XbuxN6IrWGcvzyfM9JHpbv3besunkIW5F
	 gQtfSL6Vwlcr+2ak81SiniKEahg3o51jGcMf9T8aAFG07rDvRc/WtfqHzzvl1CJYpl
	 Juktnrk/50UzRw2Q6rXsOZFcrk3RCwnjkyubYqSM=
Date: Fri, 07 Jun 2024 21:25:05 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,pobrn@protonmail.com,keescook@chromium.org,jorgelo@chromium.org,hughd@google.com,dverkamp@chromium.org,dmitry.torokhov@gmail.com,david@readahead.eu,cyphar@cyphar.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch added to mm-unstable branch
Message-Id: <20240608042506.1F265C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: add documentation for MFD_NOEXEC_SEAL MFD_EXEC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: mm/memfd: add documentation for MFD_NOEXEC_SEAL MFD_EXEC
Date: Fri, 7 Jun 2024 20:35:41 +0000

Add documentation for memfd_create flags: FMD_NOEXEC_SEAL and MFD_EXEC

Link: https://lkml.kernel.org/r/20240607203543.2151433-2-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Barnabás Pőcze <pobrn@protonmail.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: David Rheinsberg <david@readahead.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/index.rst      |    1 
 Documentation/userspace-api/mfd_noexec.rst |   86 +++++++++++++++++++
 2 files changed, 87 insertions(+)

--- a/Documentation/userspace-api/index.rst~mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec
+++ a/Documentation/userspace-api/index.rst
@@ -32,6 +32,7 @@ Security-related interfaces
    seccomp_filter
    landlock
    lsm
+   mfd_noexec
    spec_ctrl
    tee
 
--- /dev/null
+++ a/Documentation/userspace-api/mfd_noexec.rst
@@ -0,0 +1,86 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Introduction of non executable mfd
+==================================
+:Author:
+    Daniel Verkamp <dverkamp@chromium.org>
+    Jeff Xu <jeffxu@chromium.org>
+
+:Contributor:
+	Aleksa Sarai <cyphar@cyphar.com>
+
+Since Linux introduced the memfd feature, memfd have always had their
+execute bit set, and the memfd_create() syscall doesn't allow setting
+it differently.
+
+However, in a secure by default system, such as ChromeOS, (where all
+executables should come from the rootfs, which is protected by Verified
+boot), this executable nature of memfd opens a door for NoExec bypass
+and enables “confused deputy attack”.  E.g, in VRP bug [1]: cros_vm
+process created a memfd to share the content with an external process,
+however the memfd is overwritten and used for executing arbitrary code
+and root escalation. [2] lists more VRP in this kind.
+
+On the other hand, executable memfd has its legit use, runc uses memfd’s
+seal and executable feature to copy the contents of the binary then
+execute them, for such system, we need a solution to differentiate runc's
+use of  executable memfds and an attacker's [3].
+
+To address those above.
+ - Let memfd_create() set X bit at creation time.
+ - Let memfd be sealed for modifying X bit when NX is set.
+ - A new pid namespace sysctl: vm.memfd_noexec to help applications to
+   migrating and enforcing non-executable MFD.
+
+User API
+========
+``int memfd_create(const char *name, unsigned int flags)``
+
+``MFD_NOEXEC_SEAL``
+	When MFD_NOEXEC_SEAL bit is set in the ``flags``, memfd is created
+	with NX. F_SEAL_EXEC is set and the memfd can't be modified to
+	add X later. MFD_ALLOW_SEALING is also implied.
+	This is the most common case for the application to use memfd.
+
+``MFD_EXEC``
+	When MFD_EXEC bit is set in the ``flags``, memfd is created with X.
+
+Note:
+	``MFD_NOEXEC_SEAL`` implies ``MFD_ALLOW_SEALING``. In case that
+	app doesn't want sealing, it can add F_SEAL_SEAL after creation.
+
+
+Sysctl:
+========
+``pid namespaced sysctl vm.memfd_noexec``
+
+The new pid namespaced sysctl vm.memfd_noexec has 3 values:
+
+ - 0: MEMFD_NOEXEC_SCOPE_EXEC
+	memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL acts like
+	MFD_EXEC was set.
+
+ - 1: MEMFD_NOEXEC_SCOPE_NOEXEC_SEAL
+	memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL acts like
+	MFD_NOEXEC_SEAL was set.
+
+ - 2: MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
+	memfd_create() without MFD_NOEXEC_SEAL will be rejected.
+
+The sysctl allows finer control of memfd_create for old-software that
+doesn't set the executable bit, for example, a container with
+vm.memfd_noexec=1 means the old-software will create non-executable memfd
+by default while new-software can create executable memfd by setting
+MFD_EXEC.
+
+The value of vm.memfd_noexec is passed to child namespace at creation
+time, in addition, the setting is hierarchical, i.e. during memfd_create,
+we will search from current ns to root ns and use the most restrictive
+setting.
+
+[1] https://crbug.com/1305267
+
+[2] https://bugs.chromium.org/p/chromium/issues/list?q=type%3Dbug-security%20memfd%20escalation&can=1
+
+[3] https://lwn.net/Articles/781013/
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch

