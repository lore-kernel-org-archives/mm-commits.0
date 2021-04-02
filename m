Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C464C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35676100C
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhDBAbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBAbe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1254610FC;
        Fri,  2 Apr 2021 00:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617323494;
        bh=od8EBEnLu7uq1O/juTTPZHSRIgKlrH4Eu+tGenUA+WE=;
        h=Date:From:To:Subject:From;
        b=uOKv7G+SD2gck+z7G41rAc6I5mmJwvJeXCoWPrwEXYgpDDrZ7wzMJxcrGX0NG6syd
         DvzXwpUz77HsJ1wja/Z6paha9WKpit3HvOQ2vrg3tm/qp7NpwbucBm3CAT0mdKxEkS
         ZLU3VfoTcmXLS8eLLsUonkdA3GNtwQ2hMGp9IUxE=
Date:   Thu, 01 Apr 2021 17:31:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wanjiabing@vivo.com
Subject:  + linux-profileh-remove-unnecessary-declaration.patch
 added to -mm tree
Message-ID: <20210402003133.GX-wxAEHd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/profile.h: remove unnecessary declaration
has been added to the -mm tree.  Its filename is
     linux-profileh-remove-unnecessary-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-profileh-remove-unnecessary-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-profileh-remove-unnecessary-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: linux/profile.h: remove unnecessary declaration

Declaring struct pt_regs is unnecessary.  On the one hand, there is no
function using it; on the other hand, struct pt_regs has been declared in
linux/kernel.h.  Remove them.

Link: https://lkml.kernel.org/r/20210401104834.1009157-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/profile.h~linux-profileh-remove-unnecessary-declaration
+++ a/include/linux/profile.h
@@ -15,7 +15,6 @@
 #define KVM_PROFILING	4
 
 struct proc_dir_entry;
-struct pt_regs;
 struct notifier_block;
 
 #if defined(CONFIG_PROFILING) && defined(CONFIG_PROC_FS)
@@ -84,8 +83,6 @@ int task_handoff_unregister(struct notif
 int profile_event_register(enum profile_type, struct notifier_block * n);
 int profile_event_unregister(enum profile_type, struct notifier_block * n);
 
-struct pt_regs;
-
 #else
 
 #define prof_on 0
_

Patches currently in -mm which might be from wanjiabing@vivo.com are

scripts-a-new-script-for-checking-duplicate-struct-declaration.patch
linux-memcontrolh-remove-duplicate-struct-declaration.patch
linux-profileh-remove-unnecessary-declaration.patch

