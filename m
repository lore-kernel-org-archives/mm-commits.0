Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F3168C4
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473058; cv=none; b=QLUQOhYO+3Uue54BotnrW6j5bVVs5zU5cFeMq5Xj5sETGH2XMTOBL8kP1ZpVZPaM0G8nN/nncO665KdxWd88JzkMelFp3XddsEeIfgvpnxR584XwLZH2Fg3srE0FfvwgtpiewhzqwmHd2+ztItg92SxVHzzNIntRgz2OTesdHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473058; c=relaxed/simple;
	bh=RartfC9j1S709E7prAXYbhgtXOqOw2qtHqeHbYVg0iw=;
	h=Date:To:From:Subject:Message-Id; b=SatxpcAX6jhrnQUborn3WhVSPolnoBGvlb2ywxJGM/0TqilJCU+D2w/PmKQ3CGNAktZhX+Ucta9kat3rFs6kf83fWfevCQMNBhjQf8taKDsWewxe1PI3mn6GDl25mjUHycVqGthvDOp8bjm9jpIMVSXVOR/g7TloA7P6ov/OT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dhj/pmmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dhj/pmmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11EFC116B1;
	Sat, 15 Jun 2024 17:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473057;
	bh=RartfC9j1S709E7prAXYbhgtXOqOw2qtHqeHbYVg0iw=;
	h=Date:To:From:Subject:From;
	b=Dhj/pmmP/okr1r4cS15BYkV8p4hG4hINm2WsyOYRR5JQKfKSySDzBoV6CbZsC0CXR
	 vFxje/b4yM5rBR7JR1wZGOQubhjiDkNj/H2jkUwNi7h72T2s1Sx6A4CG1a5KPk4JDF
	 F0QRIGNASS/rDr9NMH1ZbtxzXB6Fp9vEeU07b8YM=
Date: Sat, 15 Jun 2024 10:37:37 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,pobrn@protonmail.com,keescook@chromium.org,jorgelo@chromium.org,hughd@google.com,dverkamp@chromium.org,dmitry.torokhov@gmail.com,david@readahead.eu,cyphar@cyphar.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch removed from -mm tree
Message-Id: <20240615173737.B11EFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v2.patch

This patch was dropped because it was folded into mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch

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
mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
proc-pid-smaps-add-mseal-info-for-vma.patch

