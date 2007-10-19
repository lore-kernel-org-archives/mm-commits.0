From: akpm@linux-foundation.org
Subject: - extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:30:57 -0700
Message-ID: <200710190430.l9J4Uv0D015176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966635AbXJSEbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, olecom@flower.upol.cz, mm-commits@vger.kernel.org


The patch titled
     Improve error handling in parse_crashkernel_mem()
has been removed from the -mm tree.  Its filename was
     extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch

This patch was dropped because it was folded into extended-crashkernel-command-line.patch

------------------------------------------------------
Subject: Improve error handling in parse_crashkernel_mem()
From: Bernhard Walle <bwalle@suse.de>

Improve error handling in parse_crashkernel_mem() by comparing the return
pointer of memparse() with the input pointer and also replaces all
printk(KERN_WARNING msg) with pr_warning(msg).

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Reviewed-by: Oleg Verych <olecom@flower.upol.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/kexec.c~extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem kernel/kexec.c
--- a/kernel/kexec.c~extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem
+++ a/kernel/kexec.c
@@ -1166,44 +1166,59 @@ static int __init parse_crashkernel_mem(
 					unsigned long long	*crash_size,
 					unsigned long long	*crash_base)
 {
-	char *cur = cmdline;
+	char *cur = cmdline, *tmp;
 
 	/* for each entry of the comma-separated list */
 	do {
-		unsigned long long start = 0, end = ULLONG_MAX;
-		unsigned long long size = -1;
+		unsigned long long start, end = ULLONG_MAX, size;
 
 		/* get the start of the range */
-		start = memparse(cur, &cur);
+		start = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("crashkernel: Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
 		if (*cur != '-') {
-			printk(KERN_WARNING "crashkernel: '-' expected\n");
+			pr_warning("crashkernel: '-' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
 		/* if no ':' is here, than we read the end */
 		if (*cur != ':') {
-			end = memparse(cur, &cur);
+			end = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("crashkernel: Memory "
+						"value expected\n");
+				return -EINVAL;
+			}
+			cur = tmp;
 			if (end <= start) {
-				printk(KERN_WARNING "crashkernel: end <= start\n");
+				pr_warning("crashkernel: end <= start\n");
 				return -EINVAL;
 			}
 		}
 
 		if (*cur != ':') {
-			printk(KERN_WARNING "crashkernel: ':' expected\n");
+			pr_warning("crashkernel: ':' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
-		size = memparse(cur, &cur);
-		if (size < 0) {
-			printk(KERN_WARNING "crashkernel: invalid size\n");
+		size = memparse(cur, &tmp);
+		if (cur == tmp) {
+			pr_warning("Memory value expected\n");
+			return -EINVAL;
+		}
+		cur = tmp;
+		if (size >= system_ram) {
+			pr_warning("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
 		/* match ? */
-		if (system_ram >= start  && system_ram <= end) {
+		if (system_ram >= start && system_ram <= end) {
 			*crash_size = size;
 			break;
 		}
@@ -1212,8 +1227,15 @@ static int __init parse_crashkernel_mem(
 	if (*crash_size > 0) {
 		while (*cur != ' ' && *cur != '@')
 			cur++;
-		if (*cur == '@')
-			*crash_base = memparse(cur+1, &cur);
+		if (*cur == '@') {
+			cur++;
+			*crash_base = memparse(cur, &tmp);
+			if (cur == tmp) {
+				pr_warning("Memory value expected "
+						"after '@'\n");
+				return -EINVAL;
+			}
+		}
 	}
 
 	return 0;
@@ -1233,8 +1255,10 @@ static int __init parse_crashkernel_simp
 	char *cur = cmdline;
 
 	*crash_size = memparse(cmdline, &cur);
-	if (cmdline == cur)
+	if (cmdline == cur) {
+		pr_warning("crashkernel: memory value expected\n");
 		return -EINVAL;
+	}
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
