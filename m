Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA416CA0EC3
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240979AbjIKWWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbjIKSff (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:35:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B143F198
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:35:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2D2C433C7;
        Mon, 11 Sep 2023 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694457330;
        bh=3LR3dCV+5rxbWDnOyX86kTEuZS6zDh2a4fKeZxikddI=;
        h=Date:To:From:Subject:From;
        b=O/nAnS4YRCRrWuIu/j95pXvXWeCNJFzUiefHKy2DWn8DxrJIlX857CcNAK5aD4F72
         9kWlWSsPovnPQ0ErZCfTkAJ465EILWmX/Y4G0yEri6DgWmPD84cTGmE4e6c8pxGIal
         58IgUeTiLOp9EuKGEDl8c7KaA7lvgcyBOAh5klWw=
Date:   Mon, 11 Sep 2023 11:35:29 -0700
To:     mm-commits@vger.kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, jeffxu@google.com, frederic@kernel.org,
        cyphar@cyphar.com, brauner@kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pid-pid_ns_ctl_handler-remove-useless-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20230911183530.3E2D2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pid: pid_ns_ctl_handler: remove useless comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pid-pid_ns_ctl_handler-remove-useless-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-pid_ns_ctl_handler-remove-useless-comment.patch

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
From: Rong Tao <rongtao@cestc.cn>
Subject: pid: pid_ns_ctl_handler: remove useless comment
Date: Mon, 11 Sep 2023 22:55:09 +0800

commit 95846ecf9dac("pid: replace pid bitmap implementation with IDR API")
removes 'last_pid' element, and use the idr_get_cursor-idr_set_cursor pair
to set the value of idr, so useless comments should be removed.

Link: https://lkml.kernel.org/r/tencent_157A2A1CAF19A3F5885F0687426159A19708@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/pid_namespace.c~pid-pid_ns_ctl_handler-remove-useless-comment
+++ a/kernel/pid_namespace.c
@@ -286,12 +286,6 @@ static int pid_ns_ctl_handler(struct ctl
 	if (write && !checkpoint_restore_ns_capable(pid_ns->user_ns))
 		return -EPERM;
 
-	/*
-	 * Writing directly to ns' last_pid field is OK, since this field
-	 * is volatile in a living namespace anyway and a code writing to
-	 * it should synchronize its usage with external means.
-	 */
-
 	next = idr_get_cursor(&pid_ns->idr) - 1;
 
 	tmp.data = &next;
_

Patches currently in -mm which might be from rongtao@cestc.cn are

pid-pid_ns_ctl_handler-remove-useless-comment.patch

