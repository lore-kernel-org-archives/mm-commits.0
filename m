From: akpm@linux-foundation.org
Subject: + fallocate-on-ia64-fix.patch added to -mm tree
Date: Sun, 20 May 2007 23:08:15 -0700
Message-ID: <200705210608.l4L68H51003745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbXEUGKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 02:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, dgc@sgi.com, tony.luck@intel.com


The patch titled
     fallocate-on-ia64 fix
has been added to the -mm tree.  Its filename is
     fallocate-on-ia64-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
 #define __ARCH_WANT_SYS_RT_SIGACTION
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
_

Patches currently in -mm which might be from cmm@us.ibm.com are

ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
fallocate-on-ia64-fix.patch
