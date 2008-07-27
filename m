From: akpm@linux-foundation.org
Subject: + fix-__ratelimit-re-flags-cant-be-static.patch added to -mm tree
Date: Sat, 26 Jul 2008 23:33:50 -0700
Message-ID: <200807270633.m6R6XoZ2006472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYG0Gdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 02:33:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, hidave.darkstar@gmail.com


The patch titled
     __ratelimit() cpu flags can't be static
has been added to the -mm tree.  Its filename is
     fix-__ratelimit-re-flags-cant-be-static.patch

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
Subject: __ratelimit() cpu flags can't be static
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/ratelimit.c~fix-__ratelimit-re-flags-cant-be-static lib/ratelimit.c
--- a/lib/ratelimit.c~fix-__ratelimit-re-flags-cant-be-static
+++ a/lib/ratelimit.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 
 static DEFINE_SPINLOCK(ratelimit_lock);
-static unsigned long flags;
 
 /*
  * __ratelimit - rate limiting
@@ -26,6 +25,8 @@ static unsigned long flags;
  */
 int __ratelimit(struct ratelimit_state *rs)
 {
+	unsigned long flags;
+
 	if (!rs->interval)
 		return 1;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
fix-__ratelimit-re-flags-cant-be-static.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

