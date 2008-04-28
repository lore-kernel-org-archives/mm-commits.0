From: akpm@linux-foundation.org
Subject: - arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:02 -0700
Message-ID: <200804282155.m3SLt2e2018068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504AbYD1VzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     arch/um/os-Linux/sys-i386/task_size.c: improve a bit
has been removed from the -mm tree.  Its filename was
     arch-um-os-linux-sys-i386-task_sizec-improve-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/um/os-Linux/sys-i386/task_size.c: improve a bit
From: WANG Cong <xiyou.wangcong@gmail.com>

Improve this code a bit: check sigaction's return value and remove a useless
fflush().

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/sys-i386/task_size.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/um/os-Linux/sys-i386/task_size.c~arch-um-os-linux-sys-i386-task_sizec-improve-a-bit arch/um/os-Linux/sys-i386/task_size.c
--- a/arch/um/os-Linux/sys-i386/task_size.c~arch-um-os-linux-sys-i386-task_sizec-improve-a-bit
+++ a/arch/um/os-Linux/sys-i386/task_size.c
@@ -88,7 +88,10 @@ unsigned long os_get_task_size(void)
 	sa.sa_handler = segfault;
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
-	sigaction(SIGSEGV, &sa, &old);
+	if (sigaction(SIGSEGV, &sa, &old)) {
+		perror("os_get_task_size");
+		exit(1);
+	}
 
 	if (!page_ok(bottom)) {
 		fprintf(stderr, "Address 0x%x no good?\n",
@@ -110,11 +113,12 @@ unsigned long os_get_task_size(void)
 
 out:
 	/* Restore the old SIGSEGV handling */
-	sigaction(SIGSEGV, &old, NULL);
