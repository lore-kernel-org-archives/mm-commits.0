From: akpm@linux-foundation.org
Subject: [folded] mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:01:52 -0800
Message-ID: <200902112101.n1BL1roQ028108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426AbZBKVCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:02:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, sven.wegener@stealer.net, mm-commits@vger.kernel.org


The patch titled
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches fix
has been removed from the -mm tree.  Its filename was
     mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch

This patch was dropped because it was folded into mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch

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

mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch
oom_kill-dont-call-for-int_sqrt0.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch

