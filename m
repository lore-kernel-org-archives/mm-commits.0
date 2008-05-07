From: akpm@linux-foundation.org
Subject: + idr-change-the-idr-structure.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:22 -0700
Message-ID: <200805072040.m47KeMHU015456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYEGUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: change the idr structure
has been added to the -mm tree.  Its filename is
     idr-change-the-idr-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: change the idr structure
From: Nadia Derbey <Nadia.Derbey@bull.net>

Add an rcu_head to the idr_layer structure in order to free it after a grace
period.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/idr.h~idr-change-the-idr-structure include/linux/idr.h
--- a/include/linux/idr.h~idr-change-the-idr-structure
+++ a/include/linux/idr.h
@@ -16,6 +16,7 @@
 #include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/rcupdate.h>
 
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
@@ -52,6 +53,7 @@ struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct idr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	struct rcu_head		 rcu_head;
 };
 
 struct idr {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

