Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCCCC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F85161C14
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhKPEkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239955AbhKPEjD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:39:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A808B61B93;
        Tue, 16 Nov 2021 04:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637037365;
        bh=3BErF7ykId4EW5cPcBxgLrSFJD3kBvTKpJVYhdXVkeI=;
        h=Date:From:To:Subject:From;
        b=2ROc4d2Ewd3K4Hlw3z/1IfqA8LZ3xJN7q+ZXDRj8UpYdWV//drmbUfJKYIY6Ji+hk
         bENKv5Bp2LUCAHUkfr/AM3BEDg0+z1R8jcvoD61IJArk0vZQB+OS1f8x6iAtRCYSNx
         UEnfW5mcK70sUz0L92iq5IdGE/R7qYi+HUHNGn0M=
Date:   Mon, 15 Nov 2021 20:36:05 -0800
From:   akpm@linux-foundation.org
To:     asml.silence@gmail.com, axboe@kernel.dk, chrubis@suse.cz,
        mm-commits@vger.kernel.org, sir@cmpwn.com
Subject:  + increase-default-mlock_limit-to-8-mib.patch added to
 -mm tree
Message-ID: <20211116043605.FApeFG8_6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Increase default MLOCK_LIMIT to 8 MiB
has been added to the -mm tree.  Its filename is
     increase-default-mlock_limit-to-8-mib.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/increase-default-mlock_limit-to-8-mib.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/increase-default-mlock_limit-to-8-mib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Drew DeVault <sir@cmpwn.com>
Subject: Increase default MLOCK_LIMIT to 8 MiB

This limit has not been updated since 2008, when it was increased to 64
KiB at the request of GnuPG.  Until recently, the main use-cases for this
feature were (1) preventing sensitive memory from being swapped, as in
GnuPG's use-case; and (2) real-time use-cases.  In the first case, little
memory is called for, and in the second case, the user is generally in a
position to increase it if they need more.

The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
preparing fixed buffers for high-performance I/O.  This use-case will take
as much of this memory as it can get, but is still limited to 64 KiB by
default, which is very little.  This increases the limit to 8 MB, which
was chosen fairly arbitrarily as a more generous, but still conservative,
default value.

It is also possible to raise this limit in userspace.  This is easily
done, for example, in the use-case of a network daemon: systemd, for
instance, provides for this via LimitMEMLOCK in the service file; OpenRC
via the rc_ulimit variables.  However, there is no established userspace
facility for configuring this outside of daemons: end-user applications do
not presently have access to a convenient means of raising their limits.

The buck, as it were, stops with the kernel.  It's much easier to address
it here than it is to bring it to hundreds of distributions, and it can
only realistically be relied upon to be high-enough by end-user software
if it is more-or-less ubiquitous.  Most distros don't change this
particular rlimit from the kernel-supplied default value, so a change here
will easily provide that ubiquity.

Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
Signed-off-by: Drew DeVault <sir@cmpwn.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/resource.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/resource.h~increase-default-mlock_limit-to-8-mib
+++ a/include/uapi/linux/resource.h
@@ -66,10 +66,17 @@ struct rlimit64 {
 #define _STK_LIM	(8*1024*1024)
 
 /*
- * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
- * and other sensitive information are never written to disk.
+ * Limit the amount of locked memory by some sane default:
+ * root can always increase this limit if needed.
+ *
+ * The main use-cases are (1) preventing sensitive memory
+ * from being swapped; (2) real-time operations; (3) via
+ * IOURING_REGISTER_BUFFERS.
+ *
+ * The first two don't need much. The latter will take as
+ * much as it can get. 8MB is a reasonably sane default.
  */
-#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
+#define MLOCK_LIMIT	((PAGE_SIZE > 8*1024*1024) ? PAGE_SIZE : 8*1024*1024)
 
 /*
  * Due to binary compatibility, the actual resource numbers
_

Patches currently in -mm which might be from sir@cmpwn.com are

increase-default-mlock_limit-to-8-mib.patch

