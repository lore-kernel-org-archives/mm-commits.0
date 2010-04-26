From: akpm@linux-foundation.org
Subject: + dynamic_debug-fix-documentation-errors.patch added to -mm tree
Date: Mon, 26 Apr 2010 12:19:14 -0700
Message-ID: <201004261919.o3QJJExo014365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab0DZTUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 15:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rafl@debian.org, jbaron@redhat.com


The patch titled
     DYNAMIC_DEBUG: fix documentation errors
has been added to the -mm tree.  Its filename is
     dynamic_debug-fix-documentation-errors.patch

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
Subject: DYNAMIC_DEBUG: fix documentation errors
From: Florian Ragwitz <rafl@debian.org>

Signed-off-by: Florian Ragwitz <rafl@debian.org>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dynamic_debug.h |    2 +-
 lib/Kconfig.debug             |   16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/dynamic_debug.h~dynamic_debug-fix-documentation-errors include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic_debug-fix-documentation-errors
+++ a/include/linux/dynamic_debug.h
@@ -28,7 +28,7 @@ struct _ddebug {
 	/*
  	 * The flags field controls the behaviour at the callsite.
  	 * The bits here are changed dynamically when the user
- 	 * writes commands to <debugfs>/dynamic_debug/ddebug
+ 	 * writes commands to <debugfs>/dynamic_debug/control
 	 */
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
 #define _DPRINTK_FLAGS_DEFAULT 0
diff -puN lib/Kconfig.debug~dynamic_debug-fix-documentation-errors lib/Kconfig.debug
--- a/lib/Kconfig.debug~dynamic_debug-fix-documentation-errors
+++ a/lib/Kconfig.debug
@@ -1027,10 +1027,10 @@ config DYNAMIC_DEBUG
 
 	  Usage:
 
-	  Dynamic debugging is controlled via the 'dynamic_debug/ddebug' file,
+	  Dynamic debugging is controlled via the 'dynamic_debug/control' file,
 	  which is contained in the 'debugfs' filesystem. Thus, the debugfs
 	  filesystem must first be mounted before making use of this feature.
-	  We refer the control file as: <debugfs>/dynamic_debug/ddebug. This
+	  We refer the control file as: <debugfs>/dynamic_debug/control. This
 	  file contains a list of the debug statements that can be enabled. The
 	  format for each line of the file is:
 
@@ -1045,7 +1045,7 @@ config DYNAMIC_DEBUG
 
 	  From a live system:
 
-		nullarbor:~ # cat <debugfs>/dynamic_debug/ddebug
+		nullarbor:~ # cat <debugfs>/dynamic_debug/control
 		# filename:lineno [module]function flags format
 		fs/aio.c:222 [aio]__put_ioctx - "__put_ioctx:\040freeing\040%p\012"
 		fs/aio.c:248 [aio]ioctx_alloc - "ENOMEM:\040nr_events\040too\040high\012"
@@ -1055,23 +1055,23 @@ config DYNAMIC_DEBUG
 
 		// enable the message at line 1603 of file svcsock.c
 		nullarbor:~ # echo -n 'file svcsock.c line 1603 +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all the messages in file svcsock.c
 		nullarbor:~ # echo -n 'file svcsock.c +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all the messages in the NFS server module
 		nullarbor:~ # echo -n 'module nfsd +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// enable all 12 messages in the function svc_process()
 		nullarbor:~ # echo -n 'func svc_process +p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 		// disable all 12 messages in the function svc_process()
 		nullarbor:~ # echo -n 'func svc_process -p' >
-						<debugfs>/dynamic_debug/ddebug
+						<debugfs>/dynamic_debug/control
 
 	  See Documentation/dynamic-debug-howto.txt for additional information.
 
_

Patches currently in -mm which might be from rafl@debian.org are

dynamic_debug-fix-documentation-errors.patch

