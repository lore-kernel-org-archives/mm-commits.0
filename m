From: akpm@linux-foundation.org
Subject: + kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch added to -mm tree
Date: Mon, 24 Jan 2011 13:36:04 -0800
Message-ID: <201101242136.p0OLa4aY011837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab1AXVgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 16:36:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, oberpar@linux.vnet.ibm.com, xiyou.wangcong@gmail.com


The patch titled
     kernel/gcov/Makefile: use proper ccflag flag in Makefile
has been added to the -mm tree.  Its filename is
     kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch

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
Subject: kernel/gcov/Makefile: use proper ccflag flag in Makefile
From: Tracey Dent <tdent48227@gmail.com>

Use the ccflags-y flag instead of EXTRA_CFLAGS because EXTRA_CFLAGS is
deprecated and should now be switched.  According to
(documentation/kbuild/makefiles.txt)

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/Makefile~kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile kernel/gcov/Makefile
--- a/kernel/gcov/Makefile~kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile
+++ a/kernel/gcov/Makefile
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
 obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

drivers-block-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-block-aoe-makefile-replace-the-use-of-module-objs-with-module-y.patch
kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch

