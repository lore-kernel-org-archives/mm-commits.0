From: akpm@linux-foundation.org
Subject: + init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch added to -mm tree
Date: Tue, 06 May 2008 13:22:41 -0700
Message-ID: <200805062022.m46KMf92025489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbYEFUXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:23:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     init/: delete hard-coded setting and testing of BUILD_CRAMDISK
has been added to the -mm tree.  Its filename is
     init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch

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
Subject: init/: delete hard-coded setting and testing of BUILD_CRAMDISK
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

There seems to be little point in explicitly setting, then testing the macro
BUILD_CRAMDISK within the context of a single source file.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN init/do_mounts_rd.c~init-delete-hard-coded-setting-and-testing-of-build_cramdisk init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-delete-hard-coded-setting-and-testing-of-build_cramdisk
+++ a/init/do_mounts_rd.c
@@ -10,8 +10,6 @@
 
 #include "do_mounts.h"
 
-#define BUILD_CRAMDISK
-
 int __initdata rd_prompt = 1;/* 1 = prompt for RAM disk, 0 = don't prompt */
 
 static int __init prompt_ramdisk(char *str)
@@ -162,14 +160,8 @@ int __init rd_load_image(char *from)
 		goto done;
 
 	if (nblocks == 0) {
-#ifdef BUILD_CRAMDISK
 		if (crd_load(in_fd, out_fd) == 0)
 			goto successful_load;
-#else
-		printk(KERN_NOTICE
-		       "RAMDISK: Kernel does not support compressed "
-		       "RAM disk images\n");
-#endif
 		goto done;
 	}
 
@@ -267,8 +259,6 @@ int __init rd_load_disk(int n)
 	return rd_load_image("/dev/root");
 }
 
-#ifdef BUILD_CRAMDISK
-
 /*
  * gzip declarations
  */
@@ -425,5 +415,3 @@ static int __init crd_load(int in_fd, in
 	kfree(window);
 	return result;
 }
