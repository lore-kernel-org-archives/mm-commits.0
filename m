Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6DEC6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjDRXfw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0B1AF06
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D1B661528
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D96C433D2;
        Tue, 18 Apr 2023 23:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860863;
        bh=vrzhrTx7Wi+z6olEd26RzldMJ4XkN0JCoAv9gApqccA=;
        h=Date:To:From:Subject:From;
        b=oRiEwZLvtJs4Rjf/SfAMlA3W5LkPd8pVpCpTl/CHObI04ZTp6Um+UKD/7oaRxQk1p
         2qNm0cKDs0MSRp1gPWEoBwvEAPW6ehZuSCNnkVIRNF5yo7itF5jY5FewJWX0quAjMo
         R8wV//wYugaKAgRb1Ep7YADwe1WfSLNrwKObxHnY=
Date:   Tue, 18 Apr 2023 16:34:22 -0700
To:     mm-commits@vger.kernel.org, josh@joshtriplett.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch removed from -mm tree
Message-Id: <20230418233423.02D96C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: prctl: add PR_GET_AUXV to copy auxv to userspace
has been removed from the -mm tree.  Its filename was
     prctl-add-pr_get_auxv-to-copy-auxv-to-userspace.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/uapi/linux/prctl.h |    2 ++
 kernel/sys.c               |   15 +++++++++++++++
 2 files changed, 17 insertions(+)

--- a/include/uapi/linux/prctl.h~prctl-add-pr_get_auxv-to-copy-auxv-to-userspace
+++ a/include/uapi/linux/prctl.h
@@ -290,4 +290,6 @@ struct prctl_mm_map {
 #define PR_SET_VMA		0x53564d41
 # define PR_SET_VMA_ANON_NAME		0
 
+#define PR_GET_AUXV			0x41555856
+
 #endif /* _LINUX_PRCTL_H */
--- a/kernel/sys.c~prctl-add-pr_get_auxv-to-copy-auxv-to-userspace
+++ a/kernel/sys.c
@@ -2388,6 +2388,16 @@ static inline int prctl_get_mdwe(unsigne
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
@@ -2518,6 +2528,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
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


