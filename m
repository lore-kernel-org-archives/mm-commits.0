From: akpm@linux-foundation.org
Subject: - docbook-add-pipes-other-fixes.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:00 -0700
Message-ID: <200707290613.l6T6D08s011160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbXG2GXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook: add pipes, other fixes
has been removed from the -mm tree.  Its filename was
     docbook-add-pipes-other-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook: add pipes, other fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix some typos in pipe.c and splice.c.  Add pipes API to kernel-api.tmpl.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |   13 +++++++++++--
 fs/pipe.c                             |    2 +-
 fs/splice.c                           |    4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-add-pipes-other-fixes Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-add-pipes-other-fixes
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -704,14 +704,23 @@ X!Idrivers/video/console/fonts.c
 
   <chapter id="splice">
       <title>splice API</title>
-  <para>)
+  <para>
 	splice is a method for moving blocks of data around inside the
-	kernel, without continually transferring it between the kernel
+	kernel, without continually transferring them between the kernel
 	and user space.
   </para>
 !Iinclude/linux/splice.h
 !Ffs/splice.c
   </chapter>
 
+  <chapter id="pipes">
+      <title>pipes API</title>
+  <para>
+	Pipe interfaces are all for in-kernel (builtin image) use.
+	They are not exported for use by modules.
+  </para>
+!Iinclude/linux/pipe_fs_i.h
+!Ffs/pipe.c
+  </chapter>
 
 </book>
diff -puN fs/pipe.c~docbook-add-pipes-other-fixes fs/pipe.c
--- a/fs/pipe.c~docbook-add-pipes-other-fixes
+++ a/fs/pipe.c
@@ -255,7 +255,7 @@ void generic_pipe_buf_get(struct pipe_in
 
 /**
  * generic_pipe_buf_confirm - verify contents of the pipe buffer
- * @pipe:	the pipe that the buffer belongs to
+ * @info:	the pipe that the buffer belongs to
  * @buf:	the buffer to confirm
  *
  * Description:
diff -puN fs/splice.c~docbook-add-pipes-other-fixes fs/splice.c
--- a/fs/splice.c~docbook-add-pipes-other-fixes
+++ a/fs/splice.c
@@ -164,7 +164,7 @@ static const struct pipe_buf_operations 
  * @spd:	data to fill
  *
  * Description:
- *    @spd contains a map of pages and len/offset tupples, a long with
+ *    @spd contains a map of pages and len/offset tuples, along with
  *    the struct pipe_buf_operations associated with these pages. This
  *    function will link that data to the pipe.
  *
@@ -1000,7 +1000,7 @@ static long do_splice_to(struct file *in
  * Description:
  *    This is a special case helper to splice directly between two
  *    points, without requiring an explicit pipe. Internally an allocated
- *    pipe is cached in the process, and reused during the life time of
+ *    pipe is cached in the process, and reused during the lifetime of
  *    that process.
  *
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
