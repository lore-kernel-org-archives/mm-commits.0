From: akpm@linux-foundation.org
Subject: [merged] kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch removed from -mm tree
Date: Fri, 18 Mar 2011 11:42:24 -0700
Message-ID: <201103181845.p2IIj6aH004680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab1CRSpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Mar 2011 14:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tdent48227@gmail.com, oberpar@linux.vnet.ibm.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel/gcov/Makefile: use proper ccflag flag in Makefile
has been removed from the -mm tree.  Its filename was
     kernel-gcov-makefile-use-proper-ccflag-flag-in-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

