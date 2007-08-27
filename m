From: akpm@linux-foundation.org
Subject: + drop-some-headers-from-mmh.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:26:36 -0700
Message-ID: <200708272126.l7RLQaB4028880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784AbXH0V1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     Drop some headers from mm.h
has been added to the -mm tree.  Its filename is
     drop-some-headers-from-mmh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Drop some headers from mm.h
From: Alexey Dobriyan <adobriyan@gmail.com>

mm.h doesn't use directly anything from mutex.h and backing-dev.h, so
remove them and add them back to files which need them.

Cross-compile tested on many configs and archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c     |    2 +-
 include/linux/mm.h |    2 --
 mm/fremap.c        |    2 +-
 mm/mmap.c          |    1 +
 mm/truncate.c      |    1 +
 5 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/afs/write.c~drop-some-headers-from-mmh fs/afs/write.c
--- a/fs/afs/write.c~drop-some-headers-from-mmh
+++ a/fs/afs/write.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
-
+#include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
diff -puN include/linux/mm.h~drop-some-headers-from-mmh include/linux/mm.h
--- a/include/linux/mm.h~drop-some-headers-from-mmh
+++ a/include/linux/mm.h
@@ -10,9 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
 #include <linux/prio_tree.h>
-#include <linux/mutex.h>
 #include <linux/debug_locks.h>
-#include <linux/backing-dev.h>
 #include <linux/mm_types.h>
 
 struct mempolicy;
diff -puN mm/fremap.c~drop-some-headers-from-mmh mm/fremap.c
--- a/mm/fremap.c~drop-some-headers-from-mmh
+++ a/mm/fremap.c
@@ -5,7 +5,7 @@
  *
  * started by Ingo Molnar, Copyright (C) 2002, 2003
  */
-
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/file.h>
diff -puN mm/mmap.c~drop-some-headers-from-mmh mm/mmap.c
--- a/mm/mmap.c~drop-some-headers-from-mmh
+++ a/mm/mmap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/shm.h>
 #include <linux/mman.h>
diff -puN mm/truncate.c~drop-some-headers-from-mmh mm/truncate.c
--- a/mm/truncate.c~drop-some-headers-from-mmh
+++ a/mm/truncate.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/backing-dev.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
nfs-fix-oops-re-sysctls-and-v4-support.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
shrink-struct-task_structoomkilladj.patch
remove-struct-task_structio_wait.patch
drop-some-headers-from-mmh.patch
revert-faster-ext2_clear_inode.patch
