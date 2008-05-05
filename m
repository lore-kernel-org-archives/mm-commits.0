From: akpm@linux-foundation.org
Subject: - docbook-some-kernel-locking-fixes.patch removed from -mm tree
Date: Sun, 04 May 2008 18:53:08 -0700
Message-ID: <200805050153.m451r8rl025264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbYEEBxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 4 May 2008 21:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mattilinnanvuori@yahoo.com, randy.dunlap@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     docbook: some kernel-locking fixes
has been removed from the -mm tree.  Its filename was
     docbook-some-kernel-locking-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: some kernel-locking fixes
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix a wrong path. Add a chapter about try functions.

http://bugzilla.kernel.org/show_bug.cgi?id=9011

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN Documentation/DocBook/kernel-locking.tmpl~docbook-some-kernel-locking-fixes Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~docbook-some-kernel-locking-fixes
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -694,6 +694,29 @@
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

