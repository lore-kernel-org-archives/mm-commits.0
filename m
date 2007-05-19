From: akpm@linux-foundation.org
Subject: + fallocate-on-ia64.patch added to -mm tree
Date: Fri, 18 May 2007 23:42:19 -0700
Message-ID: <200705190642.l4J6gIE6031449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbXESGoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 02:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgc@sgi.com, tony.luck@intel.com


The patch titled
     fallocate() on ia64
has been added to the -mm tree.  Its filename is
     fallocate-on-ia64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fallocate() on ia64
From: David Chinner <dgc@sgi.com>

ia64 fallocate syscall support.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/entry.S  |    1 +
 include/asm-ia64/unistd.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/ia64/kernel/entry.S~fallocate-on-ia64 arch/ia64/kernel/entry.S
--- a/arch/ia64/kernel/entry.S~fallocate-on-ia64
+++ a/arch/ia64/kernel/entry.S
@@ -1588,5 +1588,6 @@ sys_call_table:
 	data8 sys_signalfd
 	data8 sys_timerfd
 	data8 sys_eventfd
+	data8 sys_fallocate			// 1310
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
diff -puN include/asm-ia64/unistd.h~fallocate-on-ia64 include/asm-ia64/unistd.h
--- a/include/asm-ia64/unistd.h~fallocate-on-ia64
+++ a/include/asm-ia64/unistd.h
@@ -299,6 +299,7 @@
 #define __NR_signalfd			1307
 #define __NR_timerfd			1308
 #define __NR_eventfd			1309
+#define __NR_fallocate			1310
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from dgc@sgi.com are

origin.patch
git-xfs.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
fallocate-on-ia64.patch
