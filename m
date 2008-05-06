From: akpm@linux-foundation.org
Subject: + uml-fix-config_raw-dependencies.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:31 -0700
Message-ID: <200805062049.m46KnVZ4026588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765092AbYEFUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: fix CONFIG_RAW dependencies
has been added to the -mm tree.  Its filename is
     uml-fix-config_raw-dependencies.patch

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
Subject: uml: fix CONFIG_RAW dependencies
From: Robert P. J. Day <rpjday@crashcourse.ca>

Add the BLOCK dependency for RAW_DRIVER, to match what's in
drivers/char/Kconfig.  Also, while we're there, update the alleged
obsolesence of RAW_DRIVER since it doesn't seem to be going away any
time soon.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.char |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/Kconfig.char~uml-fix-config_raw-dependencies arch/um/Kconfig.char
--- a/arch/um/Kconfig.char~uml-fix-config_raw-dependencies
+++ a/arch/um/Kconfig.char
@@ -143,14 +143,14 @@ config LEGACY_PTYS
 	  systems, it is safe to say N.
 
 config RAW_DRIVER
-        tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
+        tristate "RAW driver (/dev/raw/rawN)"
+	depends on BLOCK
         help
           The raw driver permits block devices to be bound to /dev/raw/rawN.
           Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
           See the raw(8) manpage for more details.
 
-          The raw driver is deprecated and will be removed soon.
-          Applications should simply open the device (eg /dev/hda1)
+          Applications should preferably open the device (eg /dev/hda1)
           with the O_DIRECT flag.
 
 config MAX_RAW_DEVS
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
mn10300-replace-deprecated-topdir-with-newer-srctree.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch

