From: akpm@linux-foundation.org
Subject: + mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch added to -mm tree
Date: Wed, 01 Oct 2008 23:20:29 -0700
Message-ID: <200810020620.m926KTrQ024132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYJBGUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 02:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, mingo@elte.hu


The patch titled
     mutex: improve header comment to be actually informative about the API
has been added to the -mm tree.  Its filename is
     mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mutex: improve header comment to be actually informative about the API
From: Arjan van de Ven <arjan@linux.intel.com>

It's nice to say that mutex_trylock follows the spin_trylock convention. 
It's a lot nicer if the comment also says which that is...  make it so.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mutex.h~mutex-improve-header-comment-to-be-actually-informative-about-the-api include/linux/mutex.h
--- a/include/linux/mutex.h~mutex-improve-header-comment-to-be-actually-informative-about-the-api
+++ a/include/linux/mutex.h
@@ -144,6 +144,8 @@ extern int __must_check mutex_lock_killa
 /*
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
+ *
+ * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-x86.patch
git-net.patch
git-fastboot.patch
mutex-improve-header-comment-to-be-actually-informative-about-the-api.patch

