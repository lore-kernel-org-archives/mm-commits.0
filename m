Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B13A7350E
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 20:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718137521; cv=none; b=Ak3xyjPJhRV8dT5kL/R8G6wAfmNo9BGTxe8spmUBpnoreJ447pGYwrIgZvC4xRE7LR36sBmpbqQl+2V9X0+xsPCSfMKgBSbnUTfbcW3kj5paejSXHkxof58gSz61kCc2Kpb9zHaPFVIN521AGg7kYU7FcYVIJDeeueBJQaUEefU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718137521; c=relaxed/simple;
	bh=huUzlSNNsLNGvO0mPg3k/NWR3lzTvI0rQNiWirn2e2Y=;
	h=Date:To:From:Subject:Message-Id; b=moDalK04bOehj9admDsWiUPouUDNAYZu3kxcvZWmSAaZNqdsRsPJKY9+Pyp86lkIGS3Fvs1/SvGNfcv5sPz0pX8/AEX0US0hoRbu+NK1iv6ah/FR3ZFKA1KxMWbeflzc8TeIljAmgNr8SgheHFCJDdxGWbRKiUh2p58RzeL0PDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lP6Vs2BQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lP6Vs2BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E70C2BD10;
	Tue, 11 Jun 2024 20:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718137520;
	bh=huUzlSNNsLNGvO0mPg3k/NWR3lzTvI0rQNiWirn2e2Y=;
	h=Date:To:From:Subject:From;
	b=lP6Vs2BQQftck3XfLurY5j12B69Ak7US6MQjZxyiDQXFz3F45nVBQESwRBaY1nmq2
	 nIU3wBefu25miteNB+i0v/6lDIswcckjG8JocNrS8g5o7l3smxvg+jYZhdNIih55F0
	 JBzEO5WUKXdruXk6BVls8OBl1jTKjsBBxPdGzAjY=
Date: Tue, 11 Jun 2024 13:25:20 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,pobrn@protonmail.com,keescook@chromium.org,jorgelo@chromium.org,hughd@google.com,dverkamp@chromium.org,dmitry.torokhov@gmail.com,david@readahead.eu,cyphar@cyphar.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240611202520.B2E70C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch

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
From: Jeff Xu <jeffxu@chromium.org>
Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2
Date: Tue, 11 Jun 2024 03:49:01 +0000

updates per Randy

Link: https://lkml.kernel.org/r/20240611034903.3456796-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Barnabás Pőcze <pobrn@protonmail.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: David Rheinsberg <david@readahead.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mfd_noexec.rst |   30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/Documentation/userspace-api/mfd_noexec.rst~mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2
+++ a/Documentation/userspace-api/mfd_noexec.rst
@@ -10,27 +10,27 @@ Introduction of non executable mfd
 :Contributor:
 	Aleksa Sarai <cyphar@cyphar.com>
 
-Since Linux introduced the memfd feature, memfd have always had their
+Since Linux introduced the memfd feature, memfds have always had their
 execute bit set, and the memfd_create() syscall doesn't allow setting
 it differently.
 
-However, in a secure by default system, such as ChromeOS, (where all
-executables should come from the rootfs, which is protected by Verified
+However, in a secure-by-default system, such as ChromeOS, (where all
+executables should come from the rootfs, which is protected by verified
 boot), this executable nature of memfd opens a door for NoExec bypass
 and enables “confused deputy attack”.  E.g, in VRP bug [1]: cros_vm
 process created a memfd to share the content with an external process,
 however the memfd is overwritten and used for executing arbitrary code
-and root escalation. [2] lists more VRP in this kind.
+and root escalation. [2] lists more VRP of this kind.
 
-On the other hand, executable memfd has its legit use, runc uses memfd’s
+On the other hand, executable memfd has its legit use: runc uses memfd’s
 seal and executable feature to copy the contents of the binary then
-execute them, for such system, we need a solution to differentiate runc's
-use of  executable memfds and an attacker's [3].
+execute them. For such a system, we need a solution to differentiate runc's
+use of executable memfds and an attacker's [3].
 
-To address those above.
+To address those above:
  - Let memfd_create() set X bit at creation time.
  - Let memfd be sealed for modifying X bit when NX is set.
- - A new pid namespace sysctl: vm.memfd_noexec to help applications to
+ - Add a new pid namespace sysctl: vm.memfd_noexec to help applications to
    migrating and enforcing non-executable MFD.
 
 User API
@@ -48,7 +48,7 @@ User API
 
 Note:
 	``MFD_NOEXEC_SEAL`` implies ``MFD_ALLOW_SEALING``. In case that
-	app doesn't want sealing, it can add F_SEAL_SEAL after creation.
+	an app doesn't want sealing, it can add F_SEAL_SEAL after creation.
 
 
 Sysctl:
@@ -68,14 +68,14 @@ The new pid namespaced sysctl vm.memfd_n
  - 2: MEMFD_NOEXEC_SCOPE_NOEXEC_ENFORCED
 	memfd_create() without MFD_NOEXEC_SEAL will be rejected.
 
-The sysctl allows finer control of memfd_create for old-software that
-doesn't set the executable bit, for example, a container with
-vm.memfd_noexec=1 means the old-software will create non-executable memfd
-by default while new-software can create executable memfd by setting
+The sysctl allows finer control of memfd_create for old software that
+doesn't set the executable bit; for example, a container with
+vm.memfd_noexec=1 means the old software will create non-executable memfd
+by default while new software can create executable memfd by setting
 MFD_EXEC.
 
 The value of vm.memfd_noexec is passed to child namespace at creation
-time, in addition, the setting is hierarchical, i.e. during memfd_create,
+time. In addition, the setting is hierarchical, i.e. during memfd_create,
 we will search from current ns to root ns and use the most restrictive
 setting.
 
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch

