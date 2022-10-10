Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13565C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 10 Oct 2022 21:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJJVOB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Oct 2022 17:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJJVOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2022 17:14:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713656DFB7
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 14:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21CA5B810D6
        for <mm-commits@vger.kernel.org>; Mon, 10 Oct 2022 21:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E31C433C1;
        Mon, 10 Oct 2022 21:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665436436;
        bh=vDRJ7VvnTuB/T+sdedDzWlZZ+POj+e3eFNZT80dOlpc=;
        h=Date:To:From:Subject:From;
        b=ZSQz4iFIb5u3dsjzGk1QU+16id4AjQIbvgZjRzluWdEt9Ka8sxTEbiu5lUNk5fk0R
         bvEn44YLHg8x5gf4jVGhZ9uIJ9V84f0NbOiTL/XAgacGXcnmwBNmAPtZTOh9gy5Z8M
         qm6yaCE9iABOYuUz1Xzr2bMQOLkExdl4dNI+y1zg=
Date:   Mon, 10 Oct 2022 14:13:55 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20221010211356.C4E31C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/entry-common.h: remove has_signal comment of arch_do_signal_or_restart() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch

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
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: include/linux/entry-common.h: remove has_signal comment of arch_do_signal_or_restart() prototype
Date: Fri, 2 Sep 2022 11:41:46 +0800

The argument has_signal of arch_do_signal_or_restart() has been removed in
commit 8ba62d37949e ("task_work: Call tracehook_notify_signal from
get_signal on all architectures"), let us remove the related comment.

Link: https://lkml.kernel.org/r/1662090106-5545-1-git-send-email-yangtiezhu@loongson.cn
Fixes: 8ba62d37949e ("task_work: Call tracehook_notify_signal from get_signal on all architectures")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/entry-common.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/entry-common.h~entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype
+++ a/include/linux/entry-common.h
@@ -253,7 +253,6 @@ static __always_inline void arch_exit_to
 /**
  * arch_do_signal_or_restart -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
- * @has_signal:	actual signal to handle
  *
  * Invoked from exit_to_user_mode_loop().
  */
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch

