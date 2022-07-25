Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1A2C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 18:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiGYS5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 14:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGYS5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 14:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D737DBE1C
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 11:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 905E0B810AA
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 18:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6B8C341C6;
        Mon, 25 Jul 2022 18:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658775427;
        bh=N8xxs5uCXgdeTYkHduIdLIqdFNdBGarlZhxt3g2Wwjw=;
        h=Date:To:From:Subject:From;
        b=KO443ZKI1wUCQTZU9REcILLZ9Mt9EzA5dHyrSD9NXm8wxh1JGX8u8Zm2Y5evZL49/
         5luMkt5FMkRDQYrb23/kM2HT4So5Ongtr58GkNT2QPZGwROhd8wWvIMLGvHx+IAnnl
         bJamPlQPo6HG8g1njDQgnWjN4E+4J6chXidtVnHI=
Date:   Mon, 25 Jul 2022 11:57:06 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-dont-fail-on-unrecognized-features.patch added to mm-unstable branch
Message-Id: <20220725185707.2D6B8C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: don't fail on unrecognized features
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-dont-fail-on-unrecognized-features.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-dont-fail-on-unrecognized-features.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: don't fail on unrecognized features
Date: Fri, 22 Jul 2022 13:15:13 -0700

The basic interaction for setting up a userfaultfd is, userspace issues
a UFFDIO_API ioctl, and passes in a set of zero or more feature flags,
indicating the features they would prefer to use.

Of course, different kernels may support different sets of features
(depending on kernel version, kconfig options, architecture, etc).
Userspace's expectations may also not match: perhaps it was built
against newer kernel headers, which defined some features the kernel
it's running on doesn't support.

Currently, if userspace passes in a flag we don't recognize, the
initialization fails and we return -EINVAL. This isn't great, though.
Userspace doesn't have an obvious way to react to this; sure, one of the
features I asked for was unavailable, but which one? The only option it
has is to turn off things "at random" and hope something works.

Instead, modify UFFDIO_API to just ignore any unrecognized feature
flags. The interaction is now that the initialization will succeed, and
as always we return the *subset* of feature flags that can actually be
used back to userspace.

Now userspace has an obvious way to react: it checks if any flags it
asked for are missing. If so, it can conclude this kernel doesn't
support those, and it can either resign itself to not using them, or
fail with an error on its own, or whatever else.

Link: https://lkml.kernel.org/r/20220722201513.1624158-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-dont-fail-on-unrecognized-features
+++ a/fs/userfaultfd.c
@@ -1947,10 +1947,8 @@ static int userfaultfd_api(struct userfa
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
-	features = uffdio_api.features;
-	ret = -EINVAL;
-	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
-		goto err_out;
+	/* Ignore unsupported features (userspace built against newer kernel) */
+	features = uffdio_api.features & UFFD_API_FEATURES;
 	ret = -EPERM;
 	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
 		goto err_out;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-dont-fail-on-unrecognized-features.patch

