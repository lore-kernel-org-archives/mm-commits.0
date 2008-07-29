From: akpm@linux-foundation.org
Subject: - fix-__ratelimit-re-flags-cant-be-static.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:36 -0700
Message-ID: <200807292029.m6TKTakI019713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYG2U3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, hidave.darkstar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     __ratelimit() cpu flags can't be static
has been removed from the -mm tree.  Its filename was
     fix-__ratelimit-re-flags-cant-be-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

hpwdt-dont-use-static-flags.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
vt8623fb-fix-kernel-oops.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

