From: akpm@linux-foundation.org
Subject: - uml-deal-with-inaccessible-address-space-start.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:43 -0700
Message-ID: <200806081947.m58JlhUn017439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277AbYFHTrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tspink@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: deal with inaccessible address space start
has been removed from the -mm tree.  Its filename was
     uml-deal-with-inaccessible-address-space-start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: deal with inaccessible address space start
From: Tom Spink <tspink@gmail.com>

This patch makes os_get_task_size locate the bottom of the address space,
as well as the top.  This is for systems which put a lower limit on mmap
addresses.  It works by manually scanning pages from zero onwards until a
valid page is found.

Because the bottom of the address space may not be zero, it's not
sufficient to assume the top of the address space is the size of the
address space.  The size is the difference between the top address and
bottom address.

[jdike@addtoit.com: changed the name to reflect that this function is
supposed to return the top of the process address space, not its size and
changed the return value to reflect that.  Also some minor formatting
changes]
Signed-off-by: Tom Spink <tspink@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h                    |    2 -
 arch/um/kernel/um_arch.c                |    2 -
 arch/um/os-Linux/sys-i386/task_size.c   |   31 ++++++++++++++++------
 arch/um/os-Linux/sys-x86_64/task_size.c |    2 -
 4 files changed, 26 insertions(+), 11 deletions(-)

diff -puN arch/um/include/os.h~uml-deal-with-inaccessible-address-space-start arch/um/include/os.h
--- a/arch/um/include/os.h~uml-deal-with-inaccessible-address-space-start
+++ a/arch/um/include/os.h
@@ -299,6 +299,6 @@ extern int os_arch_prctl(int pid, int co
 extern int get_pty(void);
 
 /* sys-$ARCH/task_size.c */
-extern unsigned long os_get_task_size(void);
+extern unsigned long os_get_top_address(void);
 
 #endif
diff -puN arch/um/kernel/um_arch.c~uml-deal-with-inaccessible-address-space-start arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-deal-with-inaccessible-address-space-start
+++ a/arch/um/kernel/um_arch.c
@@ -274,7 +274,7 @@ int __init linux_main(int argc, char **a
 	if (have_root == 0)
 		add_arg(DEFAULT_COMMAND_LINE);
 
-	host_task_size = os_get_task_size();
+	host_task_size = os_get_top_address();
 	/*
 	 * TASK_SIZE needs to be PGDIR_SIZE aligned or else exit_mmap craps
 	 * out
diff -puN arch/um/os-Linux/sys-i386/task_size.c~uml-deal-with-inaccessible-address-space-start arch/um/os-Linux/sys-i386/task_size.c
--- a/arch/um/os-Linux/sys-i386/task_size.c~uml-deal-with-inaccessible-address-space-start
+++ a/arch/um/os-Linux/sys-i386/task_size.c
@@ -63,7 +63,7 @@ static int page_ok(unsigned long page)
 	return ok;
 }
 
-unsigned long os_get_task_size(void)
+unsigned long os_get_top_address(void)
 {
 	struct sigaction sa, old;
 	unsigned long bottom = 0;
@@ -76,9 +76,9 @@ unsigned long os_get_task_size(void)
 	 * hosts, but shouldn't hurt otherwise.
 	 */
 	unsigned long top = 0xffffd000 >> UM_KERN_PAGE_SHIFT;
-	unsigned long test;
+	unsigned long test, original;
 
-	printf("Locating the top of the address space ... ");
+	printf("Locating the bottom of the address space ... ");
 	fflush(stdout);
 
 	/*
@@ -89,16 +89,31 @@ unsigned long os_get_task_size(void)
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
 	if (sigaction(SIGSEGV, &sa, &old)) {
-		perror("os_get_task_size");
+		perror("os_get_top_address");
 		exit(1);
 	}
 
-	if (!page_ok(bottom)) {
-		fprintf(stderr, "Address 0x%x no good?\n",
-			bottom << UM_KERN_PAGE_SHIFT);
+	/* Manually scan the address space, bottom-up, until we find
+	 * the first valid page (or run out of them).
+	 */
+	for (bottom = 0; bottom < top; bottom++) {
+		if (page_ok(bottom))
+			break;
+	}
+
+	/* If we've got this far, we ran out of pages. */
+	if (bottom == top) {
+		fprintf(stderr, "Unable to determine bottom of address "
+			"space.\n");
 		exit(1);
 	}
 
+	printf("0x%x\n", bottom << UM_KERN_PAGE_SHIFT);
+	printf("Locating the top of the address space ... ");
+	fflush(stdout);
+
+	original = bottom;
+
 	/* This could happen with a 4G/4G split */
 	if (page_ok(top))
 		goto out;
@@ -114,7 +129,7 @@ unsigned long os_get_task_size(void)
 out:
 	/* Restore the old SIGSEGV handling */
 	if (sigaction(SIGSEGV, &old, NULL)) {
-		perror("os_get_task_size");
+		perror("os_get_top_address");
 		exit(1);
 	}
 	top <<= UM_KERN_PAGE_SHIFT;
diff -puN arch/um/os-Linux/sys-x86_64/task_size.c~uml-deal-with-inaccessible-address-space-start arch/um/os-Linux/sys-x86_64/task_size.c
--- a/arch/um/os-Linux/sys-x86_64/task_size.c~uml-deal-with-inaccessible-address-space-start
+++ a/arch/um/os-Linux/sys-x86_64/task_size.c
@@ -1,4 +1,4 @@
-unsigned long os_get_task_size(unsigned long shift)
+unsigned long os_get_top_address(unsigned long shift)
 {
 	/* The old value of CONFIG_TOP_ADDR */
 	return 0x7fc0000000;
_

Patches currently in -mm which might be from tspink@gmail.com are

origin.patch

