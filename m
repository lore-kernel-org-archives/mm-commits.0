From: akpm@linux-foundation.org
Subject: + fs-binfmt_aout-fix-pointer-warnings.patch added to -mm tree
Date: Thu, 18 Mar 2010 12:30:37 -0700
Message-ID: <201003181930.o2IJUbEk011334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab0CRTan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petkovbb@googlemail.com, d.hatayama@jp.fujitsu.com, petkovbb@gmail.com


The patch titled
     fs/binfmt_aout.c: fix pointer warnings
has been added to the -mm tree.  Its filename is
     fs-binfmt_aout-fix-pointer-warnings.patch

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
Subject: fs/binfmt_aout.c: fix pointer warnings
From: Borislav Petkov <petkovbb@googlemail.com>


fs/binfmt_aout.c: In function `aout_core_dump':
fs/binfmt_aout.c:125: warning: passing argument 2 of `dump_write' makes pointer from integer without a cast
include/linux/coredump.h:12: note: expected `const void *' but argument is of type `long unsigned int'
fs/binfmt_aout.c:132: warning: passing argument 2 of `dump_write' makes pointer from integer without a cast
include/linux/coredump.h:12: note: expected `const void *' but argument is of type `long unsigned int'

due to dump_write() expecting a user void *.  Fold casts into the
START_DATA/START_STACK macros and shut up the warnings.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_aout.c~fs-binfmt_aout-fix-pointer-warnings fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~fs-binfmt_aout-fix-pointer-warnings
+++ a/fs/binfmt_aout.c
@@ -75,14 +75,16 @@ static int aout_core_dump(struct coredum
 	struct file *file = cprm->file;
 	mm_segment_t fs;
 	int has_dumped = 0;
-	unsigned long dump_start, dump_size;
+	void __user *dump_start;
+	int dump_size;
 	struct user dump;
 #ifdef __alpha__
-#       define START_DATA(u)	(u.start_data)
+#       define START_DATA(u)	((void __user *)u.start_data)
 #else
-#	define START_DATA(u)	((u.u_tsize << PAGE_SHIFT) + u.start_code)
+#	define START_DATA(u)	((void __user *)((u.u_tsize << PAGE_SHIFT) + \
+				 u.start_code))
 #endif
-#       define START_STACK(u)   (u.start_stack)
+#       define START_STACK(u)   ((void __user *)u.start_stack)
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
@@ -104,9 +106,9 @@ static int aout_core_dump(struct coredum
 
 /* make sure we actually have a data and stack area to dump */
 	set_fs(USER_DS);
-	if (!access_ok(VERIFY_READ, (void __user *)START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
+	if (!access_ok(VERIFY_READ, START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
 		dump.u_dsize = 0;
-	if (!access_ok(VERIFY_READ, (void __user *)START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
+	if (!access_ok(VERIFY_READ, START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
 		dump.u_ssize = 0;
 
 	set_fs(KERNEL_DS);
_

Patches currently in -mm which might be from petkovbb@googlemail.com are

fs-binfmt_aout-fix-pointer-warnings.patch

