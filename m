Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E00BC761A6
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 19:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbjDDToE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbjDDToD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2023 15:44:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D949C5
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 12:44:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9900637CA
        for <mm-commits@vger.kernel.org>; Tue,  4 Apr 2023 19:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E663C433EF;
        Tue,  4 Apr 2023 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680637441;
        bh=Wm6jFC6cdcFTqDlsZVR8E1Crb3uS+kZHRrolEMwjALg=;
        h=Date:To:From:Subject:From;
        b=mRtko78dYT1a2s8s+Wpi0QvccCNmAaLXvsdh1z2OwmVwyjS5x5MrCldvjXZZ8blD+
         OF++0KBx+iGxV7yqrWaLdnpfhvhQCx3EEoLOXB/hrJdaUfAJUDjReM56sLDL9lbTSj
         gXArewVTnwAgx6pr9mAdBkipjmuwN4nJxoxR3lLA=
Date:   Tue, 04 Apr 2023 12:44:00 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch added to mm-nonmm-unstable branch
Message-Id: <20230404194401.2E663C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: add PR_GET_AUXV to copy auxv to userspace
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Josh Triplett <josh@joshtriplett.org>
Subject: prctl: add PR_GET_AUXV to copy auxv to userspace
Date: Tue, 4 Apr 2023 21:31:48 +0900

If a library wants to get information from auxv (for instance,
AT_HWCAP/AT_HWCAP2), it has a few options, none of them perfectly reliable
or ideal:

- Be main or the pre-main startup code, and grub through the stack above
  main. Doesn't work for a library.
- Call libc getauxval. Not ideal for libraries that are trying to be
  libc-independent and/or don't otherwise require anything from other
  libraries.
- Open and read /proc/self/auxv. Doesn't work for libraries that may run
  in arbitrarily constrained environments that may not have /proc
  mounted (e.g. libraries that might be used by an init program or a
  container setup tool).
- Assume you're on the main thread and still on the original stack, and
  try to walk the stack upwards, hoping to find auxv. Extremely bad
  idea.
- Ask the caller to pass auxv in for you. Not ideal for a user-friendly
  library, and then your caller may have the same problem.

Add a prctl that copies current->mm->saved_auxv to a userspace buffer.

Link: https://lkml.kernel.org/r/d81864a7f7f43bca6afa2a09fc2e850e4050ab42.1680611394.git.josh@joshtriplett.org
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/sys.c~prctl-add-pr_get_auxv-to-copy-auxv-to-userspace
+++ a/kernel/sys.c
@@ -2389,6 +2389,16 @@ static inline int prctl_get_mdwe(unsigne
 		PR_MDWE_REFUSE_EXEC_GAIN : 0;
 }
 
+static int prctl_get_auxv(void __user *addr, unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long size = min_t(unsigned long, sizeof(mm->saved_auxv), len);
+
+	if (size && copy_to_user(addr, mm->saved_auxv, size))
+		return -EFAULT;
+	return sizeof(mm->saved_auxv);
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2519,6 +2529,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				return -EINVAL;
 			break;
+	case PR_GET_AUXV:
+		if (arg4 || arg5)
+			return -EINVAL;
+		error = prctl_get_auxv((void __user *)arg2, arg3);
+		break;
 		default:
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from josh@joshtriplett.org are

prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch

