Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F28DC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjFJApF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFJApE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC4A3A98
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95E3651B5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36297C433D2;
        Sat, 10 Jun 2023 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357902;
        bh=TIPSUQrUi+MtvnWA5Adgxp7G4CCAwi32JJH0TpkSGUM=;
        h=Date:To:From:Subject:From;
        b=qqibAgi75h5B73OLCLrtFAXIfHdQDdMNKN3mPGTkYlkaqGxHJT3fMkzhsy9PJheCX
         AiMyMytf5KO/qIEI9bVB/KK8ADW8gEyrIUnHySYLgXYrhnVjyfbvuTC7h9PKRTrnVH
         hs2w1UeaGKV0z2aqzOLcrYSMh0XCGM9mpX15e/r4=
Date:   Fri, 09 Jun 2023 17:45:01 -0700
To:     mm-commits@vger.kernel.org, tj@kernel.org, samitolvanen@google.com,
        qiang1.zhang@intel.com, pmladek@suse.com, keescook@chromium.org,
        Jason@zx2c4.com, ebiederm@xmission.com, quic_pbaronia@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kthread-fix-spelling-typo-and-grammar-in-comments.patch removed from -mm tree
Message-Id: <20230610004502.36297C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread: fix spelling typo and grammar in comments
has been removed from the -mm tree.  Its filename was
     kthread-fix-spelling-typo-and-grammar-in-comments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


