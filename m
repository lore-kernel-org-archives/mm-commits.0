From: akpm@linux-foundation.org
Subject: + vfs-o_-bit-numbers-uniqueness-check-fix-2.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:06:45 -0700
Message-ID: <201003192306.o2JN6jfd017545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0CSXH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:07:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, eparis@redhat.com


The patch titled
     vfs: O_* bit numbers uniqueness check fix 2
has been added to the -mm tree.  Its filename is
     vfs-o_-bit-numbers-uniqueness-check-fix-2.patch

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
Subject: vfs: O_* bit numbers uniqueness check fix 2
From: Wu Fengguang <fengguang.wu@intel.com>

Follow the comment by Eric:

	Until the FMODE_ and O_ bits do not overload I think we need to check
	FMODE_EXEC and FMODE_NONOTIFY (if you have that one) inside fcntl_init()
	as well.  I guess I'll send a patch to someone ?Al? to add FMODE_EXEC to
	the list....

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix-2 fs/fcntl.c
--- a/fs/fcntl.c~vfs-o_-bit-numbers-uniqueness-check-fix-2
+++ a/fs/fcntl.c
@@ -742,13 +742,14 @@ EXPORT_SYMBOL(kill_fasync);
 static int __init fcntl_init(void)
 {
 	/* please add new bits here to ensure allocation uniqueness */
-	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
-		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
+		FMODE_EXEC
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
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

