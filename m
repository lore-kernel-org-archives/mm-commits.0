Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8333EEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjGIA6S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjGIA6S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A27E1B1;
        Sat,  8 Jul 2023 17:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D155B60B6C;
        Sun,  9 Jul 2023 00:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292F4C433C7;
        Sun,  9 Jul 2023 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688864296;
        bh=O/vAYSTn/J0+kMbKZLCQfcwxglHHieeVgPAdGkc0Kz0=;
        h=Date:To:From:Subject:From;
        b=1nMxQ8cWcBVTjwtwyAoDLN2QUFo4jHcZpjtJ/NSFP1EHJpzMcv9e80JJArFS+EUMT
         BI564M2CxbegGGSfeQ7mP584LY60CPqxh4lfeM3BtpWLx3MW2mBNC/geYKRbjHQMcL
         bIzYuVMkOtCNRDHVUi/gfrq/BvUJL9KFMAOkkBP0=
Date:   Sat, 08 Jul 2023 17:58:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        josh@joshtriplett.org, ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + prctl-move-pr_get_auxv-out-of-pr_mce_kill.patch added to mm-hotfixes-unstable branch
Message-Id: <20230709005816.292F4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: move PR_GET_AUXV out of PR_MCE_KILL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     prctl-move-pr_get_auxv-out-of-pr_mce_kill.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/prctl-move-pr_get_auxv-out-of-pr_mce_kill.patch

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
From: Miguel Ojeda <ojeda@kernel.org>
Subject: prctl: move PR_GET_AUXV out of PR_MCE_KILL
Date: Sun, 9 Jul 2023 01:33:44 +0200

Somehow PR_GET_AUXV got added into PR_MCE_KILL's switch when the patch was
applied [1].

Thus move it out of the switch, to the place the patch added it.

In the recently released v6.4 kernel some user could, in principle, be
already using this feature by mapping the right page and passing the
PR_GET_AUXV constant as a pointer:

    prctl(PR_MCE_KILL, PR_GET_AUXV, ...)

So this does change the behavior for users.  We could keep the bug since
the other subcases in PR_MCE_KILL (PR_MCE_KILL_CLEAR and PR_MCE_KILL_SET)
do not overlap.

However, v6.4 may be recent enough (2 weeks old) that moving the lines
(rather than just adding a new case) does not break anybody?  Moreover,
the documentation in man-pages was just committed today [2].

Link: https://lkml.kernel.org/r/20230708233344.361854-1-ojeda@kernel.org
Fixes: ddc65971bb67 ("prctl: add PR_GET_AUXV to copy auxv to userspace")
Link: https://lore.kernel.org/all/d81864a7f7f43bca6afa2a09fc2e850e4050ab42.1680611394.git.josh@joshtriplett.org/ [1]
Link: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=8cf0c06bfd3c2b219b044d4151c96f0da50af9ad [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/sys.c~prctl-move-pr_get_auxv-out-of-pr_mce_kill
+++ a/kernel/sys.c
@@ -2535,11 +2535,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				return -EINVAL;
 			break;
-	case PR_GET_AUXV:
-		if (arg4 || arg5)
-			return -EINVAL;
-		error = prctl_get_auxv((void __user *)arg2, arg3);
-		break;
 		default:
 			return -EINVAL;
 		}
@@ -2694,6 +2689,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	case PR_SET_VMA:
 		error = prctl_set_vma(arg2, arg3, arg4, arg5);
 		break;
+	case PR_GET_AUXV:
+		if (arg4 || arg5)
+			return -EINVAL;
+		error = prctl_get_auxv((void __user *)arg2, arg3);
+		break;
 #ifdef CONFIG_KSM
 	case PR_SET_MEMORY_MERGE:
 		if (arg3 || arg4 || arg5)
_

Patches currently in -mm which might be from ojeda@kernel.org are

prctl-move-pr_get_auxv-out-of-pr_mce_kill.patch

