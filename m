From: akpm@osdl.org
Subject: + 9p-update-documentation-regarding-server-applications.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:15:51 -0800
Message-ID: <200701240715.l0O7FpsU011372@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55729 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXAXHPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:15:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericvh@gmail.com


The patch titled
     9p: update documentation regarding server applications
has been added to the -mm tree.  Its filename is
     9p-update-documentation-regarding-server-applications.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: update documentation regarding server applications
From: Eric Van Hensbergen <ericvh@gmail.com>

Update the documentation to cover using Inferno as a server for 9p and to
include information about spfs (a stable single-threaded stand-alone 9p
server).

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/9p.txt |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/9p.txt~9p-update-documentation-regarding-server-applications Documentation/filesystems/9p.txt
--- a/Documentation/filesystems/9p.txt~9p-update-documentation-regarding-server-applications
+++ a/Documentation/filesystems/9p.txt
@@ -73,8 +73,22 @@ OPTIONS
 RESOURCES
 =========
 
-The Linux version of the 9p server is now maintained under the npfs project
-on sourceforge (http://sourceforge.net/projects/npfs).
+Our current recommendation is to use Inferno (http://www.vitanuova.com/inferno)
+as the 9p server.  You can start a 9p server under Inferno by issuing the
+following command:
+   ; styxlisten -A tcp!*!564 export '#U*'
+
+The -A specifies an unauthenticated export.  The 564 is the port # (you may
+have to choose a higher port number if running as a normal user).  The '#U*'
+specifies exporting the root of the Linux name space.  You may specify a
+subset of the namespace by extending the path: '#U*'/tmp would just export
+/tmp.  For more information, see the Inferno manual pages covering styxlisten
+and export.
+
+A Linux version of the 9p server is now maintained under the npfs project
+on sourceforge (http://sourceforge.net/projects/npfs).  There is also a
+more stable single-threaded version of the server (named spfs) available from
+the same CVS repository.
 
 There are user and developer mailing lists available through the v9fs project
 on sourceforge (http://sourceforge.net/projects/v9fs).
@@ -96,5 +110,5 @@ STATUS
 
 The 2.6 kernel support is working on PPC and x86.
 
-PLEASE USE THE SOURCEFORGE BUG-TRACKER TO REPORT PROBLEMS.
+PLEASE USE THE KERNEL BUGZILLA TO REPORT PROBLEMS. (http://bugzilla.kernel.org)
 
_

Patches currently in -mm which might be from ericvh@gmail.com are

9p-fix-bogus-return-code-checks-during-initialization.patch
9p-fix-rename-return-code.patch
9p-update-documentation-regarding-server-applications.patch
9p-fix-segfault-caused-by-race-condition-in-meta-data-operations.patch
9p-null-terminate-error-strings-for-debug-print.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
