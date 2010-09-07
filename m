From: akpm@linux-foundation.org
Subject: + vfs-take-o_nonblock-out-of-the-o_-uniqueness-test.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:35:42 -0700
Message-ID: <201009072135.o87LZgOh007617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab0IGVg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@suse.de, fengguang.wu@intel.com, jamie@shareable.org


The patch titled
     vfs: take O_NONBLOCK out of the O_* uniqueness test
has been added to the -mm tree.  Its filename is
     vfs-take-o_nonblock-out-of-the-o_-uniqueness-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: take O_NONBLOCK out of the O_* uniqueness test
From: James Bottomley <James.Bottomley@suse.de>
DESC
vfs: take O_NONBLOCK out of the O_* uniqueness test

O_NONBLOCK on parisc has a dual value:

#define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */

It is caught by the O_* bits uniqueness check and leads to a parisc
compile error.  The fix would be to take O_NONBLOCK out.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Jamie Lokier <jamie@shareable.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/fcntl.c~vfs-take-o_nonblock-out-of-the-o_-uniqueness-test fs/fcntl.c
--- a/fs/fcntl.c~vfs-take-o_nonblock-out-of-the-o_-uniqueness-test
+++ a/fs/fcntl.c
@@ -769,11 +769,15 @@ EXPORT_SYMBOL(kill_fasync);
 
 static int __init fcntl_init(void)
 {
-	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	/*
+	 * Please add new bits here to ensure allocation uniqueness.
+	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
+	 * is defined as O_NONBLOCK on some platforms and not on others.
+	 */
+	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
-		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
+		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
_

Patches currently in -mm which might be from James.Bottomley@suse.de are

linux-next.patch
vfs-take-o_nonblock-out-of-the-o_-uniqueness-test.patch

