From: akpm@linux-foundation.org
Subject: + kernel-userc-add-lock-release-annotation-on-free_user.patch added to -mm tree
Date: Mon, 27 Sep 2010 13:58:03 -0700
Message-ID: <201009272058.o8RKw3Ln016240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760244Ab0I0U6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 16:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, dhaval.giani@gmail.com, mingo@elte.hu


The patch titled
     kernel/user.c: add lock release annotation on free_user()
has been added to the -mm tree.  Its filename is
     kernel-userc-add-lock-release-annotation-on-free_user.patch

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
Subject: kernel/user.c: add lock release annotation on free_user()
From: Namhyung Kim <namhyung@gmail.com>

free_user() releases uidhash_lock but was missing annotation.  Add it. 
This removes following sparse warnings:

 include/linux/spinlock.h:339:9: warning: context imbalance in 'free_user' - unexpected unlock
 kernel/user.c:120:6: warning: context imbalance in 'free_uid' - wrong count at exit

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/user.c~kernel-userc-add-lock-release-annotation-on-free_user kernel/user.c
--- a/kernel/user.c~kernel-userc-add-lock-release-annotation-on-free_user
+++ a/kernel/user.c
@@ -91,6 +91,7 @@ static struct user_struct *uid_hash_find
  * upon function exit.
  */
 static void free_user(struct user_struct *up, unsigned long flags)
+	__releases(&uidhash_lock)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

