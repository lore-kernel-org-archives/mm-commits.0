From: akpm@linux-foundation.org
Subject: [withdrawn]
 dont-let-latencytop-and-lockdep-select-kallsyms_all.patch removed from -mm
 tree
Date: Thu, 09 Apr 2015 13:03:31 -0700
Message-ID: <5526db13.6NkAH3k5AfZmkJQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbbDIUDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 16:03:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: don't let LATENCYTOP and LOCKDEP select KALLSYMS_ALL
has been removed from the -mm tree.  Its filename was
     dont-let-latencytop-and-lockdep-select-kallsyms_all.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: lib/Kconfig.debug: don't let LATENCYTOP and LOCKDEP select KALLSYMS_ALL

KALLSYMS_ALL enables including data variables into KALLSYMS.  With plain
KALLSYMS only functions are included.

LATENCYTOP and LOCKDEP select KALLSYMS_ALL in addition to KALLSYMS.  It's
unclear what they actually need _ALL for; they should only need function
backtraces and afaik never touch variables.

LTO currently does not support KALLSYMS_ALL, which prevents LATENCYTOP and
LOCKDEP from working and gives Kconfig errors.  Disable the requirement
for KALLSYMS_ALL for them, just use KALLSYMS.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/Kconfig.debug~dont-let-latencytop-and-lockdep-select-kallsyms_all lib/Kconfig.debug
--- a/lib/Kconfig.debug~dont-let-latencytop-and-lockdep-select-kallsyms_all
+++ a/lib/Kconfig.debug
@@ -1001,7 +1001,6 @@ config LOCKDEP
 	select STACKTRACE
 	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC && !SCORE
 	select KALLSYMS
-	select KALLSYMS_ALL
 
 config LOCK_STAT
 	bool "Lock usage statistics"
@@ -1469,7 +1468,6 @@ config LATENCYTOP
 	depends on PROC_FS
 	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
 	select KALLSYMS
-	select KALLSYMS_ALL
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
test-hexdumpc-fix-initconst-confusion.patch
lto-add-__noreorder-and-mark-initcalls-__noreorder.patch
linux-next.patch
gitignore-ignore-tar.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

