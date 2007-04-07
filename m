From: akpm@linux-foundation.org
Subject: + i386-schedh-inclusion-from-moduleh-is-baack.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:09:31 -0700
Message-ID: <200704070009.l3709VP1023331@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933408AbXDGAJd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     i386: sched.h inclusion from module.h is baack
has been added to the -mm tree.  Its filename is
     i386-schedh-inclusion-from-moduleh-is-baack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: sched.h inclusion from module.h is baack
From: Alexey Dobriyan <adobriyan@gmail.com>

  linux/module.h
  -> linux/elf.h
     -> asm-i386/elf.h
        -> linux/utsname.h
           -> linux/sched.h

Noticeably cut the number of files which are rebuild upon touching sched.h
and cut down pulled junk from every module.h inclusion.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c     |    1 +
 fs/binfmt_elf.c        |    1 +
 include/asm-i386/elf.h |    2 --
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/i8k.c~i386-schedh-inclusion-from-moduleh-is-baack drivers/char/i8k.c
--- a/drivers/char/i8k.c~i386-schedh-inclusion-from-moduleh-is-baack
+++ a/drivers/char/i8k.c
@@ -22,6 +22,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/dmi.h>
+#include <linux/capability.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff -puN fs/binfmt_elf.c~i386-schedh-inclusion-from-moduleh-is-baack fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-schedh-inclusion-from-moduleh-is-baack
+++ a/fs/binfmt_elf.c
@@ -38,6 +38,7 @@
 #include <linux/syscalls.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/utsname.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
diff -puN include/asm-i386/elf.h~i386-schedh-inclusion-from-moduleh-is-baack include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~i386-schedh-inclusion-from-moduleh-is-baack
+++ a/include/asm-i386/elf.h
@@ -9,8 +9,6 @@
 #include <asm/user.h>
 #include <asm/auxvec.h>
 
-#include <linux/utsname.h>
-
 #define R_386_NONE	0
 #define R_386_32	1
 #define R_386_PC32	2
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
i386-schedh-inclusion-from-moduleh-is-baack.patch
