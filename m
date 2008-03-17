From: akpm@linux-foundation.org
Subject: + xtensa-use-newer-__spin_lock_unlocked-macro.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:31:04 -0700
Message-ID: <200803172331.m2HNV4Of003905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbYCQXbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, chris@zankel.net


The patch titled
     xtensa: use newer __SPIN_LOCK_UNLOCKED macro
has been added to the -mm tree.  Its filename is
     xtensa-use-newer-__spin_lock_unlocked-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use newer __SPIN_LOCK_UNLOCKED macro
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

SPIN_LOCK_UNLOCKED() breaks lockdep and is deprecated.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platforms/iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/platforms/iss/network.c~xtensa-use-newer-__spin_lock_unlocked-macro arch/xtensa/platforms/iss/network.c
--- a/arch/xtensa/platforms/iss/network.c~xtensa-use-newer-__spin_lock_unlocked-macro
+++ a/arch/xtensa/platforms/iss/network.c
@@ -640,7 +640,7 @@ static int iss_net_configure(int index, 
 	*lp = ((struct iss_net_private) {
 		.device_list		= LIST_HEAD_INIT(lp->device_list),
 		.opened_list		= LIST_HEAD_INIT(lp->opened_list),
-		.lock			= SPIN_LOCK_UNLOCKED,
+		.lock			= __SPIN_LOCK_UNLOCKED(lp.lock),
 		.dev			= dev,
 		.index			= index,
 		//.fd                   = -1,
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch

