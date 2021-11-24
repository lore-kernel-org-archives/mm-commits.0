Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01DEC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 02:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhKXDB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhKXDB0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 22:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A4261038;
        Wed, 24 Nov 2021 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637722697;
        bh=UwdPkP7dwaadAQwF38r/ijhtzyWdNh9cUTukRC7O/mY=;
        h=Date:From:To:Subject:From;
        b=gLM8df/s7Pk7CHZKPaELSHgLvVFrSn2ATLcnSVy/jZbTt77tFwCx+ZUidWI9kcLMI
         v+UJzfSHIX33jIAogKxwB/LVEr1QG/0tBpvD8pFxccsO1M7W38O2SLFmdQkUWwEu67
         rsM1FKKjzSSpVwx8cqNz5W9thm6kQ4ML9lDFKcWo=
Date:   Tue, 23 Nov 2021 18:58:16 -0800
From:   akpm@linux-foundation.org
To:     amit.kachhap@arm.com, Kevin.Brodsky@arm.com,
        mm-commits@vger.kernel.org, Vincenzo.Frascino@arm.com,
        viro@zeniv.linux.org.uk
Subject:  + fs-ioctl-remove-unnecessary-__user-annotation.patch
 added to -mm tree
Message-ID: <20211124025816.jNgY-u6Mx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ioctl: remove unnecessary __user annotation
has been added to the -mm tree.  Its filename is
     fs-ioctl-remove-unnecessary-__user-annotation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-ioctl-remove-unnecessary-__user-annotation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-ioctl-remove-unnecessary-__user-annotation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: fs/ioctl: remove unnecessary __user annotation

__user annotations are used by the checker (e.g sparse) to mark user
pointers.  However here __user is applied to a struct directly, without a
pointer being directly involved.

Although the presence of __user does not cause sparse to emit a warning,
__user should be removed for consistency with other uses of offsetof().

Note: No functional changes intended.

Link: https://lkml.kernel.org/r/20211122101256.7875-1-amit.kachhap@arm.com
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Vincenzo Frascino <Vincenzo.Frascino@arm.com>
Cc: Kevin Brodsky <Kevin.Brodsky@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ioctl.c~fs-ioctl-remove-unnecessary-__user-annotation
+++ a/fs/ioctl.c
@@ -430,7 +430,7 @@ static int ioctl_file_dedupe_range(struc
 		goto out;
 	}
 
-	size = offsetof(struct file_dedupe_range __user, info[count]);
+	size = offsetof(struct file_dedupe_range, info[count]);
 	if (size > PAGE_SIZE) {
 		ret = -ENOMEM;
 		goto out;
_

Patches currently in -mm which might be from amit.kachhap@arm.com are

fs-ioctl-remove-unnecessary-__user-annotation.patch

