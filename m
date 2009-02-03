From: akpm@linux-foundation.org
Subject: + mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch added to -mm tree
Date: Mon, 02 Feb 2009 23:14:39 -0800
Message-ID: <200902030714.n137EdkG009336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZBCHPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, sven.wegener@stealer.net


The patch titled
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches fix
has been added to the -mm tree.  Its filename is
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch

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
Subject: mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches fix
From: David Rientjes <rientjes@google.com>

You'll also need the following since vm_dirty_bytes is declared as an
unsigned long.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Sven Wegener <sven.wegener@stealer.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix
+++ a/mm/page-writeback.c
@@ -209,7 +209,7 @@ int dirty_bytes_handler(struct ctl_table
 		struct file *filp, void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int old_bytes = vm_dirty_bytes;
+	unsigned long old_bytes = vm_dirty_bytes;
 	int ret;
 
 	ret = proc_doulongvec_minmax(table, write, filp, buffer, lenp, ppos);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch
oom_kill-dont-call-for-int_sqrt0.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch

