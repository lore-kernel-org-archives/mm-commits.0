From: akpm@linux-foundation.org
Subject: + docbook-some-kernel-locking-fixes.patch added to -mm tree
Date: Thu, 03 Apr 2008 15:03:39 -0700
Message-ID: <200804032203.m33M3dqh024915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757025AbYDCWEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 18:04:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mattilinnanvuori@yahoo.com, randy.dunlap@oracle.com


The patch titled
     docbook: some kernel-locking fixes
has been added to the -mm tree.  Its filename is
     docbook-some-kernel-locking-fixes.patch

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
Subject: docbook: some kernel-locking fixes
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix a wrong path. Add a chapter about try functions.

http://bugzilla.kernel.org/show_bug.cgi?id=9011

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |   25 +++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~docbook-some-kernel-locking-fixes Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~docbook-some-kernel-locking-fixes
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -290,7 +290,7 @@
      <para>
        If you have a data structure which is only ever accessed from
        user context, then you can use a simple semaphore
-       (<filename>linux/asm/semaphore.h</filename>) to protect it.  This 
+       (<filename>include/asm/semaphore.h</filename>) to protect it.  This
        is the most trivial case: you initialize the semaphore to the number 
        of resources available (usually 1), and call
        <function>down_interruptible()</function> to grab the semaphore, and 
@@ -703,6 +703,29 @@
 </sect1>
 </chapter>
 
+<chapter id="try-variants">
+ <title>The try variants</title>
+
+  <para>
+    <function>spin_trylock()</function> does not spin but returns non-zero if
+    it acquires the spinlock on the first try or 0 if not.
+  </para>
+
+  <para>
+    <function>mutex_trylock()</function> does not suspend your task
+    but returns non-zero if it could lock the mutex on the first try
+    or 0 if not.
+  </para>
+
+  <para>
+    <function>down_trylock()</function> does not suspend your task
+    but returns 0 if it could get the semaphore on the first try or
+    non-zero if not. The return value is the inverse of that of
+    <function>spin_trylock()</function> and <function>mutex_trylock()
+    </function>.
+  </para>
+</chapter>
+
   <chapter id="Examples">
    <title>Common Examples</title>
     <para>
_

Patches currently in -mm which might be from mattilinnanvuori@yahoo.com are

origin.patch
docbook-some-kernel-locking-fixes.patch

