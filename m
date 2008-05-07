From: akpm@linux-foundation.org
Subject: + idr-change-the-idr-structure.patch added to -mm tree
Date: Wed, 07 May 2008 13:41:06 -0700
Message-ID: <200805072041.m47Kf73t015494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbYEGUoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:44:09 -0400
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

After scalability problems have been detected when using the sysV ipcs, I have
proposed to use an RCU based implementation of the IDR api instead (see
threads http://lkml.org/lkml/2008/4/11/212 and
http://lkml.org/lkml/2008/4/29/295).

This resulted in many people asking to convert the idr API and make it rcu
safe (because most of the code was duplicated and thus unmaintanable and
unreviewable).

So here is a first attempt.

The important change wrt to the idr API itself is during idr removes: idr
layers are freed after a grace period, instead of being moved to the free
list.

The important change wrt to ipcs, is that idr_find() can now be called
locklessly inside a rcu read critical section.

Here are the results I've got for the pmsg test sent by Manfred: 

   2.6.25-rc3-mm1   2.6.25-rc3-mm1+   2.6.25-mm1   Patched 2.6.25-mm1
1         1168441           1064021       876000               947488
2         1094264            921059      1549592              1730685
3         2082520           1738165      1694370              2324880
4         2079929           1695521       404553              2400408
5         2898758            406566       391283              3246580
6         2921417            261275       263249              3752148
7         3308761            126056       191742              4243142
8         3329456            100129       141722              4275780

1st column: stock 2.6.25-rc3-mm1
2nd column: 2.6.25-rc3-mm1 + ipc patches (store ipcs into idrs)
3nd column: stock 2.6.25-mm1
4th column: 2.6.25-mm1 + this pacth series.




This patch:

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

