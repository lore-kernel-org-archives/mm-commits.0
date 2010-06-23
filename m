From: akpm@linux-foundation.org
Subject: + procfs-simplify-conditional-processing-of-fs-proco.patch added to -mm tree
Date: Wed, 23 Jun 2010 13:04:59 -0700
Message-ID: <201006232004.o5NK4xd4028690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab0FWUFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 16:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     procfs: simplify conditional processing of fs/proc.o.
has been added to the -mm tree.  Its filename is
     procfs-simplify-conditional-processing-of-fs-proco.patch

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
Subject: procfs: simplify conditional processing of fs/proc.o.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since the entire fs/proc directory is conditionally included based on
CONFIG_PROC_FS, it's redundant to check that same variable within that
directory.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/Makefile~procfs-simplify-conditional-processing-of-fs-proco fs/proc/Makefile
--- a/fs/proc/Makefile~procfs-simplify-conditional-processing-of-fs-proco
+++ a/fs/proc/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the Linux proc filesystem routines.
 #
 
-obj-$(CONFIG_PROC_FS) += proc.o
+obj-y   += proc.o
 
 proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

procfs-simplify-conditional-processing-of-fs-proco.patch
kfifo-kfifo_is_fullempty-should-return-bools-not-ints.patch

