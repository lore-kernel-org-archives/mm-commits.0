Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11BFC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 21:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLOVrb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 16:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLOVra (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 16:47:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E252D1C8
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 13:47:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C67ACB81BAD
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 21:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E819C433D2;
        Thu, 15 Dec 2022 21:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671140846;
        bh=W6PzmaRNVTTXTmRy2gGz688t7gbiAkHLgqqepZJOwsU=;
        h=Date:To:From:Subject:From;
        b=1qHq8Z8x9SQWqKc3dR2bVl0Csdema6zr061VRqxyAMIesr+vQKOlstrnkKqRXzpki
         6hjleAACRUkcE4pYUX/N4mat7wJicLsPEvGEfNEqKjIOk8UFDwsPOujEH6+knkSRTt
         3JG7FEXipe2D5e3urW/2maQt0aWa5M9iiXoATLBw=
Date:   Thu, 15 Dec 2022 13:47:25 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        lkp@intel.com, keescook@chromium.org, jorgelo@chromium.org,
        jeffxu@google.com, jannh@google.com, hughd@google.com,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        dverkamp@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-f_seal_exec.patch added to mm-unstable branch
Message-Id: <20221215214726.7E819C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memfd: add F_SEAL_EXEC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-f_seal_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-f_seal_exec.patch

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
From: Daniel Verkamp <dverkamp@chromium.org>
Subject: mm/memfd: add F_SEAL_EXEC
Date: Thu, 15 Dec 2022 00:12:01 +0000

Patch series "mm/memfd: introduce MFD_NOEXEC_SEAL and MFD_EXEC", v8.

Since Linux introduced the memfd feature, memfd have always had their
execute bit set, and the memfd_create() syscall doesn't allow setting it
differently.

However, in a secure by default system, such as ChromeOS, (where all
executables should come from the rootfs, which is protected by Verified
boot), this executable nature of memfd opens a door for NoExec bypass and
enables “confused deputy attack”.  E.g, in VRP bug [1]: cros_vm
process created a memfd to share the content with an external process,
however the memfd is overwritten and used for executing arbitrary code and
root escalation.  [2] lists more VRP in this kind.

On the other hand, executable memfd has its legit use, runc uses memfd’s
seal and executable feature to copy the contents of the binary then
execute them, for such system, we need a solution to differentiate runc's
use of executable memfds and an attacker's [3].

To address those above, this set of patches add following:
1> Let memfd_create() set X bit at creation time.
2> Let memfd to be sealed for modifying X bit.
3> A new pid namespace sysctl: vm.memfd_noexec to control the behavior of
   X bit.For example, if a container has vm.memfd_noexec=2, then
   memfd_create() without MFD_NOEXEC_SEAL will be rejected.
4> A new security hook in memfd_create(). This make it possible to a new
   LSM, which rejects or allows executable memfd based on its security policy.


This patch (of 5):

The new F_SEAL_EXEC flag will prevent modification of the exec bits:
written as traditional octal mask, 0111, or as named flags, S_IXUSR |
S_IXGRP | S_IXOTH.  Any chmod(2) or similar call that attempts to modify
any of these bits after the seal is applied will fail with errno EPERM.

This will preserve the execute bits as they are at the time of sealing, so
the memfd will become either permanently executable or permanently
un-executable.

Link: https://lkml.kernel.org/r/20221215001205.51969-1-jeffxu@google.com
Link: https://lkml.kernel.org/r/20221215001205.51969-2-jeffxu@google.com
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
Co-developed-by: Jeff Xu <jeffxu@google.com>
Signed-off-by: Jeff Xu <jeffxu@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/fcntl.h |    1 +
 mm/memfd.c                 |    2 ++
 mm/shmem.c                 |    6 ++++++
 3 files changed, 9 insertions(+)

--- a/include/uapi/linux/fcntl.h~mm-memfd-add-f_seal_exec
+++ a/include/uapi/linux/fcntl.h
@@ -43,6 +43,7 @@
 #define F_SEAL_GROW	0x0004	/* prevent file from growing */
 #define F_SEAL_WRITE	0x0008	/* prevent writes */
 #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
+#define F_SEAL_EXEC	0x0020  /* prevent chmod modifying exec bits */
 /* (1U << 31) is reserved for signed error codes */
 
 /*
--- a/mm/memfd.c~mm-memfd-add-f_seal_exec
+++ a/mm/memfd.c
@@ -147,6 +147,7 @@ static unsigned int *memfd_file_seals_pt
 }
 
 #define F_ALL_SEALS (F_SEAL_SEAL | \
+		     F_SEAL_EXEC | \
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE | \
@@ -175,6 +176,7 @@ static int memfd_add_seals(struct file *
 	 *   SEAL_SHRINK: Prevent the file from shrinking
 	 *   SEAL_GROW: Prevent the file from growing
 	 *   SEAL_WRITE: Prevent write access to the file
+	 *   SEAL_EXEC: Prevent modification of the exec bits in the file mode
 	 *
 	 * As we don't require any trust relationship between two parties, we
 	 * must prevent seals from being removed. Therefore, sealing a file
--- a/mm/shmem.c~mm-memfd-add-f_seal_exec
+++ a/mm/shmem.c
@@ -1095,6 +1095,12 @@ static int shmem_setattr(struct user_nam
 	if (error)
 		return error;
 
+	if ((info->seals & F_SEAL_EXEC) && (attr->ia_valid & ATTR_MODE)) {
+		if ((inode->i_mode ^ attr->ia_mode) & 0111) {
+			return -EPERM;
+		}
+	}
+
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
_

Patches currently in -mm which might be from dverkamp@chromium.org are

mm-memfd-add-f_seal_exec.patch
selftests-memfd-add-tests-for-f_seal_exec.patch

