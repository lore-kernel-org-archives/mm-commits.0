From: akpm@linux-foundation.org
Subject: + ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.patch added to -mm tree
Date: Tue, 04 Aug 2009 22:01:46 -0700
Message-ID: <200908050501.n7551kac005466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbZHEFCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 01:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, jgunthorpe@obsidianresearch.com, jsquyres@cisco.com, randy.dunlap@oracle.com, rolandd@cisco.com, rostedt@goodmis.org


The patch titled
     ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.txt
has been added to the -mm tree.  Its filename is
     ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.patch

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
Subject: ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.txt
From: Roland Dreier <rdreier@cisco.com>

    ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'

when building for i386 -- get_user() can't handle u64 on all
architectures, so just use copy_from_user().

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jeff Squyres <jsquyres@cisco.com> 
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ummunotify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ummunotify.c~ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix drivers/char/ummunotify.c
--- a/drivers/char/ummunotify.c~ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix
+++ a/drivers/char/ummunotify.c
@@ -453,7 +453,7 @@ static long ummunotify_unregister_region
 	struct ummunotify_reg *reg;
 	int ret = -EINVAL;
 
-	if (get_user(user_cookie, arg))
+	if (copy_from_user(&user_cookie, arg, sizeof user_cookie))
 		return -EFAULT;
 
 	spin_lock_irq(&priv->lock);
_

Patches currently in -mm which might be from rdreier@cisco.com are

linux-next.patch
ecryptfs-another-lockdep-issue.patch
ummunotify-userspace-support-for-mmu-notifications.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.patch

