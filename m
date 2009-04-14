From: akpm@linux-foundation.org
Subject: [merged] update-nsigtrap-in-asm-generic-siginfoh.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:16 -0700
Message-ID: <200904141949.n3EJnG1T019565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbZDNTwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, srinivasa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/siginfo.h: update NSIGTRAP definition
has been removed from the -mm tree.  Its filename was
     update-nsigtrap-in-asm-generic-siginfoh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/siginfo.h: update NSIGTRAP definition
From: Andi Kleen <andi@firstfloor.org>

Impact: (nearly) trivial

The patch

commit da654b74bda14c45a7d98c731bf3c1a43b6b74e2
Author: Srinivasa Ds <srinivasa@in.ibm.com>
Date:   Tue Sep 23 15:23:52 2008 +0530

    signals: demultiplexing SIGTRAP signal

forgot to update the NSIGTRAP define in asm-generic/siginfo.h to the new
number of sigtrap subcodes.  Nothing in the tree seems to use it, but
presumably something in user space might.  So update it.

Cc: Srinivasa Ds <srinivasa@in.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/siginfo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/siginfo.h~update-nsigtrap-in-asm-generic-siginfoh include/asm-generic/siginfo.h
--- a/include/asm-generic/siginfo.h~update-nsigtrap-in-asm-generic-siginfoh
+++ a/include/asm-generic/siginfo.h
@@ -201,7 +201,7 @@ typedef struct siginfo {
 #define TRAP_TRACE	(__SI_FAULT|2)	/* process trace trap */
 #define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
 #define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint/watchpoint */
-#define NSIGTRAP	2
+#define NSIGTRAP	4
 
 /*
  * SIGCHLD si_codes
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
x86-simplify-highmem-related-kconfig-entries.patch

