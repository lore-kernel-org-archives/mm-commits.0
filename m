From: akpm@linux-foundation.org
Subject: + kernel-userc-drop-unused-field-files-from-user_struct.patch
 added to -mm tree
Date: Fri, 09 May 2014 12:10:01 -0700
Message-ID: <536d2809.Sx9ouwH/Ompzqsg1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEITKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2014 15:10:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, kirill@shutemov.name

Subject: + kernel-userc-drop-unused-field-files-from-user_struct.patch added to -mm tree
To: kirill@shutemov.name,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 09 May 2014 12:10:01 -0700


The patch titled
     Subject: kernel/user.c: drop unused field 'files' from user_struct
has been added to the -mm tree.  Its filename is
     kernel-userc-drop-unused-field-files-from-user_struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-userc-drop-unused-field-files-from-user_struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-userc-drop-unused-field-files-from-user_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: kernel/user.c: drop unused field 'files' from user_struct

Nobody seems uses it for a long time. Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/user.c         |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/sched.h~kernel-userc-drop-unused-field-files-from-user_struct include/linux/sched.h
--- a/include/linux/sched.h~kernel-userc-drop-unused-field-files-from-user_struct
+++ a/include/linux/sched.h
@@ -745,7 +745,6 @@ static inline int signal_group_exit(cons
 struct user_struct {
 	atomic_t __count;	/* reference count */
 	atomic_t processes;	/* How many processes does this user have? */
-	atomic_t files;		/* How many open files does this user have? */
 	atomic_t sigpending;	/* How many pending signals does this user have? */
 #ifdef CONFIG_INOTIFY_USER
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
diff -puN kernel/user.c~kernel-userc-drop-unused-field-files-from-user_struct kernel/user.c
--- a/kernel/user.c~kernel-userc-drop-unused-field-files-from-user_struct
+++ a/kernel/user.c
@@ -87,7 +87,6 @@ static DEFINE_SPINLOCK(uidhash_lock);
 struct user_struct root_user = {
 	.__count	= ATOMIC_INIT(1),
 	.processes	= ATOMIC_INIT(1),
-	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
 	.locked_shm     = 0,
 	.uid		= GLOBAL_ROOT_UID,
_

Patches currently in -mm which might be from kirill@shutemov.name are

kernel-userc-drop-unused-field-files-from-user_struct.patch

