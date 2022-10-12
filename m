Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF89C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiJLBwA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJLBvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D6A4BA1
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 321D2CE1A9A
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60581C433D7;
        Wed, 12 Oct 2022 01:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539507;
        bh=ZN63EQj5HoLsRhQvkG0a31EovQQ5J5R4ylsiE5ZSGl4=;
        h=Date:To:From:Subject:From;
        b=b2Ne+zEG1dgM03hsZ+L6H7xg2o8ipHaJ5NU8aVSOj+jAOj6pyJBr+DRLHOgW4p7uE
         R6l0VV5oCaYBAtopllsn2BlZANEMGt9Hm5r0JCqCVFfVBSbC6Qgd77Zncan4DuZmq6
         /6dtPgiTvhBp2AwdFmO6B1+Ac/EgH4cXW4m1yOp4=
Date:   Tue, 11 Oct 2022 18:51:46 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch removed from -mm tree
Message-Id: <20221012015147.60581C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/entry-common.h: remove has_signal comment of arch_do_signal_or_restart() prototype
has been removed from the -mm tree.  Its filename was
     entry-remove-has_signal-comment-of-arch_do_signal_or_restart-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


