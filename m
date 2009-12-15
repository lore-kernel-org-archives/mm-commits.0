From: akpm@linux-foundation.org
Subject: [merged] kernelh-remove-initialization-of-bool-in-printk_once.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:40 -0800
Message-ID: <200912152155.nBFLteLW015503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933757AbZLOV4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     kernel.h: remove initialization of bool in printk_once
has been removed from the -mm tree.  Its filename was
     kernelh-remove-initialization-of-bool-in-printk_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: remove initialization of bool in printk_once
From: Joe Perches <joe@perches.com>

Don't initialize __print_once.  Invert the test to reduce initialized
data.

defconfig before:	$size vmlinux
   text	   data	    bss	    dec	    hex	filename
6976022	 679572	1359668	9015262	 898fde	vmlinux

defconfig after:	$size vmlinux
   text	   data	    bss	    dec	    hex	filename
6976006	 679508	1359700	9015214	 898fae	vmlinux

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~kernelh-remove-initialization-of-bool-in-printk_once include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-remove-initialization-of-bool-in-printk_once
+++ a/include/linux/kernel.h
@@ -251,10 +251,10 @@ extern int printk_delay_msec;
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
 #define printk_once(x...) ({			\
-	static bool __print_once = true;	\
+	static bool __print_once;		\
 						\
-	if (__print_once) {			\
-		__print_once = false;		\
+	if (!__print_once) {			\
+		__print_once = true;		\
 		printk(x);			\
 	}					\
 })
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

