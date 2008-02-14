From: akpm@linux-foundation.org
Subject: - docbook-move-pipe-and-splice-to-filesystems-docbook.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:22:35 -0500
Message-ID: <200802150225.m1F2PswM015192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758100AbYBOC0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook: move pipe and splice to filesystems docbook
has been removed from the -mm tree.  Its filename was
     docbook-move-pipe-and-splice-to-filesystems-docbook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: move pipe and splice to filesystems docbook
From: Randy Dunlap <randy.dunlap@oracle.com>

Move pipes and splice docbook to filesystems book.
kernel-api book is huge (10x most other books) & slow to process.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/filesystems.tmpl |   20 ++++++++++++++++++++
 Documentation/DocBook/kernel-api.tmpl  |   20 --------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN Documentation/DocBook/filesystems.tmpl~docbook-move-pipe-and-splice-to-filesystems-docbook Documentation/DocBook/filesystems.tmpl
--- a/Documentation/DocBook/filesystems.tmpl~docbook-move-pipe-and-splice-to-filesystems-docbook
+++ a/Documentation/DocBook/filesystems.tmpl
@@ -398,4 +398,24 @@ an example.
 
   </chapter>
 
+  <chapter id="splice">
+      <title>splice API</title>
+  <para>
+	splice is a method for moving blocks of data around inside the
+	kernel, without continually transferring them between the kernel
+	and user space.
+  </para>
+!Ffs/splice.c
+  </chapter>
+
+  <chapter id="pipes">
+      <title>pipes API</title>
+  <para>
+	Pipe interfaces are all for in-kernel (builtin image) use.
+	They are not exported for use by modules.
+  </para>
+!Iinclude/linux/pipe_fs_i.h
+!Ffs/pipe.c
+  </chapter>
+
 </book>
diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-move-pipe-and-splice-to-filesystems-docbook Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-move-pipe-and-splice-to-filesystems-docbook
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -712,24 +712,4 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/i2c/i2c-core.c
   </chapter>
 
-  <chapter id="splice">
-      <title>splice API</title>
-  <para>
-	splice is a method for moving blocks of data around inside the
-	kernel, without continually transferring them between the kernel
-	and user space.
-  </para>
-!Ffs/splice.c
-  </chapter>
-
-  <chapter id="pipes">
-      <title>pipes API</title>
-  <para>
-	Pipe interfaces are all for in-kernel (builtin image) use.
-	They are not exported for use by modules.
-  </para>
-!Iinclude/linux/pipe_fs_i.h
-!Ffs/pipe.c
-  </chapter>
-
 </book>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-remove-fastcall.patch
git-acpi.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-visws-fix-printk-format-warnings.patch
profile-likely-unlikely-macros.patch
