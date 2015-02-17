From: akpm@linux-foundation.org
Subject: [folded-merged]
 eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch removed from -mm
 tree
Date: Tue, 17 Feb 2015 13:37:44 -0800
Message-ID: <54e3b4a8.mtuKqhwKQnqHye4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbBQVhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 16:37:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, clm@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfs: avoid unused variable warning
has been removed from the -mm tree.  Its filename was
     eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch

This patch was dropped because it was folded into eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: eventfs: avoid unused variable warning

An optimization patch from Chris Mason causes build warnings about an
unused variable.

The patch that broke this is currently in the akpm-current series, so this
fixup can be folded into the original patch.  I was expecting multiple
people to send a patch for this, so I waited a bit at first.

Fixes: 567162b87a5c5f  ("eventfd: don't take the spinlock in eventfd_poll")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix fs/eventfd.c
--- a/fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix
+++ a/fs/eventfd.c
@@ -118,7 +118,6 @@ static unsigned int eventfd_poll(struct
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	unsigned long flags;
 	unsigned int count;
 
 	poll_wait(file, &ctx->wqh, wait);
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch
eventfd-dont-take-the-spinlock-in-eventfd_poll.patch

