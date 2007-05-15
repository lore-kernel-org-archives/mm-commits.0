From: akpm@linux-foundation.org
Subject: + make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size.patch added to -mm tree
Date: Tue, 15 May 2007 11:39:37 -0700
Message-ID: <200705151839.l4FIdcTq014727@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751AbXEOSku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: da-x@monatomic.org


The patch titled
     make sysctl/kernel/core_pattern and fs/exec.c agree on maximum core filename size
has been added to the -mm tree.  Its filename is
     make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make sysctl/kernel/core_pattern and fs/exec.c agree on maximum core filename size
From: Dan Aloni <da-x@monatomic.org>

Make sysctl/kernel/core_pattern and fs/exec.c agree on maximum core
filename size and change it to 128, so that extensive patterns such as
'/local/cores/%e-%h-%s-%t-%p.core' won't result in truncated filename
generation.

Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    4 +---
 include/linux/binfmts.h |    2 ++
 kernel/sysctl.c         |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size fs/exec.c
--- a/fs/exec.c~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size
+++ a/fs/exec.c
@@ -60,7 +60,7 @@
 #endif
 
 int core_uses_pid;
-char core_pattern[128] = "core";
+char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
 
 EXPORT_SYMBOL(suid_dumpable);
@@ -1264,8 +1264,6 @@ int set_binfmt(struct linux_binfmt *new)
 
 EXPORT_SYMBOL(set_binfmt);
 
-#define CORENAME_MAX_SIZE 64
-
 /* format_corename will inspect the pattern parameter, and output a
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
diff -puN include/linux/binfmts.h~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size include/linux/binfmts.h
--- a/include/linux/binfmts.h~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size
+++ a/include/linux/binfmts.h
@@ -17,6 +17,8 @@ struct pt_regs;
 
 #ifdef __KERNEL__
 
+#define CORENAME_MAX_SIZE 128
+
 /*
  * This structure is used to hold the arguments that are used when loading binaries.
  */
diff -puN kernel/sysctl.c~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size kernel/sysctl.c
--- a/kernel/sysctl.c~make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size
+++ a/kernel/sysctl.c
@@ -227,7 +227,7 @@ static ctl_table kern_table[] = {
 		.ctl_name	= KERN_CORE_PATTERN,
 		.procname	= "core_pattern",
 		.data		= core_pattern,
-		.maxlen		= 128,
+		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
_

Patches currently in -mm which might be from da-x@monatomic.org are

fix-i-oat-for-kexec.patch
make-sysctl-kernel-core_pattern-and-fs-execc-agree-on-maximum-core-filename-size.patch
