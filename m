Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4A9C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 22:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLPWHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 17:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLPWHh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 17:07:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8303B1740C
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 14:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA4F621A5
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 22:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E37C433D2;
        Fri, 16 Dec 2022 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671228455;
        bh=he0YTQv5F723kMgCSGktSqo94wLl/0vi2OsK3uBzSKc=;
        h=Date:To:From:Subject:From;
        b=PMgmAgaH0btZ/D85pViqjD2i1zRl2rq/I3xg71GnHz+I7YKowoLE6uCAhqigukUmO
         iWeXRprn3OvC1tkXYpanvG+t+2B5MOSMAv/FIulCPGMeQlXBBBMMIERXWIh49bp0MY
         rT9dD+MtFwBJYNtoWFVlc6Yi7XkdoOXlrEjzg4Zg=
Date:   Fri, 16 Dec 2022 14:07:34 -0800
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com,
        jannh@google.com, hughd@google.com, dverkamp@chromium.org,
        dmitry.torokhov@gmail.com, dh.herrmann@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch added to mm-unstable branch
Message-Id: <20221216220735.73E37C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
Date: Fri Dec 16 02:04:18 PM PST 2022

s/pr_warn_ratelimited/pr_warn_once/, per review

Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3
+++ a/mm/memfd.c
@@ -308,7 +308,7 @@ SYSCALL_DEFINE2(memfd_create,
 			flags |= MFD_NOEXEC_SEAL;
 			break;
 		default:
-			pr_warn_ratelimited(
+			pr_warn_once(
 				"memfd_create(): MFD_NOEXEC_SEAL is enforced, pid=%d '%s'\n",
 				task_pid_nr(current), get_task_comm(comm, current));
 			return -EINVAL;
@@ -316,7 +316,7 @@ SYSCALL_DEFINE2(memfd_create,
 #else
 		flags |= MFD_EXEC;
 #endif
-		pr_warn_ratelimited(
+		pr_warn_once(
 			"memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=%d '%s'\n",
 			task_pid_nr(current), get_task_comm(comm, current));
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
error-injection-remove-ei_etype_none-fix.patch

