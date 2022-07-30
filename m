Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63EDC19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbiG3BJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239645AbiG3BIp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B5287227
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB31619EE
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4006FC433D6;
        Sat, 30 Jul 2022 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143316;
        bh=0TI+GzyEJKTi+F3/N4LgKxZ7av3QZhCDXNoJBvVERyc=;
        h=Date:To:From:Subject:From;
        b=iWmGYttpKxE9IXhHzC8WZQXcvNkioxAX1X/1UuYYZ4PPHHInvO2Y8UIO/zerHTiR4
         m50eOy07jOeC4NQSR9IJCwEpxbGCMhBWPEc4P0GKyHzA4pRk0cN3nv8q06LcVcshx/
         WQ8st+BFEfTx4svKvW0CoFv05AVuque42sbX/y9Y=
Date:   Fri, 29 Jul 2022 18:08:35 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-dont-fail-on-unrecognized-features.patch removed from -mm tree
Message-Id: <20220730010836.4006FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: don't fail on unrecognized features
has been removed from the -mm tree.  Its filename was
     userfaultfd-dont-fail-on-unrecognized-features.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1923,10 +1923,8 @@ static int userfaultfd_api(struct userfa
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


