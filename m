From: akpm@linux-foundation.org
Subject: + docbook-move-pipe-and-splice-to-filesystems-docbook.patch added to -mm tree
Date: Mon, 11 Feb 2008 23:52:12 -0800
Message-ID: <200802120753.m1C7rKC3024663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbYBLHyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 02:54:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com


The patch titled
     docbook: move pipe and splice to filesystems docbook
has been added to the -mm tree.  Its filename is
     docbook-move-pipe-and-splice-to-filesystems-docbook.patch

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
kernel-doc-fix-fs-pipec-notation.patch
docbook-move-pipe-and-splice-to-filesystems-docbook.patch
docbook-sunrpc-filenames-and-notation-fixes.patch
docbook-make-a-networking-book-and-fix-a-few-errors.patch
apanel-fix-kconfig-dependencies.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
profile-likely-unlikely-macros.patch
