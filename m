From: akpm@linux-foundation.org
Subject: + vfs-o_-bit-numbers-uniqueness-check-fix.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:06:44 -0700
Message-ID: <201003192306.o2JN6iKn017540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab0CSXHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adilger@sun.com


The patch titled
     vfs: O_* bit numbers uniqueness check fix
has been added to the -mm tree.  Its filename is
     vfs-o_-bit-numbers-uniqueness-check-fix.patch

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
Subject: vfs: O_* bit numbers uniqueness check fix
From: Wu Fengguang <fengguang.wu@intel.com>

Follow the comment by Andreas:

It's non-obvious why there are 18 flags listed here, but the hweight is
only 17?  Presumably this is because O_RDONLY has value 0, but that should
at least be listed in a comment, or the test could be written more
explicitly, like:

	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix fs/fcntl.c
--- a/fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix
+++ a/fs/fcntl.c
@@ -742,7 +742,7 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(17 != HWEIGHT32(
+	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-o_-bit-numbers-uniqueness-check-update.patch
vfs-o_-bit-numbers-uniqueness-check-fix.patch
vfs-o_-bit-numbers-uniqueness-check-fix-2.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-add-super-operation-writeback_inodes.patch

