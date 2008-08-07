From: akpm@linux-foundation.org
Subject: + inith-remove-long-dead-__setup_null_param-macro.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:09:07 -0700
Message-ID: <200808072009.m77K97AA003031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654AbYHGULV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     init.h: remove long-dead __setup_null_param() macro
has been added to the -mm tree.  Its filename is
     inith-remove-long-dead-__setup_null_param-macro.patch

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
Subject: init.h: remove long-dead __setup_null_param() macro
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

This macro appears to have been unused for ages, and there are no
invocations of it anywhere in the source tree.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/linux/init.h~inith-remove-long-dead-__setup_null_param-macro include/linux/init.h
--- a/include/linux/init.h~inith-remove-long-dead-__setup_null_param-macro
+++ a/include/linux/init.h
@@ -232,9 +232,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
 
-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
-
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)
 
@@ -295,7 +292,6 @@ void __init parse_early_param(void);
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
 #define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-kbuild-fixes.patch
m32r-remove-the-unused-nohighmem-option.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
uml-remove-the-dead-tty_log-code.patch
inith-remove-long-dead-__setup_null_param-macro.patch
oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch
fs-partitions-acornc-remove-dead-code.patch

