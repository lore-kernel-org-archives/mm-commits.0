From: akpm@linux-foundation.org
Subject: - fallocate-on-ia64-fix.patch removed from -mm tree
Date: Tue, 10 Jul 2007 02:14:42 -0700
Message-ID: <200707100914.l6A9EgER021013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756244AbXGJJPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 05:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, dgc@sgi.com, mark.fasheh@oracle.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fallocate-on-ia64 fix
has been removed from the -mm tree.  Its filename was
     fallocate-on-ia64-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fallocate-on-ia64 fix
From: Mingming Cao <cmm@us.ibm.com>

In case you haven't realize it, the ia64 fallocate() patch comes with
Amit's takes 4 fallocate patch series (3/6) missing one line change,
thus fail to compile on ia64.

Here is the updated one. Patch tested on ia64. (compile and fsx)

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/unistd.h~fallocate-on-ia64-fix include/asm-ia64/unistd.h
--- a/include/asm-ia64/unistd.h~fallocate-on-ia64-fix
+++ a/include/asm-ia64/unistd.h
@@ -304,7 +304,7 @@
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			286 /* length of syscall table */
+#define NR_syscalls			287 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
_

Patches currently in -mm which might be from cmm@us.ibm.com are

ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
fallocate-on-ia64-fix.patch
