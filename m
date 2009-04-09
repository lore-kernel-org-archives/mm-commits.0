From: akpm@linux-foundation.org
Subject: + update-nsigtrap-in-asm-generic-siginfoh.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:29:56 -0700
Message-ID: <200904092129.n39LTuOC003649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbZDIVcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:32:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, srinivasa@in.ibm.com


The patch titled
     asm-generic/siginfo.h: update NSIGTRAP definition
has been added to the -mm tree.  Its filename is
     update-nsigtrap-in-asm-generic-siginfoh.patch

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

x86-simplify-highmem-related-kconfig-entries.patch
update-nsigtrap-in-asm-generic-siginfoh.patch

