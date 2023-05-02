Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818B9C77B78
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 18:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjEBSqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 14:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEBSqy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 14:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75024E79
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 11:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 191E5627C0
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 18:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BA9C433EF;
        Tue,  2 May 2023 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683053212;
        bh=uFsv851mRwzt0zADUjJd+mPqieq3sVhk8RVVW2qZaCA=;
        h=Date:To:From:Subject:From;
        b=ehRKMjZY1RZEJHXwv4O9Pxq9NJgtpU5dhQRpppaBCD8KAbNae1MY+pjjrrQd/Rs15
         OhOSvdAa0rs0FiGxZlcxqCQ54vU6CcEaem0MJ5+XMlrPAAi5X1RcalQViTz4LrPS9w
         1OCkdgLZ5/i/Diuc+X8SrPL3NS/3CbLWvDNXMlWE=
Date:   Tue, 02 May 2023 11:46:51 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, samitolvanen@google.com,
        qiang1.zhang@intel.com, pmladek@suse.com, keescook@chromium.org,
        Jason@zx2c4.com, ebiederm@xmission.com, quic_pbaronia@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-fix-spelling-typo-and-grammar-in-comments.patch added to mm-nonmm-unstable branch
Message-Id: <20230502184652.62BA9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: fix spelling typo and grammar in comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-fix-spelling-typo-and-grammar-in-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-fix-spelling-typo-and-grammar-in-comments.patch

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
From: Prathu Baronia <quic_pbaronia@quicinc.com>
Subject: kthread: fix spelling typo and grammar in comments
Date: Tue, 2 May 2023 14:32:40 +0530

- `If present` -> `If present,'
- `reuturn` -> `return`
- `function exit safely` -> `function to exit safely`

Link: https://lkml.kernel.org/r/20230502090242.3037194-1-quic_pbaronia@quicinc.com
Signed-off-by: Prathu Baronia <quic_pbaronia@quicinc.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kthread.c~kthread-fix-spelling-typo-and-grammar-in-comments
+++ a/kernel/kthread.c
@@ -312,10 +312,10 @@ void __noreturn kthread_exit(long result
  * @comp: Completion to complete
  * @code: The integer value to return to kthread_stop().
  *
- * If present complete @comp and the reuturn code to kthread_stop().
+ * If present, complete @comp and then return code to kthread_stop().
  *
  * A kernel thread whose module may be removed after the completion of
- * @comp can use this function exit safely.
+ * @comp can use this function to exit safely.
  *
  * Does not return.
  */
_

Patches currently in -mm which might be from quic_pbaronia@quicinc.com are

kthread-fix-spelling-typo-and-grammar-in-comments.patch

