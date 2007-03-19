From: akpm@linux-foundation.org
Subject: + ptrace-needs-proc_fs.patch added to -mm tree
Date: Mon, 19 Mar 2007 15:44:18 -0700
Message-ID: <200703192244.l2JMiI1Z019685@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280AbXCSWok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     ptrace needs PROC_FS
has been added to the -mm tree.  Its filename is
     ptrace-needs-proc_fs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ptrace needs PROC_FS
From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_PTRACE needs PROC_FS; with CONFIG_PROC_FS=n (x86_64):

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `ptrace_start':
ptrace.c:(.text+0x300f9): undefined reference to `ptrace_may_attach'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~ptrace-needs-proc_fs init/Kconfig
--- a/init/Kconfig~ptrace-needs-proc_fs
+++ a/init/Kconfig
@@ -650,7 +650,7 @@ config UTRACE
 config PTRACE
 	bool "Legacy ptrace system call interface"
 	default y
-	depends on UTRACE
+	depends on UTRACE && PROC_FS
 	help
 	  Enable the ptrace system call.
 	  This is traditionally used by debuggers like GDB,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
git-drm.patch
git-libata-all.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
